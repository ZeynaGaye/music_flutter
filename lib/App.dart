import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';
import 'package:musicc/models/Music.dart';
import 'package:musicc/musicProvider/AudioPlayerProvider.dart';
import 'package:musicc/musicProvider/artist_details.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  App({Key? key}) : super(key: key);



  TextEditingController _controller = TextEditingController();

  String recherche = "";

  @override
  Widget build(BuildContext context) {
    final audioProvider = Provider.of<AudioPlayerProvider>(context);
    final audioPlayer = AudioPlayer();

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 224, 249, 255),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/OIP (5).jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: FutureBuilder(
          future: getArtiste(recherche),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: audioProvider.listOfMusic.length,
                itemBuilder: (BuildContext context, int position) {
                  return Column(
                    children: [
                      ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ArtisteDetailsPage(
                                listMusic: audioProvider.listOfMusic[position],
                              ),
                            ),
                          );
                        },
                        leading: CircleAvatar(
                          backgroundColor: Color.fromARGB(255, 255, 200, 184),
                          radius: 40,
                          backgroundImage: NetworkImage(
                              audioProvider.listOfMusic[position][0].artistPicture!),
                        ),
                        title: Text(
                            audioProvider.listOfMusic[position][0].artistName!),
                        subtitle: Text(
                            audioProvider.listOfMusic[position][0].artistName!),
                        trailing: CircleAvatar(
                          radius: 25,
                          child: IconButton(
                            onPressed: () async {
                              await playMusic(
                                audioPlayer,
                                audioProvider.listOfMusic[position][0].previewUrl!,
                              );
                            },
                            icon: const Icon(
                              Icons.queue_music_rounded,
                            ),
                            iconSize: 30,
                          ),
                        ),
                      ),
                      Divider()
                    ],
                  );
                },
              );
            } else {
              return const Center(
                child: Text(
                  "",
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                    fontSize: 23,
                    color: Color.fromARGB(255, 201, 65, 7)
                  ),
                ),
              );
            }
          },
        ),
      ),
      appBar: AppBar(
        title: Text("Music"),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 145, 233, 255),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("search  an Artist by name"),
                content: TextField(
                  controller: _controller,
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () async {
                      var counter = 0;

                      recherche = _controller.text;

                      for (var list in audioProvider.listOfMusic) {
                        for (var item in list) {
                          if (item.artistName == recherche) {
                            counter += 1;
                          } else {}
                        }
                      }

                      if (counter > 1) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("this artist is on the list"),
                            backgroundColor: Colors.deepOrange,
                            dismissDirection: DismissDirection.up,
                          ),
                        );
                      } else {
                        List<Music> listMusic = await getArtiste(recherche);

                        if (listMusic.isNotEmpty) {
                          audioProvider.setMusicList(listMusic);
                        }
                        Navigator.pop(context);
                      }
                    },
                    child: Text("Validate"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Cancel"),
                  )
                ],
              );
            },
          );
        },
        child: Icon(Icons.manage_search_sharp),
      ),
    );
  
  }

  Future<void> playMusic(AudioPlayer player, String previewUrl) async {
    if (player.playing) {
      await player.pause();
    } else {
      await player.setUrl(previewUrl);
      await player.play();
    }
  }
}
Future<List<Music>> getArtiste(String user_Artiste) async {
  // if (user_Artiste == null) {
  //   // Gérer le cas où user_Artiste est null (peut-être renvoyer une liste vide)
  //   return [];
  // }
  List<Music> listMusic = [];

  String url = "http://api.deezer.com/search?q=$user_Artiste";

  var response = await http.get(Uri.parse(url));

  var responseJson = jsonDecode(response.body);
  print(responseJson);
  for (var music in responseJson["data"]) {
    listMusic.add(Music.fromJson(music));
  }

  return listMusic;
}
