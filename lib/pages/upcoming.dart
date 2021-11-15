import 'package:flutter/material.dart';
import 'package:musin/materials/colors.dart';
import 'package:musin/pages/songlist.dart';
import 'package:musin/pages/widgets/widgets.dart';

class UpcomingSongs extends StatefulWidget {
  const UpcomingSongs({Key? key}) : super(key: key);

  @override
  _UpcomingSongsState createState() => _UpcomingSongsState();
}

class _UpcomingSongsState extends State<UpcomingSongs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppBar(context),
      body: ListView(
        children: [
          CommonHeaders(
            title: "Upcoming Songs",
            subtitle: "",
          ),
          const SizedBox(
            height: 30,
          ),
          SongTileView(
            padding: 50,
            image: "assets/images/sampleImage.jfif",
            songName: "We will Rock you",
            songDesc: "ABBCD",
          ),
          SongTileView(
            padding: 50,
            image: "assets/images/sampleImage.jfif",
            songName: "We will Rock you",
            songDesc: "ABBCD",
          ),
          SongTileView(
            padding: 50,
            image: "assets/images/sampleImage.jfif",
            songName: "We will Rock you",
            songDesc: "ABBCD",
          ),
          SongTileView(
            padding: 50,
            image: "assets/images/sampleImage.jfif",
            songName: "We will Rock you",
            songDesc: "ABBCD",
          ),
          SongTileView(
            padding: 50,
            image: "assets/images/sampleImage.jfif",
            songName: "We will Rock you",
            songDesc: "ABBCD",
          ),
          SongTileView(
            padding: 50,
            image: "assets/images/sampleImage.jfif",
            songName: "We will Rock you",
            songDesc: "ABBCD",
          ),
          SongTileView(
            padding: 50,
            image: "assets/images/sampleImage.jfif",
            songName: "We will Rock you",
            songDesc: "ABBCD",
          ),
          SongTileView(
            padding: 50,
            image: "assets/images/sampleImage.jfif",
            songName: "We will Rock you",
            songDesc: "ABBCD",
          ),
          SongTileView(
            padding: 50,
            image: "assets/images/sampleImage.jfif",
            songName: "We will Rock you",
            songDesc: "ABBCD",
          ),
        ],
      ),
    );
  }
}
