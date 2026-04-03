import 'dart:ui' as ui;

import 'package:flutter/material.dart' as material;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class KhmerTextRaster {
  static Future<pw.Image> create(
    String text, {
    double fontSize = 14,
    pw.FontWeight fontWeight = pw.FontWeight.normal,
    PdfColor color = PdfColors.black,
    pw.TextAlign textAlign = pw.TextAlign.left,
    double? maxWidth,
    double lineHeight = 1.25,
    double scale = 3,
  }) async {
    final painter = material.TextPainter(
      text: material.TextSpan(
        text: text,
        style: material.TextStyle(
          fontFamily: 'Siemreap',
          package: 'khmer_pdf_fixer',
          fontSize: fontSize,
          fontWeight: fontWeight == pw.FontWeight.bold
              ? material.FontWeight.w700
              : material.FontWeight.w400,
          color: _toFlutterColor(color),
          height: lineHeight,
        ),
      ),
      textAlign: _toFlutterTextAlign(textAlign),
      textDirection: ui.TextDirection.ltr,
    );

    painter.layout(maxWidth: maxWidth ?? double.infinity);

    final width = painter.width.ceil().clamp(1, 100000);
    final height = painter.height.ceil().clamp(1, 100000);
    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(recorder);

    canvas.scale(scale, scale);
    painter.paint(canvas, ui.Offset.zero);

    final image = await recorder.endRecording().toImage(
          (width * scale).ceil(),
          (height * scale).ceil(),
        );
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final bytes = byteData!.buffer.asUint8List();

    return pw.Image(
      pw.MemoryImage(bytes),
      width: width.toDouble(),
      height: height.toDouble(),
    );
  }

  static Future<pw.Widget> bulletItem(
    String text, {
    double fontSize = 14,
    PdfColor color = PdfColors.black,
    double bulletSize = 6,
    double gap = 8,
    double? maxWidth,
  }) async {
    final textWidget = await create(
      text,
      fontSize: fontSize,
      color: color,
      maxWidth: maxWidth,
    );

    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Container(
          width: bulletSize + gap,
          padding: pw.EdgeInsets.only(top: fontSize * 0.55),
          child: pw.Container(
            width: bulletSize,
            height: bulletSize,
            decoration: pw.BoxDecoration(
              color: color,
              shape: pw.BoxShape.circle,
            ),
          ),
        ),
        pw.Expanded(child: textWidget),
      ],
    );
  }

  static Future<pw.Widget> tableCell(
    String text, {
    required double maxWidth,
    double fontSize = 12,
    pw.FontWeight fontWeight = pw.FontWeight.normal,
    PdfColor color = PdfColors.black,
    pw.TextAlign textAlign = pw.TextAlign.center,
  }) {
    return create(
      text,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      textAlign: textAlign,
      maxWidth: maxWidth,
    );
  }

  static material.Color _toFlutterColor(PdfColor color) {
    return material.Color.fromARGB(
      (color.alpha * 255).round(),
      (color.red * 255).round(),
      (color.green * 255).round(),
      (color.blue * 255).round(),
    );
  }

  static material.TextAlign _toFlutterTextAlign(pw.TextAlign textAlign) {
    switch (textAlign) {
      case pw.TextAlign.right:
        return material.TextAlign.right;
      case pw.TextAlign.center:
        return material.TextAlign.center;
      case pw.TextAlign.justify:
        return material.TextAlign.justify;
      case pw.TextAlign.end:
        return material.TextAlign.end;
      case pw.TextAlign.start:
        return material.TextAlign.start;
      case pw.TextAlign.left:
        return material.TextAlign.left;
    }
  }
}
