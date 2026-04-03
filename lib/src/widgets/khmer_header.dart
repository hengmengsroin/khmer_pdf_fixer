import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../khmer_font_type.dart';
import 'khmer_text.dart';

class KhmerHeader extends pw.StatelessWidget {
  final String text;
  final KhmerFontType fontType;
  final double fontSize;
  final PdfColor color;
  final pw.TextAlign? textAlign;

  KhmerHeader(
    this.text, {
    this.fontType = KhmerFontType.siemreap,
    this.fontSize = 24,
    this.color = PdfColors.black,
    this.textAlign,
  });

  @override
  pw.Widget build(pw.Context context) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 10),
      child: KhmerText(
        text,
        fontType: fontType,
        fontSize: fontSize,
        fontWeight: pw.FontWeight.bold,
        color: color,
        textAlign: textAlign,
      ),
    );
  }
}
