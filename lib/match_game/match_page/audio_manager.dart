import 'package:audioplayers/audioplayers.dart';

class AudioManager {
  static final AudioPlayer _player = AudioPlayer();

  static Future<void> playAudio(String type) async {
    try {
      await _player.play(AssetSource('sounds/$type.mp3'));
    } catch (e) {
      print('Error playing audio: $e');
    }
  }
}