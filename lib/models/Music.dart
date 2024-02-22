class Music {
  String? title;
  String? preview;
  String? artistName;
  String? artistPicture;
  bool? isPlaying; // Nouvelle propriété pour suivre l'état de lecture

  Music.fromJson(Map<String, dynamic> jsonData) {
    title = jsonData["title"];
    preview = jsonData["preview"];
    artistName = jsonData["artist"]["name"];
    artistPicture = jsonData["artist"]["picture_medium"];
    isPlaying = false; // Par défaut, la lecture n'est pas en cours
  }

  get previewUrl => null;

 
}
