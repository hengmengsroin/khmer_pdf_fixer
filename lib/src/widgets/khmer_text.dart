import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../khmer_fixer_extension.dart';
import '../khmer_font_type.dart';

class KhmerText extends pw.StatelessWidget {
  final String text;
  final KhmerFontType fontType;
  final double fontSize;
  final pw.FontWeight fontWeight;
  final PdfColor color;
  final pw.TextAlign? textAlign;
  final int? maxLines;
  final pw.TextOverflow? overflow;
  final pw.TextDecoration? decoration;
  final pw.Font? fontFallback;

  KhmerText(
    this.text, {
    this.fontType = KhmerFontType.siemreap,
    this.fontSize = 14,
    this.fontWeight = pw.FontWeight.normal,
    this.color = PdfColors.black,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.decoration,
    this.fontFallback,
  });

  @override
  pw.Widget build(pw.Context context) {
    return pw.Text(
      text.fix,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style: fontType.ts(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        decoration: decoration,
        fontFallback: fontFallback,
      ),
    );
  }
}
