import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musicc/models/Music.dart';
import 'package:musicc/musicProvider/AudioPlayerProvider.dart';
import 'package:musicc/pages/SingleMusicPage.dart';
import 'package:provider/provider.dart';

class ArtisteDetailsPage extends StatelessWidget {
  final List<Music> listMusic;

  ArtisteDetailsPage({Key? key, required this.listMusic}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final audioProvider = Provider.of<AudioPlayerProvider>(context);
    bool isPlaying = audioProvider.isPlaying;
    int currentPlayedItem = audioProvider.itemCurrentPleyed;

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 224, 249, 255),
      appBar: AppBar(
        title: Text("Music"),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 145, 233, 255),
      ),
      body: ListView.builder(
        itemCount: listMusic.length,
        itemBuilder: (BuildContext context, int position) {
          return ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SingleMusicPage(
                    singleMusic: listMusic[position],
                    isPlaying: isPlaying,
                  ),
                ),
              );
            },
            leading: CircleAvatar(
              backgroundColor: Color.fromARGB(255, 255, 200, 184),
              radius: 40,
              backgroundImage:
                  NetworkImage(listMusic[position].artistPicture!),
            ),
            title: Text(listMusic[position].title!),
            subtitle: Text(listMusic[position].artistName!),
            trailing: CircleAvatar(
              radius: 25,
              child: IconButton(
                onPressed: () async {
                  if (currentPlayedItem == position) {
                    await audioProvider.audioPlayer.pause();
                    audioProvider.setPlayingState(false, -1);
                  } else {
                    await audioProvider.playPause(
                        position, listMusic[position].preview!);
                  }
                },
                icon: Icon(
                  currentPlayedItem == position && isPlaying
                      ? Icons.pause
                      : Icons.play_arrow,
                ),
                iconSize: 30,
              ),
            ),
          );
        },
      ),
    );
  }
}
