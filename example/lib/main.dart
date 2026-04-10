import 'dart:io';
import 'package:flutter/material.dart';
import 'package:khmer_pdf_fixer/khmer_pdf_fixer.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Khmer PDF Fixer Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const DemoPage(),
    );
  }
}

class DemoPage extends StatefulWidget {
  const DemoPage({super.key});

  @override
  State<DemoPage> createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  bool _isGenerating = false;

  List<pw.Widget> _buildTextContent() {
    const tableWidth = 480.0;
    const col1 = 80.0;
    const col2 = 170.0;
    const col3 = 80.0;
    const col4 = 100.0;

    final header = KhmerHeader(
      'វិក្កយបត្រ (Invoice)',
      fontSize: 28,
      color: PdfColors.blue800,
      textAlign: pw.TextAlign.center,
    );

    final paragraph = KhmerParagraph(
      'សូមស្វាគមន៍មកកាន់ប្រព័ន្ធរបស់យើង។ នេះគឺជាឧទាហរណ៍នៃការប្រើប្រាស់ Khmer PDF Fixer ដើម្បីបង្ហាញអក្សរខ្មែរឲ្យបានត្រឹមត្រូវ។',
      fontSize: 14,
      textAlign: pw.TextAlign.justify,
    );

    final richTextLine = KhmerRichText(
      spans: [
        KhmerTextSpan(text: 'នេះគឺជា ', fontSize: 14),
        KhmerTextSpan(
          text: 'អត្ថបទដិត',
          fontSize: 14,
          fontWeight: pw.FontWeight.bold,
          color: PdfColors.red,
        ),
        KhmerTextSpan(text: ' និងអត្ថបទធម្មតា។', fontSize: 14),
      ],
    );

    final featureHeader = KhmerHeader('លក្ខណៈពិសេស៖', fontSize: 18);

    final bullets = KhmerBulletList(
      items: const [
        'បង្ហាញពុម្ពអក្សរខ្មែរបានត្រឹមត្រូវ',
        'គាំទ្រតារាង និងបញ្ជី',
        'ងាយស្រួលប្រើប្រាស់ជាមួយ pdf package',
      ],
      fontSize: 14,
    );

    final tableHeader = KhmerHeader('តារាងទិន្នន័យ៖', fontSize: 18);

    final tableRows = <List<String>>[
      ['លេខរៀង', 'ឈ្មោះមុខទំនិញ', 'បរិមាណ', 'តម្លៃសរុប'],
      ['១', 'កុំព្យូទ័រយួរដៃ', '២', '\$២០០០'],
      ['២', 'ទូរស័ព្ទដៃស៊េរីទំនើប', '៥', '\$៥០០០'],
      ['៣', 'កាសស្តាប់ត្រចៀក', '១០', '\$២០០'],
    ];

    final table = pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey, width: 1),
      columnWidths: const {
        0: pw.FixedColumnWidth(col1),
        1: pw.FixedColumnWidth(col2),
        2: pw.FixedColumnWidth(col3),
        3: pw.FixedColumnWidth(col4),
      },
      children: [
        for (var rowIndex = 0; rowIndex < tableRows.length; rowIndex++)
          pw.TableRow(
            decoration: rowIndex == 0
                ? const pw.BoxDecoration(color: PdfColors.blue100)
                : null,
            children: [
              pw.Padding(
                padding: const pw.EdgeInsets.all(8),
                child: KhmerText(
                  tableRows[rowIndex][0],
                  fontSize: 12,
                  fontWeight: rowIndex == 0
                      ? pw.FontWeight.bold
                      : pw.FontWeight.normal,
                  textAlign: pw.TextAlign.center,
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(8),
                child: KhmerText(
                  tableRows[rowIndex][1],
                  fontSize: 12,
                  fontWeight: rowIndex == 0
                      ? pw.FontWeight.bold
                      : pw.FontWeight.normal,
                  textAlign: pw.TextAlign.center,
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(8),
                child: KhmerText(
                  tableRows[rowIndex][2],
                  fontSize: 12,
                  fontWeight: rowIndex == 0
                      ? pw.FontWeight.bold
                      : pw.FontWeight.normal,
                  textAlign: pw.TextAlign.center,
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(8),
                child: KhmerText(
                  tableRows[rowIndex][3],
                  fontSize: 12,
                  fontWeight: rowIndex == 0
                      ? pw.FontWeight.bold
                      : pw.FontWeight.normal,
                  textAlign: pw.TextAlign.center,
                ),
              ),
            ],
          ),
      ],
    );

    final thankYou = KhmerText(
      'សូមអរគុណ!',
      fontSize: 20,
      fontWeight: pw.FontWeight.bold,
      color: PdfColors.green700,
      textAlign: pw.TextAlign.center,
    );

    return [
      header,
      pw.SizedBox(height: 12),
      paragraph,
      pw.SizedBox(height: 20),
      richTextLine,
      pw.SizedBox(height: 20),
      featureHeader,
      bullets,
      pw.SizedBox(height: 30),
      tableHeader,
      pw.SizedBox(height: 10),
      pw.Center(
        child: pw.SizedBox(width: tableWidth, child: table),
      ),
      pw.SizedBox(height: 30),
      pw.Center(child: thankYou),
    ];
  }

  Future<void> _generatePdf() async {
    setState(() => _isGenerating = true);
    try {
      // 1. Initialize the font manager
      await KhmerFontManager().initialize();

      // 2. Create a PDF document
      final pdf = pw.Document();
      final content = _buildTextContent();

      // 3. Add a page
      pdf.addPage(
        pw.MultiPage(pageFormat: PdfPageFormat.a4, build: (context) => content),
      );

      // Save and open
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/khmer_demo.pdf');
      await file.writeAsBytes(await pdf.save());

      await OpenFile.open(file.path);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error generating PDF: $e')));
      }
    } finally {
      if (mounted) setState(() => _isGenerating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Khmer PDF Fixer Example')),
      body: Center(
        child: _isGenerating
            ? const CircularProgressIndicator()
            : ElevatedButton.icon(
                onPressed: _generatePdf,
                icon: const Icon(Icons.picture_as_pdf),
                label: const Text('Generate Khmer PDF'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  textStyle: const TextStyle(fontSize: 18),
                ),
              ),
      ),
    );
  }
}
