# Khmer PDF Fixer 🇰🇭

**Khmer PDF Fixer** is a Flutter package designed to **fix broken Khmer fonts in PDFs**, ensuring accurate rendering of Khmer characters with the **Siemreap** font.

A lightweight, focused solution for Khmer font issues.

![Khmer PDF Fixer](https://raw.githubusercontent.com/arrahmanbd/bangla_pdf_fixer/master/images/pdf_fixer.png) <!-- Update image later -->

---

## Features

* **Siemreap font** included for customized PDF text.
* Automatically processes and **fixes complex Khmer characters** for correct display inside `pdf` generation.
* Seamless integration with **Flutter PDF generation workflows**.
* Ready-to-use **Khmer widgets**: text, rich text, headers, paragraphs, bullet lists, and tables.

---

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  khmer_pdf_fixer: ^0.0.1
```

Install packages:

```bash
flutter pub get
```

---

## Usage ✨

> **[Note] KhmerFontType: 🎨**
> The `KhmerFontType` class provides the `siemreap` font for PDF generation. It simplifies working with Khmer text in Flutter by providing **ready-to-use `pw.TextStyle` and `pw.Text` widgets**, making font assignment seamless and reducing boilerplate.

---

### Step 1: Initialize Fonts

Before using any widgets, initialize the font manager:

```dart
await KhmerFontManager().initialize();
```

This ensures the fonts are loaded and ready for use.

---

### Step 2: Fix Khmer Text in PDFs

Use the `.fix` extension to process Khmer text:

```dart
KhmerText(
  'អត្ថបទជាភាសាខ្មែរ',
  fontType: KhmerFontType.siemreap,
  fontSize: 20,
),
pw.SizedBox(height: 10),
pw.Text(
  'សួស្តី'.fix,
  style: KhmerFontType.siemreap.ts(
    fontSize: 24,
    fontWeight: pw.FontWeight.bold,
    color: PdfColors.red,
  ),
),
```

> Most widgets apply `.fix` internally, so manual usage is optional. 

---

## Example: Generate a PDF in Flutter

```dart
import 'package:khmer_pdf_fixer/khmer_pdf_fixer.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'dart:io';

Future<void> generateAndOpenPdf() async {
  await KhmerFontManager().initialize();

  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      build: (context) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          KhmerText(
            'អត្ថបទខ្មែរធម្មតា',
            fontSize: 20,
          ),
          pw.SizedBox(height: 10),
          pw.Text(
            'សួស្ដីពិភពលោក'.fix,
            style: KhmerFontType.siemreap.ts(
              fontSize: 24,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.red,
            ),
          ),
        ],
      ),
    ),
  );

  final dir = await getApplicationDocumentsDirectory();
  final file = File("${dir.path}/example.pdf");
  await file.writeAsBytes(await pdf.save());
  await OpenFile.open(file.path);
}
```

---

## Step 3: Use PDF Fixer Widgets

Khmer PDF Fixer provides **ready-to-use widgets** that automatically handle formatting:

* **KhmerText** – Basic Khmer text
* **KhmerRichText** – Multi-style text spans
* **KhmerHeader** – Bold headers
* **KhmerParagraph** – Properly formatted paragraphs
* **KhmerBulletList** – Bullet lists
* **KhmerTable** – Tables with headers and formatted cells

---

### 1. KhmerText

```dart
KhmerText(
  'អត្ថបទធម្មតា',
  fontType: KhmerFontType.siemreap,
  fontSize: 18,
);
```

### 2. KhmerRichText

```dart
KhmerRichText(
  spans: [
    KhmerTextSpan('អត្ថបទដិត ', fontWeight: pw.FontWeight.bold),
    KhmerTextSpan('និងអត្ថបទធម្មតា', fontType: KhmerFontType.siemreap),
  ],
);
```

### 3. KhmerHeader

```dart
KhmerHeader('ចំណងជើងខ្មែរ');
```

### 4. KhmerParagraph

```dart
KhmerParagraph('កថាខណ្ឌខ្មែរនឹងត្រូវសរសេរនៅទីនេះ។');
```

### 5. KhmerBulletList

```dart
KhmerBulletList(
  items: ['ធាតុទីមួយ', 'ធាតុទីពីរ', 'ធាតុទីបី'],
  bullet: '•',
);
```

### 6. KhmerTable

```dart
KhmerTable(
  data: [
    ['ឈ្មោះ', 'អាយុ', 'ទីក្រុង'],
    ['សុខ', '២៥', 'ភ្នំពេញ'],
    ['សៅ', '៣០', 'សៀមរាប'],
  ],
);
```

---

## Step 4: TextStyle & Widget Shortcuts

```dart
// TextStyle shortcut
pw.Text(
  'ចំណងជើងខ្មែរ'.fix,
  style: KhmerFontType.siemreap.ts(
    fontSize: 24,
    fontWeight: pw.FontWeight.bold,
    color: PdfColors.red,
  ),
);

// Text widget shortcut
KhmerFontType.siemreap.text(
  'អត្ថបទខ្មែរ',
  fontSize: 18,
  color: PdfColors.black,
);
```

---

## License

This project is licensed under the **Apache License 2.0**.
Read the full license [here](https://www.apache.org/licenses/LICENSE-2.0).

---

## Special Thanks 🙏✨

Inspired by the `bangla_pdf_fixer` package. Special thanks to all module creators.
