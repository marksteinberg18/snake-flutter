import 'package:audioplayers/audioplayers.dart';

class SoundManager {
  final _audioPlayer = AudioPlayer();

  Future<void> init() async {
    await _audioPlayer.setReleaseMode(ReleaseMode.release);
    await _audioPlayer.setSource(AssetSource('sounds/success.wav'));
  }

  Future<void> playSound() async {
    print('beep!');
    final player = AudioPlayer();
    await player.setReleaseMode(ReleaseMode.stop);
    await player.play(
      AssetSource('sounds/success.wav'),
      mode: PlayerMode.lowLatency,
    );
    player.onPlayerComplete.first.then((_) => player.dispose());
  }

  void dispose() {
    //_audioPlayer.dispose();
  }
}
