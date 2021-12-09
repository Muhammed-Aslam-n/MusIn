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

List songLeftToAddToPlaylist = [];

class AddToPlaylistHolder extends StatelessWidget {
  const AddToPlaylistHolder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(),
      body: ListView(
        physics: const ScrollPhysics(),
        shrinkWrap: true,
        children: [
          const AddToPlaylistHeader(),
          sizedh1,
          AddSongstoPlaylist(),
        ],
      ),
    );
  }
}

class AddToPlaylistHeader extends StatefulWidget {
  const AddToPlaylistHeader({Key? key}) : super(key: key);

  @override
  _AddToPlaylistHeaderState createState() => _AddToPlaylistHeaderState();
}

class _AddToPlaylistHeaderState extends State<AddToPlaylistHeader> {
  Box<UserPlaylistSongs>? userPlaylistSongsDbInstane;
  Box<UserSongs>? userSongsDbInstance;

  @override
  void initState() {
    userPlaylistSongsDbInstane =
        Hive.box<UserPlaylistSongs>(userPlaylistSongBoxName);
    userSongsDbInstance = Hive.box<UserSongs>(songDetailListBoxName);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PlayerCurrespondingItems>(
      builder: (_, setSongDetails, child) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 40, top: 20, bottom: 5),
            child: commonText(text: setSongDetails.currentPlaylistName),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 5),
            child: commonText(
                text: "Add Songs to Playlist",
                color: HexColor("#ACB8C2"),
                weight: FontWeight.w400,
                size: 15),
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
                  visible: setSongDetails.selectedSongCount == 0 ? false : true,
                  child: setSongDetails.selectedSongCount == 1
                      ? Text(
                          "${setSongDetails.selectedSongCount} Song Selected",
                          style: TextStyle(color: HexColor("#A6B9FF")),
                        )
                      : Text(
                          "${setSongDetails.selectedSongCount} Songs Selected",
                          style: TextStyle(color: HexColor("#A6B9FF")),
                        ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (setSongDetails.selectedSongCount >= 1) {
                    addFn();
                  } else {
                    return;
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
        ],
      ),
    );
  }

  Future addFn() async {
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
            currespondingPlaylistId: pInstance.currentPlaylistKey,
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
                selectedPlaylistKey: pInstance.currentPlaylistKey,
              ),
            ),
          );
    pInstance.selectedSongCount = 0;
  }
}

class AddSongstoPlaylist extends StatefulWidget {
  const AddSongstoPlaylist({Key? key}) : super(key: key);

  @override
  _AddSongstoPlaylistState createState() => _AddSongstoPlaylistState();
}

class _AddSongstoPlaylistState extends State<AddSongstoPlaylist> {
  Box<UserPlaylistSongs>? userPlaylistSongsDbInstane;
  Box<UserSongs>? userSongsDbInstance;
  Box<UserPlaylistNames>? userPlaylistNameDbInstance;
  bool isAdded = false;

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
      int balanceKeys = nKeys.length - pInstance.totalPlaylistSongs!.toInt();
      pInstance.generateSampleList(balanceKeys);
    } else {
      pInstance.generateSampleList(nKeys.length);
    }
    checkBoxList = List<bool>.filled(nKeys.length, false);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PlayerCurrespondingItems>(
      builder: (_, setSongDetails, child) => ListView(
        physics: const ScrollPhysics(),
        shrinkWrap: true,
        children: [
          Consumer<PlayerCurrespondingItems>(
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
                        setSongDetails.currentPlaylistKey) {
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
                                ? setSongDetails.selectedSongCount++
                                : setSongDetails.selectedSongCount--;
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
          ),
        ],
      ),
    );
  }
}
