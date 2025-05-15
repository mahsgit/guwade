import 'package:flutter_tts/flutter_tts.dart';

class TextToSpeechUtil {
  static final FlutterTts _flutterTts = FlutterTts();
  static bool _isInitialized = false;
  
  static Future<void> init() async {
    if (!_isInitialized) {
      await _flutterTts.setLanguage('en-US');
      await _flutterTts.setSpeechRate(0.5); // Slower for kids
      await _flutterTts.setVolume(1.0);
      await _flutterTts.setPitch(1.0);
      _isInitialized = true;
    }
  }
  
  static Future<void> speak(String text) async {
    await init();
    await _flutterTts.speak(text);
  }
  
  static Future<void> stop() async {
    await _flutterTts.stop();
  }
  
  static Future<void> pause() async {
    await _flutterTts.pause();
  }
  
  static Future<void> resume() async {
    await _flutterTts.speak('');
  }
  
  // Set a child-friendly voice if available
  static Future<void> setChildFriendlyVoice() async {
    await init();
    final voices = await _flutterTts.getVoices;
    
    // This is platform-specific and would need to be adjusted
    // based on available voices on the device
    for (var voice in voices) {
      if (voice.toString().toLowerCase().contains('child')) {
        if (voice is Map<String, String>) {
          await _flutterTts.setVoice(voice);
        }
        break;
      }
    }
  }
}
