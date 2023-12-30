import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';

class AudioHelper {
  final ap = AudioPlayer();

  static const AudioContext _audioContext = AudioContext(
    android: AudioContextAndroid(audioFocus: AndroidAudioFocus.gainTransientMayDuck)
  );

  Future<Uint8List> getBytes(String filePath) async {
    ByteData bytes = await rootBundle.load(filePath); //load sound from assets
    return bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);
  }

  Future<void> playLocal(String name) async {
    await ap.stop();
    await ap.play(AssetSource(name), ctx: _audioContext);
  }

  Future<void> dispose() async {
    await ap.dispose();
  }
}
