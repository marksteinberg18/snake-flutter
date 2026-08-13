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
    //await player.dispose();
  }

  Future<void> playSoundPoison() async {
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

  Future<void> playSuccessThenPoisonSound() async {
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
    await Future.delayed(const Duration(seconds: 1));
    await player
        .play(AssetSource('sounds/poison.wav'), mode: PlayerMode.lowLatency)
        .catchError((error) {
          print('Poison sound error: $error');
        });
    await player.onPlayerComplete.first;
    await player.dispose();
  }

  // await playSoundSuccess();
  // await Future.delayed(const Duration(seconds: 1));
  // await playSoundPoison();
}
