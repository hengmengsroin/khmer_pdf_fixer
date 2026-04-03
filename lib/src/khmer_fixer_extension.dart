import 'utils/khmer_unicode_mapper.dart';

extension KhmerPdfTextFixer on String {
  /// Fixes broken Khmer characters for PDF rendering.
  /// 
  /// The [pdf] package lacking native text shaping renders complex Khmer 
  /// subscripts and pre-vowels incorrectly. This property applies
  /// heuristic reordering to fix horizontal and basic vertical flows 
  /// before rendering.
  String get fix => KhmerUnicodeMapper.fixText(this);
}
