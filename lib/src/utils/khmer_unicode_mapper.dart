// A Khmer-specific visual reorderer for the pdf package, which does not apply
// OpenType shaping. It approximates Khmer syllable ordering closely enough for
// the bundled Siemreap font to render more naturally in PDFs.
class KhmerUnicodeMapper {
  static const int _coeng = 0x17D2;
  static const int _robat = 0x17CC;
  static const int _sraE = 0x17C1;

  /// Entry point to fix Khmer text before rendering in PDF.
  static String fixText(String text) {
    if (text.isEmpty) return text;

    final lines = text.split('\n');
    return lines.map(_reorderLine).join('\n');
  }

  static String _reorderLine(String line) {
    if (line.isEmpty) return line;

    final chars = line.runes.toList();
    final buffer = StringBuffer();
    var index = 0;

    while (index < chars.length) {
      final char = chars[index];

      if (!_isKhmerClusterStarter(char)) {
        buffer.writeCharCode(char);
        index++;
        continue;
      }

      final cluster = _consumeCluster(chars, index);
      buffer.write(cluster.text);
      index = cluster.nextIndex;
    }

    return buffer.toString();
  }

  static _ClusterResult _consumeCluster(List<int> chars, int start) {
    final syllable = _KhmerSyllable(base: chars[start]);
    var index = start + 1;

    while (index < chars.length) {
      final char = chars[index];

      if (_isKhmerClusterStarter(char)) {
        break;
      }

      if (_isCoeng(char) &&
          index + 1 < chars.length &&
          _isKhmerConsonant(chars[index + 1])) {
        final consonant = chars[index + 1];
        if (consonant == 0x179A) {
          syllable.hasCoengRo = true;
        } else {
          syllable.subscripts.add(_subscriptMap['${String.fromCharCode(char)}${String.fromCharCode(consonant)}'] ?? String.fromCharCodes([char, consonant]));
        }
        index += 2;
        continue;
      }

      if (_isPreVowel(char)) {
        syllable.preVowel ??= char;
        index++;
        continue;
      }

      final split = _splitVowel(char);
      if (split != null) {
        syllable.preVowel ??= split.pre;
        if (split.above != null) {
          syllable.aboveVowel ??= split.above;
        }
        if (split.post != null) {
          syllable.postVowel ??= split.post;
        }
        index++;
        continue;
      }

      if (_isBelowVowel(char)) {
        syllable.belowVowel ??= char;
        index++;
        continue;
      }

      if (_isAboveVowel(char)) {
        syllable.aboveVowel ??= char;
        index++;
        continue;
      }

      if (_isRegisterShifter(char)) {
        syllable.shifter ??= char;
        index++;
        continue;
      }

      if (_isRobat(char)) {
        syllable.robat = char;
        index++;
        continue;
      }

      if (_isAboveSign(char)) {
        syllable.aboveSigns.add(char);
        index++;
        continue;
      }

      if (_isPostSign(char)) {
        syllable.postSigns.add(char);
        index++;
        continue;
      }

      if (_isKhmerCombiningMark(char)) {
        syllable.trailingMarks.add(char);
        index++;
        continue;
      }

      break;
    }

    return _ClusterResult(
      text: syllable.toVisualOrder(),
      nextIndex: index,
    );
  }

  static _SplitVowel? _splitVowel(int char) {
    switch (char) {
      case 0x17BE:
        return const _SplitVowel(pre: _sraE, above: 0x17B8);
      case 0x17BF:
        return const _SplitVowel(pre: _sraE, post: 0x17BF);
      case 0x17C0:
        return const _SplitVowel(pre: _sraE, post: 0x17C0);
      case 0x17C4:
        return const _SplitVowel(pre: _sraE, post: 0x17B6);
      case 0x17C5:
        return const _SplitVowel(pre: _sraE, post: 0x17C5);
    }
    return null;
  }

  static bool _isKhmerClusterStarter(int code) {
    return _isKhmerConsonant(code) || _isKhmerIndependentVowel(code) || _isKhmerNumber(code);
  }

  static bool _isKhmerConsonant(int code) => code >= 0x1780 && code <= 0x17A2;

  static bool _isKhmerIndependentVowel(int code) => code >= 0x17A3 && code <= 0x17B3;

  static bool _isKhmerNumber(int code) =>
      (code >= 0x17E0 && code <= 0x17E9) || (code >= 0x17F0 && code <= 0x17F9);

  static bool _isCoeng(int code) => code == _coeng;

  static bool _isRobat(int code) => code == _robat;

  static bool _isPreVowel(int code) => code >= 0x17C1 && code <= 0x17C3;

  static bool _isAboveVowel(int code) => code >= 0x17B7 && code <= 0x17BA;

  static bool _isBelowVowel(int code) => code >= 0x17BB && code <= 0x17BD;

  static bool _isRegisterShifter(int code) => code == 0x17C9 || code == 0x17CA;

  static bool _isAboveSign(int code) =>
      code == 0x17C6 ||
      code == 0x17CB ||
      (code >= 0x17CD && code <= 0x17D1) ||
      code == 0x17DD;

  static bool _isPostSign(int code) => code == 0x17C7 || code == 0x17C8;

  static bool _isKhmerCombiningMark(int code) => code >= 0x17B6 && code <= 0x17DD;

  static const _subscriptMap = {
    "\u17D2\u1780": "\u{E000}",
    "\u17D2\u1781": "\u{E001}",
    "\u17D2\u1782": "\u{E002}",
    "\u17D2\u1783": "\u{E003}",
    "\u17D2\u1784": "\u{E004}",
    "\u17D2\u1785": "\u{E005}",
    "\u17D2\u1786": "\u{E006}",
    "\u17D2\u1787": "\u{E007}",
    "\u17D2\u1788": "\u{E008}",
    "\u17D2\u1789": "\u{E009}",
    "\u17D2\u178A": "\u{E00A}",
    "\u17D2\u178B": "\u{E00B}",
    "\u17D2\u178C": "\u{E00C}",
    "\u17D2\u178D": "\u{E00D}",
    "\u17D2\u178E": "\u{E00E}",
    "\u17D2\u178F": "\u{E00F}",
    "\u17D2\u1790": "\u{E010}",
    "\u17D2\u1791": "\u{E011}",
    "\u17D2\u1792": "\u{E012}",
    "\u17D2\u1793": "\u{E013}",
    "\u17D2\u1794": "\u{E014}",
    "\u17D2\u1795": "\u{E015}",
    "\u17D2\u1796": "\u{E016}",
    "\u17D2\u1797": "\u{E017}",
    "\u17D2\u1798": "\u{E018}",
    "\u17D2\u1799": "\u{E019}",
    "\u17D2\u179A": "\u{E01A}",
    "\u17D2\u179B": "\u{E01B}",
    "\u17D2\u179C": "\u{E01C}",
    "\u17D2\u179D": "\u{E01D}",
    "\u17D2\u179E": "\u{E01E}",
    "\u17D2\u179F": "\u{E01F}",
    "\u17D2\u17A0": "\u{E020}",
    "\u17D2\u17A1": "\u{E021}",
    "\u17D2\u17A2": "\u{E022}",
  };
}

class _ClusterResult {
  const _ClusterResult({
    required this.text,
    required this.nextIndex,
  });

  final String text;
  final int nextIndex;
}

class _SplitVowel {
  const _SplitVowel({
    required this.pre,
    this.above,
    this.post,
  });

  final int pre;
  final int? above;
  final int? post;
}

class _KhmerSyllable {
  _KhmerSyllable({required this.base});

  final int base;
  bool hasCoengRo = false;
  int? preVowel;
  int? belowVowel;
  int? shifter;
  int? aboveVowel;
  int? robat;
  int? postVowel;
  final List<int> aboveSigns = [];
  final List<int> postSigns = [];
  final List<int> trailingMarks = [];
  final List<String> subscripts = [];

  String toVisualOrder() {
    final buffer = StringBuffer();

    if (preVowel != null) {
      buffer.writeCharCode(preVowel!);
    }
    if (hasCoengRo) {
      buffer.write('\u{E01A}');
    }

    buffer.writeCharCode(base);

    if (robat != null) {
      buffer.writeCharCode(robat!);
    }

    if (shifter != null && aboveVowel == null) {
      buffer.writeCharCode(shifter!);
    }

    for (final subscript in subscripts) {
      buffer.write(subscript);
    }

    if (belowVowel != null) {
      buffer.writeCharCode(belowVowel!);
    }

    if (shifter != null && aboveVowel != null) {
      buffer.writeCharCode(shifter!);
    }

    if (aboveVowel != null) {
      buffer.writeCharCode(aboveVowel!);
    }

    for (final sign in aboveSigns) {
      buffer.writeCharCode(sign);
    }

    if (postVowel != null) {
      buffer.writeCharCode(postVowel!);
    }

    for (final sign in postSigns) {
      buffer.writeCharCode(sign);
    }

    for (final mark in trailingMarks) {
      buffer.writeCharCode(mark);
    }

    return buffer.toString();
  }
}
