import 'dart:math';

import 'package:khmer_pdf_fixer/src/utils/khmer_unicode_mapper.dart';

void main() {
  final khmerSamples = <String>[
    '\u1781\u17D2\u1798\u17C2',
    '\u1794\u17D2\u179A\u17BE',
    '\u1792\u17CC\u17C4',
    '\u1780\u17D2\u179A\u17C1',
    '\u1780\u17BF',
    '\u1780\u17C1',
  ];

  final rng = Random(42);
  final lines = List<String>.generate(6000, (i) {
    final sample = khmerSamples[rng.nextInt(khmerSamples.length)];
    return 'INV-${i.toString().padLeft(4, '0')} $sample Qty:${(i % 9) + 1}';
  });

  final input = lines.join('\n');

  // Warmup
  for (var i = 0; i < 200; i++) {
    KhmerUnicodeMapper.fixText(input);
  }

  const runs = 120;
  final sw = Stopwatch()..start();
  var checksum = 0;

  for (var i = 0; i < runs; i++) {
    checksum ^= KhmerUnicodeMapper.fixText(input).length;
  }

  sw.stop();

  final totalMs = sw.elapsedMicroseconds / 1000.0;
  final avgMs = totalMs / runs;

  print(
    'runs=$runs total_ms=${totalMs.toStringAsFixed(2)} avg_ms=${avgMs.toStringAsFixed(3)} checksum=$checksum',
  );
}
