// A Khmer-specific visual reorderer for the pdf package, which does not apply
// OpenType shaping. It approximates Khmer syllable ordering closely enough for
// the bundled Siemreap font to render more naturally in PDFs.
class KhmerUnicodeMapper {
  static const int _coeng = 0x17D2;
  static const int _khmerStarterMin = 0x1780;
  static const int _khmerStarterMax = 0x17B3;
  static String? _lastInput;
  static String? _lastOutput;

  /// Entry point to fix Khmer text before rendering in PDF.
  static String fixText(String text) {
    if (text.isEmpty) return text;
    final cachedInput = _lastInput;
    if (cachedInput != null &&
        (identical(text, cachedInput) || text == cachedInput)) {
      return _lastOutput!;
    }

    final length = text.length;
    var index = 0;
    while (index < length) {
      final code = text.codeUnitAt(index);
      if ((code >= _khmerStarterMin && code <= _khmerStarterMax) ||
          (code >= 0x17E0 && code <= 0x17E9) ||
          (code >= 0x17F0 && code <= 0x17F9)) {
        break;
      }
      index++;
    }
    if (index == length) {
      _lastInput = text;
      _lastOutput = text;
      return text;
    }

    final buffer = StringBuffer();
    if (index > 0) {
      buffer.write(text.substring(0, index));
    }

    while (index < length) {
      final char = text.codeUnitAt(index);
      final isStarter =
          (char >= _khmerStarterMin && char <= _khmerStarterMax) ||
          (char >= 0x17E0 && char <= 0x17E9) ||
          (char >= 0x17F0 && char <= 0x17F9);

      if (!isStarter) {
        final chunkStart = index;
        index++;
        while (index < length) {
          final code = text.codeUnitAt(index);
          if ((code >= _khmerStarterMin && code <= _khmerStarterMax) ||
              (code >= 0x17E0 && code <= 0x17E9) ||
              (code >= 0x17F0 && code <= 0x17F9)) {
            break;
          }
          index++;
        }
        buffer.write(text.substring(chunkStart, index));
        continue;
      }

      index = _consumeClusterInto(text, index, buffer);
    }

    final output = buffer.toString();
    _lastInput = text;
    _lastOutput = output;
    return output;
  }

  static int _consumeClusterInto(String text, int start, StringBuffer buffer) {
    final length = text.length;
    final base = text.codeUnitAt(start);
    var hasCoengRo = false;
    int? preVowel;
    int? belowVowel;
    int? shifter;
    int? aboveVowel;
    int? robat;
    int? postVowel;
    List<int>? aboveSigns;
    List<int>? postSigns;
    List<int>? trailingMarks;
    List<int>? subscripts;
    var index = start + 1;

    while (index < length) {
      final char = text.codeUnitAt(index);

      if ((char >= _khmerStarterMin && char <= _khmerStarterMax) ||
          (char >= 0x17E0 && char <= 0x17E9) ||
          (char >= 0x17F0 && char <= 0x17F9)) {
        break;
      }

      if (char == _coeng && index + 1 < length) {
        final consonant = text.codeUnitAt(index + 1);
        if (consonant >= 0x1780 && consonant <= 0x17A2) {
          if (consonant == 0x179A) {
            hasCoengRo = true;
          } else {
            final mapped = _subscriptMap[consonant];
            if (mapped != null) {
              (subscripts ??= <int>[]).add(mapped);
            } else {
              final list = subscripts ??= <int>[];
              list.add(_coeng);
              list.add(consonant);
            }
          }
          index += 2;
          continue;
        }
      }

      if (char >= 0x17C1 && char <= 0x17C3) {
        preVowel ??= char;
        index++;
        continue;
      }

      if (char == 0x17BE) {
        preVowel ??= 0x17C1;
        aboveVowel ??= 0x17B8;
        index++;
        continue;
      }
      if (char == 0x17BF || char == 0x17C0 || char == 0x17C5) {
        preVowel ??= 0x17C1;
        postVowel ??= char;
        index++;
        continue;
      }
      if (char == 0x17C4) {
        preVowel ??= 0x17C1;
        postVowel ??= 0x17B6;
        index++;
        continue;
      }

      if (char >= 0x17BB && char <= 0x17BD) {
        belowVowel ??= char;
        index++;
        continue;
      }

      if (char >= 0x17B7 && char <= 0x17BA) {
        aboveVowel ??= char;
        index++;
        continue;
      }

      if (char == 0x17C9 || char == 0x17CA) {
        shifter ??= char;
        index++;
        continue;
      }

      if (char == 0x17CC) {
        robat = char;
        index++;
        continue;
      }

      if (char == 0x17C6 ||
          char == 0x17CB ||
          (char >= 0x17CD && char <= 0x17D1) ||
          char == 0x17DD) {
        (aboveSigns ??= <int>[]).add(char);
        index++;
        continue;
      }

      if (char == 0x17C7 || char == 0x17C8) {
        (postSigns ??= <int>[]).add(char);
        index++;
        continue;
      }

      if (char >= 0x17B6 && char <= 0x17DD) {
        (trailingMarks ??= <int>[]).add(char);
        index++;
        continue;
      }

      break;
    }

    if (preVowel != null) {
      buffer.writeCharCode(preVowel);
    }
    if (hasCoengRo) {
      buffer.write('\u{E01A}');
    }
    buffer.writeCharCode(base);

    if (robat != null) {
      buffer.writeCharCode(robat);
    }
    if (shifter != null && aboveVowel == null) {
      buffer.writeCharCode(shifter);
    }
    if (subscripts != null) {
      for (final subscript in subscripts) {
        buffer.writeCharCode(subscript);
      }
    }
    if (belowVowel != null) {
      buffer.writeCharCode(belowVowel);
    }
    if (shifter != null && aboveVowel != null) {
      buffer.writeCharCode(shifter);
    }
    if (aboveVowel != null) {
      buffer.writeCharCode(aboveVowel);
    }
    if (aboveSigns != null) {
      for (final sign in aboveSigns) {
        buffer.writeCharCode(sign);
      }
    }
    if (postVowel != null) {
      buffer.writeCharCode(postVowel);
    }
    if (postSigns != null) {
      for (final sign in postSigns) {
        buffer.writeCharCode(sign);
      }
    }
    if (trailingMarks != null) {
      for (final mark in trailingMarks) {
        buffer.writeCharCode(mark);
      }
    }

    return index;
  }

  static const _subscriptMap = <int, int>{
    0x1780: 0xE000,
    0x1781: 0xE001,
    0x1782: 0xE002,
    0x1783: 0xE003,
    0x1784: 0xE004,
    0x1785: 0xE005,
    0x1786: 0xE006,
    0x1787: 0xE007,
    0x1788: 0xE008,
    0x1789: 0xE009,
    0x178A: 0xE00A,
    0x178B: 0xE00B,
    0x178C: 0xE00C,
    0x178D: 0xE00D,
    0x178E: 0xE00E,
    0x178F: 0xE00F,
    0x1790: 0xE010,
    0x1791: 0xE011,
    0x1792: 0xE012,
    0x1793: 0xE013,
    0x1794: 0xE014,
    0x1795: 0xE015,
    0x1796: 0xE016,
    0x1797: 0xE017,
    0x1798: 0xE018,
    0x1799: 0xE019,
    0x179A: 0xE01A,
    0x179B: 0xE01B,
    0x179C: 0xE01C,
    0x179D: 0xE01D,
    0x179E: 0xE01E,
    0x179F: 0xE01F,
    0x17A0: 0xE020,
    0x17A1: 0xE021,
    0x17A2: 0xE022,
  };
}
