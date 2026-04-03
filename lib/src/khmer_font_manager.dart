import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart' as pw;

class KhmerFontManager {
  static final KhmerFontManager _instance = KhmerFontManager._internal();
  factory KhmerFontManager() => _instance;
  KhmerFontManager._internal();

  bool _isInitialized = false;
  pw.Font? _siemreapFont;

  pw.Font get siemreap {
    if (!_isInitialized || _siemreapFont == null) {
      throw Exception(
        'KhmerFontManager not initialized. Call initialize() first.',
      );
    }
    return _siemreapFont!;
  }

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      final siemreapData = await _loadFontAsset();
      _siemreapFont = pw.Font.ttf(siemreapData);
      _isInitialized = true;
    } catch (e) {
      throw Exception('Failed to load Khmer fonts: $e');
    }
  }

  Future<ByteData> _loadFontAsset() async {
    const candidatePaths = [
      'packages/khmer_pdf_fixer/fonts/GoogleSans-Regular.ttf',
      'packages/khmer_pdf_fixer/fonts/Siemreap-Regular.ttf',
    ];

    for (final path in candidatePaths) {
      try {
        return await rootBundle.load(path);
      } catch (_) {
        // Try the next candidate. The package path is correct for consumers,
        // while the local path is useful when testing this package directly.
      }
    }

    throw Exception('Unable to load Siemreap font from bundled assets.');
  }
}
