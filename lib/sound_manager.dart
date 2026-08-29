import 'package:audioplayers/audioplayers.dart';

class SoundManager {
  // Claude's suggestion: one dedicated player per sound - created once and used multiple times
  final AudioPlayer _successPlayer = AudioPlayer();
  final AudioPlayer _poisonPlayer = AudioPlayer();

  //Called ONE when game starts...

  Future<void> init() async {
    //Configure both players up front
    for (final player in [_successPlayer, _poisonPlayer]) {
      await player.setReleaseMode(ReleaseMode.stop);
      await player.setAudioContext(
        AudioContext(
          android: AudioContextAndroid(audioFocus: AndroidAudioFocus.none),
        ),
      );
    }
    //pre-load the sound files so first play isn't delayed...
    await _successPlayer.setSource(AssetSource('sounds/success.wav'));
    await _poisonPlayer.setSource(AssetSource('sounds/poison.wav'));
  }

  //Play sounds when required - no need to wait for completion
  Future<void> playSuccess() async {
    await _successPlayer.stop(); //rewind to beginning
    await _successPlayer.play(
      AssetSource('sounds/success.wav'),
      mode: PlayerMode.lowLatency,
    );
  }

  Future<void> playPoison() async {
    await _poisonPlayer.stop();
    await _poisonPlayer.play(
      AssetSource('sounds/poison.wav'),
      mode: PlayerMode.lowLatency,
    );
  }

  //Success, then poison after short gap
  Future<void> playSuccessThenPoison() async {
    await playSuccess();
    await Future.delayed(const Duration(milliseconds: 400));
    await playPoison();
  }

  //Call when game is disposed to clear up...
  Future<void> disposeSounds() async {
    await _successPlayer.dispose();
    await _poisonPlayer.dispose();
  }
}
