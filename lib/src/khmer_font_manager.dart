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
    return await rootBundle.load(
      'packages/khmer_pdf_fixer/fonts/GoogleSans-Regular.ttf',
    );
  }
}
