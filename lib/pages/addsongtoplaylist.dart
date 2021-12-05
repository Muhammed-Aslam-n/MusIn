// import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:musin/database/database.dart';
// import 'package:musin/main.dart';
// import 'package:musin/materials/colors.dart';
// import 'package:musin/pages/widgets/widgets.dart';
// import 'package:musin/provider/provider_class.dart';
// import 'package:on_audio_query/on_audio_query.dart';
// import 'package:provider/provider.dart';
//
// class AddSongstoPlaylist extends StatefulWidget {
//   String? currentPlaylistName;
//   int? currentPlaylistKey;
//
//   AddSongstoPlaylist({this.currentPlaylistKey, this.currentPlaylistName});
//
//   @override
//   _AddSongstoPlaylistState createState() => _AddSongstoPlaylistState();
// }
//
// class _AddSongstoPlaylistState extends State<AddSongstoPlaylist> {
//   Box<UserPlaylistSongs>? userPlaylistSongsDbInstane;
//   Box<UserSongs>? userSongsDbInstance;
//   Box<UserPlaylistNames>? userPlaylistNameDbInstance;
//   bool isAdded = false;
//   @override
//   void initState() {
//     userPlaylistNameDbInstance = Hive.box<UserPlaylistNames>(userPlaylistBoxName);
//     userPlaylistSongsDbInstane =
//         Hive.box<UserPlaylistSongs>(userPlaylistSongBoxName);
//     userSongsDbInstance = Hive.box<UserSongs>(songDetailListBoxName);
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: commonAppBar(context),
//       body: ListView(
//         children: [
//           CommonHeaders(
//             title: widget.currentPlaylistName,
//             subtitle: "Add Songs to Playlist",
//           ),
//           const SizedBox(
//             height: 30,
//           ),
//           addToPlaylistSongList(context),
//         ],
//       ),
//     );
//   }
//
//   addToPlaylistSongList(BuildContext context) {
//     return Consumer<PlayerCurrespondingItems>(
//         builder: (_, setSongDetails, child) => ValueListenableBuilder(
//         valueListenable: userSongsDbInstance!.listenable(),
//         builder: (context, Box<UserSongs> songFetcher, _) {
//         List<int> keys = songFetcher.keys.cast<int>().toList();
//         if (songFetcher.isEmpty) {
//         return Column(
//           children: const [
//             Text("No Songs So Far..."),
//           ],
//         );
//         }else{
//         return ListView.builder(
//           itemCount: keys.length,
//           shrinkWrap: true,
//           physics: const ScrollPhysics(),
//           itemBuilder: (context,index){
//             final key = keys[index];
//             final songDatas = songFetcher.get(key);
//             return ListTile(
//               leading: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 20),
//                 child: QueryArtworkWidget(
//                     id: songDatas!.imageId!,
//                     type: ArtworkType.AUDIO,
//                     nullArtworkWidget: ClipRRect(
//                         child: Image.asset(
//                           "assets/images/defaultImage.png",
//                           height: 50,
//                           width: 50,
//                           fit: BoxFit.fill,
//                         ),
//                         borderRadius: BorderRadius.circular(10)),
//                     artworkHeight: 50,
//                     artworkWidth: 50,
//                     artworkFit: BoxFit.fill,
//                     artworkBorder: BorderRadius.circular(10)),
//               ),
//               title: Padding(
//                 padding: const EdgeInsets.only(top: 10),
//                 child: commonText(
//                     text: songDatas.songName,
//                     size: 15,
//                     weight: FontWeight.w600),
//               ),
//               subtitle: Padding(
//                 padding: const EdgeInsets.only(bottom: 10),
//                 child: commonMarquees(
//                     text: songDatas.artistName,
//                     size: 12.0,
//                     color: HexColor("#ACB8C2"),
//                     weight: FontWeight.w600,
//                     hPadding: 0.0,
//                     vPadding: 1.0),
//               ),
//               trailing: IconButton(
//                 icon: Icon(
//                   Icons.add,
//                   color: isAdded ? Colors.red : Colors.grey.shade500,
//                 ),
//                 onPressed: () {
//                   final model = UserPlaylistSongs(currespondingPlaylistId: widget.currentPlaylistKey,songName: songDatas.songName,artistName: songDatas.artistName,songPath: songDatas.songPath,songDuration: songDatas.duration,songImageId: songDatas.imageId);
//                   userPlaylistSongsDbInstane!.add(model);
//                   debugPrint("Add Button Clicked");
//                 },
//               ),
//             );
//         },);}
//       },
//       ),
//     );
//   }
//
//   // showPlaylistSnackBar(BuildContext context) {
//   //   final snack = SnackBar(
//   //     content: isAdded!
//   //         ? commonText(
//   //         text: "Added to Playlist",
//   //         color: Colors.green,
//   //         size: 13,
//   //         weight: FontWeight.w500,
//   //         isCenter: true)
//   //         : commonText(
//   //         text: "Removed from Playlist",
//   //         color: Colors.red,
//   //         size: 13,
//   //         weight: FontWeight.w500,
//   //         isCenter: true),
//   //     duration: Duration(seconds: 1),
//   //     behavior: SnackBarBehavior.floating,
//   //     shape: RoundedRectangleBorder(
//   //       borderRadius: BorderRadius.circular(24),
//   //     ),
//   //     backgroundColor: Colors.white,
//   //     width: 250,
//   //   );
//   //   return ScaffoldMessenger.of(context).showSnackBar(snack);
//   // }
// }

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:musin/database/database.dart';
import 'package:musin/main.dart';
import 'package:musin/materials/colors.dart';
import 'package:musin/pages/playlist_songs.dart';
import 'package:musin/pages/widgets/widgets.dart';
import 'package:musin/provider/provider_class.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class AddSongstoPlaylist extends StatefulWidget {
  String? currentPlaylistName;
  int? currentPlaylistKey;
  int? totalPlaylistSongs;

  AddSongstoPlaylist(
      {Key? key,
      this.currentPlaylistKey,
      this.currentPlaylistName,
      this.totalPlaylistSongs})
      : super(key: key);

  @override
  _AddSongstoPlaylistState createState() => _AddSongstoPlaylistState();
}

class _AddSongstoPlaylistState extends State<AddSongstoPlaylist> {
  Box<UserPlaylistSongs>? userPlaylistSongsDbInstane;
  Box<UserSongs>? userSongsDbInstance;
  Box<UserPlaylistNames>? userPlaylistNameDbInstance;
  bool isAdded = false;
  int selectedSongCount = 0;

  @override
  void initState() {
    userPlaylistNameDbInstance =
        Hive.box<UserPlaylistNames>(userPlaylistBoxName);
    userPlaylistSongsDbInstane =
        Hive.box<UserPlaylistSongs>(userPlaylistSongBoxName);
    userSongsDbInstance = Hive.box<UserSongs>(songDetailListBoxName);
    createCheckBoxList();
    super.initState();
  }

  List<bool> checkBoxList = [];

  createCheckBoxList() {
    var nKeys = userSongsDbInstance!.keys.cast<int>().toList();
    var pInstance =
        Provider.of<PlayerCurrespondingItems>(context, listen: false);
    if (pInstance.isAddingSongsToExistingPlaylist == true) {
      int balanceKeys = nKeys.length - widget.totalPlaylistSongs!.toInt();
      pInstance.generateSampleList(balanceKeys);
    } else {
      pInstance.generateSampleList(nKeys.length);
    }
    checkBoxList = List<bool>.filled(nKeys.length, false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(),
      body: Consumer<PlayerCurrespondingItems>(
        builder: (_, setSongDetails, child) => ListView(
          shrinkWrap: true,
          children: [
            CommonHeaders(
              title: widget.currentPlaylistName,
              subtitle: "Add Songs to Playlist",
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(flex: 2, child: SizedBox()),
                Expanded(
                  flex: 2,
                  child: Visibility(
                    maintainState: true,
                    maintainAnimation: true,
                    visible: selectedSongCount == 0 ? false : true,
                    child: selectedSongCount == 1
                        ? Text(
                            "${selectedSongCount} Song Selected",
                            style: TextStyle(color: HexColor("#A6B9FF")),
                          )
                        : Text(
                            "${selectedSongCount} Songs Selected",
                            style: TextStyle(color: HexColor("#A6B9FF")),
                          ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if(selectedSongCount>=1) {
                      addToPlaylistFn();
                    } else {
                      return ;
                    }
                    setSongDetails.isAddingSongsToExistingPlaylist = false;
                  },
                  child: const Text(
                    "Add",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: HexColor("#A6B9FF"),
                    fixedSize: const Size(30, 10),
                  ),
                ),
                sizedw2,
              ],
            ),
            addToPlaylistSongList(context),
          ],
        ),
      ),
    );
  }

  List songLeftToAddToPlaylist = [];

  addToPlaylistFn() {
    var pInstance =
        Provider.of<PlayerCurrespondingItems>(context, listen: false);

    for (var i = 0; i < pInstance.checkBoxList.length; i++) {
      debugPrint(pInstance.checkBoxList[i].toString());
      if (pInstance.checkBoxList[i] == true) {
        final songData = userSongsDbInstance!.get(songLeftToAddToPlaylist[i]);
        final model = UserPlaylistSongs(
            songName: songData?.songName,
            artistName: songData?.artistName,
            songDuration: songData?.duration,
            songImageId: songData?.imageId,
            currespondingPlaylistId: widget.currentPlaylistKey,
            songPath: songData?.songPath);
        userPlaylistSongsDbInstane?.add(model);
      }
    }
    pInstance.isAddingSongsToExistingPlaylist
        ? Navigator.of(context).pop()
        : Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => PlaylistSongs(
                      selectedPlaylistKey: widget.currentPlaylistKey,
                    )));
  }

  addToPlaylistSongList(BuildContext context) {
    return Consumer<PlayerCurrespondingItems>(
      builder: (_, setSongDetails, child) => ValueListenableBuilder(
        valueListenable: userSongsDbInstance!.listenable(),
        builder: (context, Box<UserSongs> songFetcher, _) {
          List<int> keys = [];
          List<int> songDbList = [];
          keys = songFetcher.keys.cast<int>().toList();

          if (setSongDetails.isAddingSongsToExistingPlaylist == true) {
            var pSongList = [];
            for (var element in userPlaylistSongsDbInstane!.values) {
              if (element.currespondingPlaylistId ==
                  widget.currentPlaylistKey) {
                pSongList.add(element.songName);
              }
            }
            var uList = userSongsDbInstance!.values.toList();
            for (var i = 0; i < userSongsDbInstance!.length; i++) {
              for (var j = 0; j < pSongList.length; j++) {
                if (uList[i].songName == pSongList[j]) {
                  songDbList.add(i);
                }
              }
            }
            for (var i = 0; i < keys.length; i++) {
              for (var j = 0; j < songDbList.length; j++) {
                if (keys[i] == songDbList[j]) {
                  keys.remove(keys[i]);
                }
              }
            }
          }
          songLeftToAddToPlaylist = keys;

          // final pSongKey = userPlaylistSongsDbInstane!.keys.cast<int>().where((element) => userPlaylistSongsDbInstane!.get(element)!.currespondingPlaylistId == widget.currentPlaylistKey).toList();

          if (songFetcher.isEmpty) {
            return Column(
              children: const [
                Text("No Songs So Far..."),
              ],
            );
          } else {
            return ListView.builder(
              itemCount: keys.length,
              shrinkWrap: true,
              physics: const ScrollPhysics(),
              itemBuilder: (context, index) {
                final key = keys[index];
                final songDatas = songFetcher.get(key);

                return ListTile(
                  onTap: () {
                    setSongDetails.checkBoxList[index] =
                        !setSongDetails.checkBoxList[index];
                    setSongDetails.checkBoxList[index]
                        ? selectedSongCount++
                        : selectedSongCount--;
                    setState(() {});
                  },
                  leading: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: QueryArtworkWidget(
                        id: songDatas!.imageId!,
                        type: ArtworkType.AUDIO,
                        nullArtworkWidget: ClipRRect(
                            child: Image.asset(
                              "assets/images/defaultImage.png",
                              height: 50,
                              width: 50,
                              fit: BoxFit.fill,
                            ),
                            borderRadius: BorderRadius.circular(10)),
                        artworkHeight: 50,
                        artworkWidth: 50,
                        artworkFit: BoxFit.fill,
                        artworkBorder: BorderRadius.circular(10)),
                  ),
                  title: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: commonText(
                        text: songDatas.songName,
                        size: 15,
                        weight: FontWeight.w600),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: commonMarquees(
                        text: songDatas.artistName,
                        size: 12.0,
                        color: HexColor("#ACB8C2"),
                        weight: FontWeight.w600,
                        hPadding: 0.0,
                        vPadding: 1.0),
                  ),
                  trailing: Checkbox(
                    value: setSongDetails.checkBoxList[index],
                    onChanged: (value) {
                      setSongDetails.checkBoxList[index] = value!;
                      setSongDetails.checkBoxList[index]
                          ? selectedSongCount++
                          : selectedSongCount--;
                      setState(() {});
                    },
                    shape: const CircleBorder(),
                    activeColor: HexColor("#A6B9FF"),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
