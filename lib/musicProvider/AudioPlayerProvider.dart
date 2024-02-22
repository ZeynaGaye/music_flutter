import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musicc/models/Music.dart';

class AudioPlayerProvider extends ChangeNotifier {
  AudioPlayer audioPlayer = AudioPlayer();
  int? currentPlayingIndex;
  String _recherche = "";
  final artistList = [];

  final List<List<Music>> listOfMusic = [];
  bool isPlaying = false;
  int itemCurrentPleyed = -1;

  String get recherche => _recherche;

  void setPlayingState(bool cuurentPlayed, int index) {
    isPlaying = cuurentPlayed;
    itemCurrentPleyed = index;
    notifyListeners();
  }

  set recherche(String value) {
    _recherche = value;
    notifyListeners();
  }

  Future<void> playPause(int index, String previewUrl) async {
    if (currentPlayingIndex != index) {
      if (currentPlayingIndex != null) {
        await audioPlayer.stop();
      }
      await audioPlayer.setUrl(previewUrl);
      await audioPlayer.play();
      currentPlayingIndex = index;
    } else {
      if (audioPlayer.playing) {
        await audioPlayer.pause();
      } else {
        await audioPlayer.play();
      }
    }
    notifyListeners();
  }

  Future<void> playSong(String previewUrl) async {
    await audioPlayer.stop();
    await audioPlayer.setUrl(previewUrl);
    await audioPlayer.play();
    notifyListeners();
  }

  void setMusicList(List<Music> list) {
    listOfMusic.add(list);
    notifyListeners();
  }
}
