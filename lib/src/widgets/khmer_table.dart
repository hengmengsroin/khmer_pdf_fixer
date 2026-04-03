import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../khmer_font_type.dart';
import 'khmer_text.dart';

class KhmerTable extends pw.StatelessWidget {
  final List<List<String>> data;
  final KhmerFontType fontType;
  final double fontSize;
  final pw.FontWeight fontWeight;
  final PdfColor textColor;
  final PdfColor borderColor;
  final PdfColor headerColor;
  final bool hasHeader;

  KhmerTable({
    required this.data,
    this.fontType = KhmerFontType.siemreap,
    this.fontSize = 12,
    this.fontWeight = pw.FontWeight.normal,
    this.textColor = PdfColors.black,
    this.borderColor = PdfColors.grey,
    this.headerColor = PdfColors.grey300,
    this.hasHeader = true,
  });

  @override
  pw.Widget build(pw.Context context) {
    if (data.isEmpty) return pw.SizedBox();

    return pw.Table(
      border: pw.TableBorder.all(color: borderColor, width: 1),
      children: List<pw.TableRow>.generate(data.length, (rowIndex) {
        final isHeader = hasHeader && rowIndex == 0;
        final rowData = data[rowIndex];

        return pw.TableRow(
          decoration: isHeader ? pw.BoxDecoration(color: headerColor) : null,
          children: rowData.map((cellText) {
            return pw.Padding(
              padding: const pw.EdgeInsets.all(5),
              child: KhmerText(
                cellText,
                fontType: fontType,
                fontSize: fontSize,
                fontWeight: isHeader ? pw.FontWeight.bold : fontWeight,
                color: textColor,
                textAlign: pw.TextAlign.center,
              ),
            );
          }).toList(),
        );
      }),
    );
  }
}
