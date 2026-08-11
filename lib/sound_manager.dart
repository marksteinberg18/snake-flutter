import 'package:audioplayers/audioplayers.dart';

class SoundManager {
  final _audioPlayer = AudioPlayer();

  Future<void> init() async {
    await _audioPlayer.setReleaseMode(ReleaseMode.release);
    await _audioPlayer.setSource(AssetSource('sounds/success.wav'));
  }

  Future<void> playSoundSuccess() async {
    print('beep!');
    final player = AudioPlayer();
    await player.setAudioContext(
      AudioContext(
        android: AudioContextAndroid(audioFocus: AndroidAudioFocus.none),
      ),
    );
    await player.setReleaseMode(ReleaseMode.stop);
    await player.play(
      AssetSource('sounds/success.wav'),
      mode: PlayerMode.lowLatency,
    );
    await player.onPlayerComplete.first;
    await player.dispose();
  }

  Future<void> playSoundPoison() async {
    print('beep!');
    final player = AudioPlayer();
    await player.setAudioContext(
      AudioContext(
        android: AudioContextAndroid(audioFocus: AndroidAudioFocus.none),
      ),
    );
    await player.setReleaseMode(ReleaseMode.stop);
    await player.play(
      AssetSource('sounds/poison.wav'),
      mode: PlayerMode.lowLatency,
    );
    await player.onPlayerComplete.first;
    await player.dispose();
  }
}
