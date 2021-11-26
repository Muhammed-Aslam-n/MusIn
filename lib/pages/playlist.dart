import 'package:flutter/material.dart';
import 'package:fluttericon/zocial_icons.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:musin/database/database.dart';
import 'package:musin/main.dart';
import 'package:musin/materials/colors.dart';
import 'package:musin/pages/favourites.dart';
import 'package:musin/pages/home.dart';
import 'package:musin/pages/playlist_songs.dart';
import 'package:musin/pages/songlist.dart';
import 'package:musin/pages/widgets/widgets.dart';
import 'package:musin/provider/provider_class.dart';
import 'package:provider/provider.dart';

import 'addsongtoplaylist.dart';

class PlayList extends StatefulWidget {
  const PlayList({Key? key}) : super(key: key);

  @override
  _PlayListState createState() => _PlayListState();
}

var height, width;

class _PlayListState extends State<PlayList> {
  Box<UserPlaylistNames>? userPlaylistNameDbInstance;
  @override
  initState(){
    userPlaylistNameDbInstance = Hive.box<UserPlaylistNames>(userPlaylistBoxName);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: (){
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
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
            const SizedBox(
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
                playListHeads(context),
              ],
            ),
          ],
        ),
      ),
    );
  }

  playListHeads(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: userPlaylistNameDbInstance!.listenable(),
      builder: (context,Box<UserPlaylistNames> playlistNameFetcher,_){
        List<int> allKeys =
        playlistNameFetcher.keys.cast<int>().toList();
        return GridView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          physics: const ScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.95 / 0.7,
              mainAxisSpacing: 32,
              crossAxisSpacing: 18),
          shrinkWrap: true,
          itemCount: allKeys.length,
          itemBuilder: (context, index) {
            final key = allKeys[index];
            final songDatas = playlistNameFetcher.get(key);
            return GestureDetector(
              onTap: () {
                debugPrint("Index Curresponding to Playlist is $index");
                debugPrint("Key Curresponding to Playlist is $key");
                final pInstance = Provider.of<PlayerCurrespondingItems>(context,listen:false);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => PlaylistSongs(selectedPlaylistKey: key,)));
                debugPrint("Navigator to Playlist Clicked");
              },
              child: Container(
                child: Card(
                  child:
                  commonText(text: "\n\t\t${songDatas!.playlistNames}", color: HexColor("#A6B9FF")),
                ),
              ),
            );
          },
        );
      }
    );
  }

  showAlertDialogue(BuildContext context) {
    TextEditingController newPlaylistName = TextEditingController();
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
                    controller: newPlaylistName,
                    decoration:
                    const InputDecoration.collapsed(hintText: "Playlist Name"),
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
                        final model = UserPlaylistNames(playlistNames: newPlaylistName.text);
                        userPlaylistNameDbInstance!.add(model);
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddSongstoPlaylist(currentPlaylistKey: userPlaylistNameDbInstance!.keys.last,currentPlaylistName: newPlaylistName.text,)));

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

}
