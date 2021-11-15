import 'package:flutter/material.dart';
import 'package:fluttericon/zocial_icons.dart';
import 'package:musin/materials/colors.dart';
import 'package:musin/pages/favourites.dart';
import 'package:musin/pages/home.dart';
import 'package:musin/pages/playlist_songs.dart';
import 'package:musin/pages/songlist.dart';
import 'package:musin/pages/widgets/widgets.dart';

import 'addsongtoplaylist.dart';

class PlayList extends StatefulWidget {
  const PlayList({Key? key}) : super(key: key);

  @override
  _PlayListState createState() => _PlayListState();
}

var height, width;

class _PlayListState extends State<PlayList> {
  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: commonAppBar(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            showAlertDialogue(context);
          });
          debugPrint("Create Playlist Clicked");
        },
        child: const Icon(
          Icons.add,
          size: 35,
        ),
        backgroundColor: HexColor("#A6B9FF"),
        tooltip: "New Playlist",
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          CommonHeaders(
            title: "Playlist",
            subtitle: "Pick your Playlist",
          ),
          SizedBox(
            height: 30,
          ),
          Column(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Favourites()));
                  debugPrint("Navigator to Playlist Clicked");
                },
                child: Container(
                  height: 80,
                  width: MediaQuery.of(context).size.width *0.82,
                  child: Card(
                    child:
                    Center(
                      child: commonText(text: "Favourites", color: HexColor("#A6B9FF"),isCenter: true),
                    ),
                  ),
                ),
              ),sizedh2,
              commonText(text: "your playlists",),sizedh1,
              playListHeads("Qawali"),
            ],
          ),
        ],
      ),
    );
  }

  playListHeads(
    name,
  ) {
    return GridView.builder(
      padding: EdgeInsets.symmetric(horizontal: 15),
      physics: ScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.95 / 0.7,
          mainAxisSpacing: 32,
          crossAxisSpacing: 18),
      shrinkWrap: true,
      itemCount: 30,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => PlaylistSongs()));
            debugPrint("Navigator to Playlist Clicked");
          },
          child: Container(
            child: Card(
              child:
                  commonText(text: "\n\t\t$name", color: HexColor("#A6B9FF")),
            ),
          ),
        );
      },
    );
  }
}

showAlertDialogue(BuildContext context) {
  return showDialog<void>(
    context: context,
    barrierDismissible: true, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text(
          "New Playlist",
          style: TextStyle(
            fontSize: 14,
          ),
        ),
        content: SizedBox(
          height: 110,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Divider(
                height: 0.5,
                color: HexColor("#A6B9FF"),
                thickness: 0.5,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 14),
                child: TextFormField(
                  decoration:
                      InputDecoration.collapsed(hintText: "Playlist Name"),
                ),
              ),
              sizedh1,
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  MaterialButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: commonText(text: "Cancel", size: 13),
                  ),
                  MaterialButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddSongstoPlaylist()));

                      debugPrint("Playlist Created");
                    },
                    child: commonText(
                        text: "Create", size: 13, color: HexColor("#A6B9FF")),
                  )
                ],
              )
            ],
          ),
        ),
      );
    },
  );
}
