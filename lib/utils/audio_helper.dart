import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';

class AudioHelper {
  final AudioPlayer _audioPlayer = AudioPlayer();

  Future<Uint8List> getBytes(String filePath) async {
    ByteData bytes = await rootBundle.load(filePath); //load sound from assets
    return bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);
  }

  Future<void> playLocal(String name) async {
    await _audioPlayer.play(AssetSource(name));
  }
}
