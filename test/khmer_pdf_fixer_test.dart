import 'package:flutter_test/flutter_test.dart';
import 'package:khmer_pdf_fixer/khmer_pdf_fixer.dart';
import 'package:khmer_pdf_fixer/src/utils/khmer_unicode_mapper.dart';

String _runes(String value) =>
    value.runes.map((r) => 'U+${r.toRadixString(16).padLeft(4, '0')}').join(' ');

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Khmer Unicode Reshaper', () {
    test('Moves pre-vowel to before isolated consonant', () {
      // កេ (Ka + E)
      // Visual order should be េក
      final input = '\u1780\u17C1';
      final expected = '\u17C1\u1780';
      
      expect(KhmerUnicodeMapper.fixText(input), equals(expected));
    });

    test('Moves pre-vowel over simple consonant cluster with Coeng', () {
      // ខ្មែ (Ka + Coeng + Mo + Ae)
      // Visual order should be ែខ្ម
      final input = '\u1781\u17D2\u1798\u17C2';
      // Expect Pre-vowel + Base Consonant + Subscript PUA
      final expected = '\u17C2\u1781\uE018';
      
      expect(KhmerUnicodeMapper.fixText(input), equals(expected));
    });
    
    test('Splits OO vowel and reorders it around Robat correctly', () {
      // ធ៌ោ (Tho + Robat + OO)
      // Visual order for non-shaping rendering becomes: E-part + base + robat + AA-part
      final input = '\u1792\u17CC\u17C4';
      final expected = '\u17C1\u1792\u17CC\u17B6';

      expect(KhmerUnicodeMapper.fixText(input), equals(expected));
    });

    test('Reorders Coeng Ro to appear before base consonant', () {
      // ប្រ (Ba + Coeng + Ro)
      // Visual order: Coeng Ro PUA + Ba
      final input = '\u1794\u17D2\u179A';
      final expected = '\uE01A\u1794';
      
      expect(KhmerUnicodeMapper.fixText(input), equals(expected));
    });

    test('String extension integrates with fixText', () {
      final input = '\u1781\u17D2\u1798\u17C2'; // Kha + Coeng + Mo + Ae
      final expected = '\u17C2\u1781\uE018'; // Ae + Kha +  Coeng Mo PUA
      
      expect(input.fix, equals(expected));
    });
    
    test('Non-Khmer text remains unchanged', () {
      final input = 'Hello World';
      expect(input.fix, equals(input));
    });

    test('Preserves line breaks while fixing each line independently', () {
      final input = '\u1780\u17C1\n\u1794\u17D2\u179A'; // កេ\nប្រ
      final expected = '\u17C1\u1780\n\uE01A\u1794';

      expect(
        KhmerUnicodeMapper.fixText(input),
        equals(expected),
        reason: 'Expected ${_runes(expected)}',
      );
    });

    test('Keeps mixed Latin and Khmer text stable outside Khmer clusters', () {
      final input = 'ABC \u1780\u17C1 123'; // ABC កេ 123
      final expected = 'ABC \u17C1\u1780 123';

      expect(
        input.fix,
        equals(expected),
        reason: 'Expected ${_runes(expected)}',
      );
    });

    test('Fixing is idempotent for already transformed Khmer text', () {
      final fixed = '\u17C2\u1781\uE018'; // ែខ + coeng mo PUA
      expect(fixed.fix, equals(fixed), reason: 'Expected ${_runes(fixed)}');
    });

    test('Reorders pre-vowel with Coeng Ro cluster correctly', () {
      final input = '\u1780\u17D2\u179A\u17C1'; // ក្រេ
      final expected = '\u17C1\uE01A\u1780';

      expect(
        input.fix,
        equals(expected),
        reason: 'Expected ${_runes(expected)}',
      );
    });

    test('Splits OE vowel into pre-base and above-base parts', () {
      final input = '\u1794\u17D2\u179A\u17BE'; // ប្រើ
      final expected = '\u17C1\uE01A\u1794\u17B8';

      expect(
        input.fix,
        equals(expected),
        reason: 'Expected ${_runes(expected)}',
      );
    });

    test('Splits YA vowel into pre-base and post-base parts', () {
      final input = '\u1780\u17BF'; // កឿ
      final expected = '\u17C1\u1780\u17BF';

      expect(
        input.fix,
        equals(expected),
        reason: 'Expected ${_runes(expected)}',
      );
    });

    test('Splits OO vowel into pre-base and AA parts', () {
      final input = '\u1780\u17C4'; // កោ
      final expected = '\u17C1\u1780\u17B6';

      expect(
        input.fix,
        equals(expected),
        reason: 'Expected ${_runes(expected)}',
      );
    });

    test('Maps representative coeng consonants into Khmer PUA glyphs', () {
      final cases = <({String input, String expected})>[
        (input: '\u1794\u17D2\u17A0', expected: '\u1794\uE020'),
        (input: '\u1780\u17D2\u1794\u17D2\u179F', expected: '\u1780\uE014\uE01F'),
        (input: '\u1781\u17D2\u1798', expected: '\u1781\uE018'),
      ];

      for (final c in cases) {
        expect(
          KhmerUnicodeMapper.fixText(c.input),
          equals(c.expected),
          reason: 'Input ${_runes(c.input)} should become ${_runes(c.expected)}',
        );
      }
    });
  });
}
