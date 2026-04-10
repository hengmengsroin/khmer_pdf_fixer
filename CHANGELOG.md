## 0.1.2

* Updated example PDF generation to use simple Khmer text widgets instead of raster text rendering.
* Updated README guidance to recommend simple text rendering by default and use raster rendering only as a fallback.

## 0.1.1

* Improved Khmer text-fixing performance for PDF text helpers.
* Added publish metadata fields (`repository`, `homepage`, and `issue_tracker`) in `pubspec.yaml`.

## 0.1.0

* Added Khmer PDF helpers with bundled Siemreap font support.
* Added Khmer text widgets for text, headers, paragraphs, rich text, bullet lists, and tables.
* Added a Khmer Unicode fixer for non-shaping PDF text flows.
* Added a raster Khmer rendering helper for cases where native PDF shaping is insufficient.
* Improved test coverage for Khmer cluster reordering and split-vowel handling.
