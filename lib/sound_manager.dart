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
    await player.onPlayerComplete.first;
    await player.dispose();

    //player.onPlayerComplete.first.then((_) => player.dispose());
  }
}
