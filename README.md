# Khmer PDF Fixer

`khmer_pdf_fixer` is a Flutter package for generating PDFs that contain Khmer text.
It bundles the Siemreap font, provides helper widgets for the `pdf` package, and
includes both:

- a Unicode reorderer for simple Khmer text flows in the `pdf` package
- a raster-text fallback for cases where Khmer OpenType shaping is required

## Why this package exists

The Dart `pdf` package does not perform full Khmer shaping. That means complex
Khmer clusters, split vowels, and stacked marks can render incorrectly when
drawn as plain PDF text.

This package gives you two approaches:

- `KhmerText`, `KhmerParagraph`, `KhmerHeader`, `KhmerRichText`, `KhmerBulletList`,
  and `KhmerTable` for lightweight helper usage
- `KhmerTextRaster` for stronger rendering fidelity by shaping Khmer with Flutter
  first, then embedding the result as an image in the PDF

If your document contains important Khmer body copy, headings, or tables,
prefer `KhmerTextRaster`.

## Features

- Bundled `Siemreap-Regular.ttf`
- `KhmerFontManager` for loading the bundled font into `pdf`
- `.fix` string extension for Khmer visual reordering
- Khmer PDF widgets for common document structures
- Raster Khmer renderer for better visual output in generated PDFs

## Installation

```yaml
dependencies:
  khmer_pdf_fixer: ^0.1.1
```

Then run:

```bash
flutter pub get
```

## Basic usage

Initialize the bundled font before building PDF text styles:

```dart
await KhmerFontManager().initialize();
```

### PDF text helper usage

```dart
import 'package:khmer_pdf_fixer/khmer_pdf_fixer.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

final pdf = pw.Document();

await KhmerFontManager().initialize();

pdf.addPage(
  pw.Page(
    build: (context) => pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        KhmerHeader('វិក្កយបត្រ'),
        KhmerParagraph('អត្ថបទខ្មែរ'),
        KhmerText(
          'សូមអរគុណ!',
          fontSize: 18,
          color: PdfColors.green700,
        ),
      ],
    ),
  ),
);
```

### Raster fallback usage

Use this when Khmer shaping quality matters more than selectable PDF text:

```dart
import 'package:khmer_pdf_fixer/khmer_pdf_fixer.dart';
import 'package:pdf/widgets.dart' as pw;

final widget = await KhmerTextRaster.create(
  'សូមស្វាគមន៍មកកាន់ប្រព័ន្ធរបស់យើង។',
  fontSize: 16,
  maxWidth: 400,
);

pdf.addPage(
  pw.Page(
    build: (context) => widget,
  ),
);
```

## API overview

- `KhmerFontManager`
- `KhmerFontType`
- `KhmerText`
- `KhmerHeader`
- `KhmerParagraph`
- `KhmerRichText`
- `KhmerBulletList`
- `KhmerTable`
- `KhmerTextRaster`
- `String.fix`

## Current limitation

The plain PDF text helpers still rely on heuristics because the underlying
`pdf` package does not support full Khmer shaping. For the most reliable Khmer
output, use `KhmerTextRaster`.

## Example app

The example app in [`example/`](./example) generates a sample invoice PDF and
demonstrates the raster fallback path for Khmer rendering.

## License

Apache-2.0
