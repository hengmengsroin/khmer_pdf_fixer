import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../khmer_font_type.dart';
import 'khmer_text.dart';

class KhmerParagraph extends pw.StatelessWidget {
  final String text;
  final KhmerFontType fontType;
  final double fontSize;
  final pw.FontWeight fontWeight;
  final PdfColor color;
  final pw.TextAlign textAlign;

  KhmerParagraph(
    this.text, {
    this.fontType = KhmerFontType.siemreap,
    this.fontSize = 12,
    this.fontWeight = pw.FontWeight.normal,
    this.color = PdfColors.black,
    this.textAlign = pw.TextAlign.justify,
  });

  @override
  pw.Widget build(pw.Context context) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 8),
      child: KhmerText(
        text,
        fontType: fontType,
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        textAlign: textAlign,
      ),
    );
  }
}
