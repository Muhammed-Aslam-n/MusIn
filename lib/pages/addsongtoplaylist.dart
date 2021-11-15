import 'package:flutter/material.dart';
import 'package:musin/materials/colors.dart';
import 'package:musin/pages/home.dart';
import 'package:musin/pages/songlist.dart';
import 'package:musin/pages/widgets/widgets.dart';

class AddSongstoPlaylist extends StatefulWidget {
  const AddSongstoPlaylist({Key? key}) : super(key: key);

  @override
  _AddSongstoPlaylistState createState() => _AddSongstoPlaylistState();
}

class _AddSongstoPlaylistState extends State<AddSongstoPlaylist> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppBar(context),
      body: ListView(
        children: [
          CommonHeaders(
            title: "Dancing",
            subtitle: "Add Songs to Playlist",
          ),
          SizedBox(
            height: 30,
          ),
          AddtoPlaylistSongList(
            songName: "I will always with you",
            songDesc: "Whiteney Huston",
            image: "assets/images/sampleImage.jfif",
          ),
          AddtoPlaylistSongList(
            songName: "I will always with you",
            songDesc: "Whiteney Huston",
            image: "assets/images/sampleImage.jfif",
          ),
          AddtoPlaylistSongList(
            songName: "I will always with you",
            songDesc: "Whiteney Huston",
            image: "assets/images/sampleImage.jfif",
          ),
          AddtoPlaylistSongList(
            songName: "I will always with you",
            songDesc: "Whiteney Huston",
            image: "assets/images/sampleImage.jfif",
          ),
          AddtoPlaylistSongList(
            songName: "I will always with you",
            songDesc: "Whiteney Huston",
            image: "assets/images/sampleImage.jfif",
          ),
          AddtoPlaylistSongList(
            songName: "I will always with you",
            songDesc: "Whiteney Huston",
            image: "assets/images/sampleImage.jfif",
          ),
          AddtoPlaylistSongList(
            songName: "I will always with you",
            songDesc: "Whiteney Huston",
            image: "assets/images/sampleImage.jfif",
          ),
          AddtoPlaylistSongList(
            songName: "I will always with you",
            songDesc: "Whiteney Huston",
            image: "assets/images/sampleImage.jfif",
          ),
          AddtoPlaylistSongList(
            songName: "I will always with you",
            songDesc: "Whiteney Huston",
            image: "assets/images/sampleImage.jfif",
          ),
        ],
      ),
    );
  }
}
