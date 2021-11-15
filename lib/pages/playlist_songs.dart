import 'package:flutter/material.dart';
import 'package:musin/materials/colors.dart';
import 'package:musin/pages/home.dart';
import 'package:musin/pages/songlist.dart';
import 'package:musin/pages/songplayingpage.dart';
import '/pages/widgets/widgets.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:fluttericon/font_awesome_icons.dart';

class PlaylistSongs extends StatefulWidget {
  const PlaylistSongs({Key? key}) : super(key: key);

  @override
  _PlaylistSongsState createState() => _PlaylistSongsState();
}

bool isSelected = true;

class _PlaylistSongsState extends State<PlaylistSongs> {
  @override
  Widget build(BuildContext context) {
    DateTime pre_backpress = DateTime.now();
    return Scaffold(
      appBar: commonAppBar(context),
      body: Stack(
        children: [
          ListView(
            shrinkWrap: true,
            children: [
              SizedBox(
                width: 180,
                child: Row(
                  children: [
                    sizedw2,
                    IconButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/');
                        },
                        icon: Icon(Icons.chevron_left_outlined,size: 27,)),
                    commonText(text: "Classic")
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  isSelected = false;
                  setState(() {
                    isSelected = false;
                    print(isSelected);
                  });
                },
                child: SongTileView(
                  image: "assets/images/sampleImage.jfif",
                  songName: "Bohemian Rapsody",
                  songDesc: "Queen",
                ),
              ),
              GestureDetector(
                onTap: () {
                  isSelected = false;
                  setState(() {
                    isSelected = false;
                    print(isSelected);
                  });
                },
                child: SongTileView(
                  image: "assets/images/sampleImage.jfif",
                  songName: "Bohemian Rapsody",
                  songDesc: "Queen",
                ),
              ),
            ],
          ),
          CommonMiniPlayer(
            // isSelected: isSelected,
          ),
        ],
      ),
    );
  }
}
