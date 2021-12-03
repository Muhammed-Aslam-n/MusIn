import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:musin/database/database.dart';
import 'package:musin/main.dart';
import 'package:musin/materials/colors.dart';
import 'package:musin/pages/favourites.dart';
import 'package:musin/pages/playlist_songs.dart';
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
  Box<UserPlaylistSongs>? userPlaylistSongs;

  final newPlaylistName = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String errorMessage = "Name Required";
  List userPlaylistNames = [];
  @override
  initState() {
    userPlaylistNameDbInstance =
        Hive.box<UserPlaylistNames>(userPlaylistBoxName);
    userPlaylistSongs = Hive.box<UserPlaylistSongs>(userPlaylistSongBoxName);
    getAllPlaylist();
    super.initState();
  }

  getAllPlaylist() {
    for (var element in userPlaylistNameDbInstance!.values) {
      userPlaylistNames.add(element.playlistNames);
    }
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: commonAppBar(context),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            var pInstance = Provider.of<PlayerCurrespondingItems>(context,listen:false);
            pInstance.isAddingSongsToExistingPlaylist = false;
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
                    height: 160,
                    width: MediaQuery.of(context).size.width * 0.92,
                    decoration:  BoxDecoration(
                      image: const DecorationImage(
                        image: AssetImage("assets/images/playlist_Bg/playlist9.jpg"),
                        fit: BoxFit.fill,
                      ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 2, // changes position of shadow
                          ),
                        ]
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          bottom: 10,
                          left: 10,
                          child: commonText(
                            text: "Favourites",
                            color: Colors.white,
                            isCenter: true),),
                      ],
                    )

                  ),
                ),
                sizedh2,
                commonText(
                  text: "your playlists",
                ),
                sizedh1,
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
        builder: (context, Box<UserPlaylistNames> playlistNameFetcher, _) {
          List<int> allKeys = playlistNameFetcher.keys.cast<int>().toList();
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
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PlaylistSongs(
                                selectedPlaylistKey: key,
                              )));
                  debugPrint("Navigator to Playlist Clicked");
                },
                child: Column(
                  children: [
                    SizedBox(
                      width: 200,
                      height: 120,
                      child: Container(
                        decoration:  BoxDecoration(
                          image: const DecorationImage(
                            image: AssetImage("assets/images/playlist_Bg/playlist7.jpg"),fit: BoxFit.cover
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 2, // changes position of shadow
                            ),
                          ]

                        ),
                        child: Stack(
                          children: [
                            Positioned(child: commonText(
                                text: "\n\t\t${songDatas!.playlistNames}",
                                color: Colors.white),
                            right: 10,
                              bottom: 10,
                            ),
                          ],
                        )
                      ),
                    ),
                  ],
                ),

                onLongPress: (){
                  deleteOnLongPress(key,context);
                },
              );
            },
          );
        });
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
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 14),
                    child: Form(
                      key: formKey,
                      child: TextFormField(
                        controller: newPlaylistName,
                        decoration: const InputDecoration.collapsed(
                            hintText: "Playlist Name"),
                        keyboardType: TextInputType.name,
                        validator: (playlistName) {
                          if (playlistName!.isEmpty) {
                            return errorMessage;
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
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
                        createNewPlaylist();
                        debugPrint("Playlist Created");
                        newPlaylistName.clear();
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

  deleteOnLongPress(currespondingKey,BuildContext context){
    List playlistSongsOfSelectedPlaylist = [];
    for (var element in userPlaylistSongs!.values) {
      if(element.currespondingPlaylistId == currespondingKey){
        playlistSongsOfSelectedPlaylist.add(element.currespondingPlaylistId);
      }
    }
    userPlaylistSongs!.deleteAll(playlistSongsOfSelectedPlaylist);
    userPlaylistNameDbInstance!.delete(currespondingKey);
    showFavouriteSnackBar(context: context,text: "Deleted",duration: 1);
  }




  bool didFound = false;
  createNewPlaylist() {
    if (formKey.currentState!.validate()) {
     for (var element in userPlaylistNames) {
       if(element == newPlaylistName.text){
         didFound = true;
       }
     }
     if(didFound == false){
       var newlyCreatedPlalistName = newPlaylistName.text;
       final model = UserPlaylistNames(playlistNames: newlyCreatedPlalistName);
       userPlaylistNameDbInstance!.add(model);
       Navigator.pop(context);
       Navigator.push(
         context,
         MaterialPageRoute(
           builder: (context) => AddSongstoPlaylist(
             currentPlaylistKey: userPlaylistNameDbInstance!.keys.last,
             currentPlaylistName: newlyCreatedPlalistName,
           ),
         ),
       );
     }else{
       debugPrint("POPPED");
       Navigator.of(context).pop();
       showFavouriteSnackBar(context: context,text:"Playlist Already exists, try with another name ");
     }
    }
  }

  showFavouriteSnackBar({required BuildContext context, text,duration}) {
    final snack = SnackBar(
      content:commonText(
          text: text,
          color: Colors.red,
          size: 13,
          weight: FontWeight.w500,
          isCenter: true),
      duration:  Duration(seconds: duration??3),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      backgroundColor: Colors.white,
      width: 100,
    );
    return ScaffoldMessenger.of(context).showSnackBar(snack);
  }
  @override
  void dispose() {
    newPlaylistName.dispose();
    super.dispose();
  }
}
