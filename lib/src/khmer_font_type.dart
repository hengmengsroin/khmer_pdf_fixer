import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'khmer_fixer_extension.dart';
import 'khmer_font_manager.dart';

enum KhmerFontType {
  siemreap;

  pw.Font get font {
    switch (this) {
      case KhmerFontType.siemreap:
        return KhmerFontManager().siemreap;
    }
  }

  pw.TextStyle ts({
    double? fontSize,
    pw.FontWeight? fontWeight,
    PdfColor? color,
    pw.FontStyle? fontStyle,
    pw.TextDecoration? decoration,
    PdfColor? decorationColor,
    pw.TextDecorationStyle? decorationStyle,
    double? decorationThickness,
    double? lineSpacing,
    double? letterSpacing,
    double? wordSpacing,
    PdfColor? backgroundColor,
    pw.Font? fontFallback,
  }) {
    return pw.TextStyle(
      font: font,
      fontSize: fontSize ?? 14,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      color: color ?? PdfColors.black,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationStyle: decorationStyle,
      decorationThickness: decorationThickness,
      lineSpacing: lineSpacing,
      letterSpacing: letterSpacing,
      wordSpacing: wordSpacing,
      background: backgroundColor != null ? pw.BoxDecoration(color: backgroundColor) : null,
      fontFallback: fontFallback != null ? <pw.Font>[fontFallback] : <pw.Font>[pw.Font.helvetica()],
    );
  }

  pw.Text text(
    String data, {
    double? fontSize,
    pw.FontWeight? fontWeight,
    PdfColor? color,
    pw.TextAlign? textAlign,
    int? maxLines,
    pw.TextOverflow? overflow,
    pw.Font? fontFallback,
  }) {
    return pw.Text(
      data.fix,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style: ts(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        fontFallback: fontFallback,
      ),
    );
  }
}
