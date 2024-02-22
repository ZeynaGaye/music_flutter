import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musicc/models/Music.dart';
import 'package:provider/provider.dart';
import 'package:musicc/musicProvider/AudioPlayerProvider.dart';
import 'package:musicc/utils/Utils.dart';

class SingleMusicPage extends StatelessWidget {
  final bool isPlaying;
  final Music singleMusic;

  SingleMusicPage({
    Key? key,
    required this.singleMusic,
    required this.isPlaying,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final audioProvider = Provider.of<AudioPlayerProvider>(context, listen: false);
    int currentPlayedItem = 1;

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 224, 249, 255),
      appBar: AppBar(
        title: Text("Music"),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 145, 233, 255),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 140,
              backgroundImage: NetworkImage(singleMusic.artistPicture!),
            ),
            SizedBox(height: 32),
            Text(
              singleMusic.title!,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text(
              singleMusic.artistName!,
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 4),
            Slider(
              min: 0,
              max: audioProvider.audioPlayer.duration!.inSeconds.toDouble(),
              value: audioProvider.audioPlayer.position.inSeconds.toDouble(),
              onChanged: (value) {
                final position = Duration(seconds: value.toInt());
                audioProvider.audioPlayer.seek(position);
              },
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(Utils.formatTime(audioProvider.audioPlayer.position)),
                  Text(
                    Utils.formatTime(
                      audioProvider.audioPlayer.duration! - audioProvider.audioPlayer.position,
                    ),
                  ),
                ],
              ),
            ),
            CircleAvatar(
              radius: 35,
              child: IconButton(
                onPressed: () async {
                  if (currentPlayedItem == 1 && isPlaying) {
                    await audioProvider.audioPlayer.pause();
                    audioProvider.setPlayingState(false, -1);
                  } else {
                    String url = singleMusic.preview!;
                    await audioProvider.audioPlayer.setUrl(url);
                    await audioProvider.audioPlayer.play();
                    audioProvider.setPlayingState(true, 1);
                  }
                },
                icon: Icon(
                  currentPlayedItem == 1 && isPlaying
                      ? Icons.pause
                      : Icons.play_arrow,
                ),
                iconSize: 50,
              ),
            )
          ],
        ),
      ),
    );
  }
}
