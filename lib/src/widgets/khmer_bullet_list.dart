import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../khmer_font_type.dart';
import 'khmer_text.dart';

class KhmerBulletList extends pw.StatelessWidget {
  final List<String> items;
  final String bullet;
  final KhmerFontType fontType;
  final double fontSize;
  final pw.FontWeight fontWeight;
  final PdfColor color;

  KhmerBulletList({
    required this.items,
    this.bullet = '•',
    this.fontType = KhmerFontType.siemreap,
    this.fontSize = 14,
    this.fontWeight = pw.FontWeight.normal,
    this.color = PdfColors.black,
  });

  @override
  pw.Widget build(pw.Context context) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: items.map((item) {
        return pw.Padding(
          padding: const pw.EdgeInsets.only(bottom: 4),
          child: pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Container(
                width: 15,
                padding: const pw.EdgeInsets.only(top: 6),
                child: pw.Container(
                  width: 4,
                  height: 4,
                  decoration: pw.BoxDecoration(
                    shape: pw.BoxShape.circle,
                    color: color,
                  ),
                ),
              ),
              pw.Expanded(
                child: KhmerText(
                  item,
                  fontType: fontType,
                  fontSize: fontSize,
                  fontWeight: fontWeight,
                  color: color,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
