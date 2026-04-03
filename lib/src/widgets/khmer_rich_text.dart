import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../khmer_fixer_extension.dart';
import '../khmer_font_type.dart';

class KhmerTextSpan extends pw.TextSpan {
  final KhmerFontType fontType;

  KhmerTextSpan({
    required String text,
    this.fontType = KhmerFontType.siemreap,
    double fontSize = 14,
    pw.FontWeight fontWeight = pw.FontWeight.normal,
    PdfColor color = PdfColors.black,
    pw.TextDecoration? decoration,
    pw.Font? fontFallback,
  }) : super(
          text: text.fix,
          style: fontType.ts(
            fontSize: fontSize,
            fontWeight: fontWeight,
            color: color,
            decoration: decoration,
            fontFallback: fontFallback,
          ),
        );
}

class KhmerRichText extends pw.StatelessWidget {
  final List<KhmerTextSpan> spans;
  final pw.TextAlign? textAlign;
  final int? maxLines;
  final pw.TextOverflow? overflow;

  KhmerRichText({
    required this.spans,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  @override
  pw.Widget build(pw.Context context) {
    return pw.RichText(
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      text: pw.TextSpan(children: spans),
    );
  }
}
