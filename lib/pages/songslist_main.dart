import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:marquee/marquee.dart';
import 'package:musin/database/database.dart';
import 'package:musin/materials/colors.dart';
import 'package:musin/pages/playlist.dart';
import 'package:musin/pages/widgets/widgets.dart';
import 'package:musin/provider/provider_class.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:file/file.dart';
import 'package:provider/provider.dart';
import 'package:assets_audio_player/assets_audio_player.dart' as aap;

import '../main.dart';

class SongsListMain extends StatefulWidget {
  const SongsListMain({Key? key}) : super(key: key);

  @override
  _SongsListMainState createState() => _SongsListMainState();
}

var isSelected = true;

class _SongsListMainState extends State<SongsListMain> {
  final OnAudioQuery audioQuery = OnAudioQuery();
  Box<SongDetailsList>? songDbInstance;

  @override
  void initState() {
    songDbInstance = Hive.box<SongDetailsList>(songDetailListBoxName);
    final pInstance = Provider.of<PlayerCurrespondingItems>(context,listen: false);
    pInstance.getKeys();
    pInstance.showKeys();
    super.initState();
  }

  // // Constructor
  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: commonAppBar(context),
  //     body: Stack(
  //       children: [
  //         SingleChildScrollView(
  //           padding: EdgeInsets.all(10),
  //           child: Column(
  //             children: [
  //               Padding(
  //                 padding: EdgeInsets.only(left: 13, top: 20),
  //                 child: Align(
  //                   alignment: Alignment.topLeft,
  //                   child: commonText(text: "Your Songs"),
  //                 ),
  //               ),
  //               sizedh1,
  //               ImageContainer(),
  //             ],
  //           ),
  //         ),
  //         CommonMiniPlayer(
  //             // isSelected: isSelected,
  //             // songName: "Don't Let Me Go",
  //             // artistName: "ABBA",
  //             // image: "assets/images/defaultImage.png",
  //             // type: ArtworkType.AUDIO,
  //             // path:
  //             //     "assets/music/Best of Bollywood Shreya Ghoshal CD 1 TRACK 2 (320).mp3",
  //             // duration: 3.12
  //         ),
  //       ],
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppBar(context),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 13, top: 20),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: commonText(text: "Your Songs"),
                  ),
                ),
                sizedh1,
                ImageContainer(context),
              ],
            ),
          ),
          CommonMiniPlayer(              // isSelected: isSelected,
              // songName: "Don't Let Me Go",
              // artistName: "ABBA",
              // image: "assets/images/defaultImage.png",
              // type: ArtworkType.AUDIO,
              // path:
              // "assets/music/Best of Bollywood Shreya Ghoshal CD 1 TRACK 2 (320).mp3",
              // duration: 3.12
         ),
        ],
      ),
    );
  }

  // PLAYS WITH DATABASE and Provider also

  ImageContainer(BuildContext context) {
    return Consumer<PlayerCurrespondingItems>(
      builder: (_, setSongDetails, child) => ValueListenableBuilder(
        valueListenable: songDbInstance!.listenable(),
        builder: (context, Box<SongDetailsList> songFetcher, _) {
          List<int> keys = songFetcher.keys.cast<int>().toList();
          if (songFetcher.isEmpty) {
            return Column(
              children: const [
                Text("No Songs So Far..."),
              ],
            );
          } else {
            return GridView.builder(
              physics: const ScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.4 / 1.7,
                  mainAxisSpacing: 18,
                  crossAxisSpacing: 12),
              shrinkWrap: true,
              itemCount: keys.length,
              itemBuilder: (context, index) {
                final key = keys[index];
                final songDatas = songFetcher.get(key);
                return GestureDetector(
                  onTap: () {
                    setSongDetails.isSelectedOrNot = false;
                    debugPrint(songDatas!.path);
                    setSongDetails.selectedSongKey = key;
                    setSongDetails.currentSongDuration = songDatas.duration;
                    setSongDetails.songPath = songDatas.path;
                    setSongDetails.opnPlaylist(setSongDetails.playList,setSongDetails.selectedSongKey);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: HexColor("#A6B9FF"),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        QueryArtworkWidget(
                          id: songDatas!.songId,
                          type: ArtworkType.AUDIO,
                          nullArtworkWidget:
                              ClipRRect(child: Image.asset("assets/images/defaultImage.png",height: MediaQuery.of(context).size.height * 0.16,width: double.infinity,fit: BoxFit.fill,),borderRadius: const BorderRadius.only( topLeft: Radius.circular(24),topRight: Radius.circular(24)),),
                          artworkHeight:
                              MediaQuery.of(context).size.height * 0.16,
                          artworkFit: BoxFit.fill,
                          artworkBorder: const BorderRadius.only(
                              topRight: Radius.circular(24),
                              topLeft: Radius.circular(24)),
                          artworkWidth: 200,
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(CupertinoIcons.heart),
                              ),
                              PopupMenuButton(
                                  itemBuilder: (context) => [
                                        const PopupMenuItem(
                                          child: Text("Add to Playlist"),
                                          value: 1,
                                        ),
                                        const PopupMenuItem(
                                          child: Text("Create Playlist"),
                                          value: 2,
                                        )
                                      ])
                            ],
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child:Marquee(
                              text: songDatas.artistName ?? "No Artist",
                              blankSpace: 100,
                              velocity: 30,
                              pauseAfterRound: const Duration(seconds: 3),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 20, bottom: 10),
                            child:
                                commonText(text: songDatas.songName, size: 17),
                          ),
                        ),
                        const SizedBox(
                          height: 7,
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

//
//
// Pure Code
// ImageContainer() {
//   return Consumer<PlayerCurrespondingItems>(
//       builder: (_, setSongDetails, child) => FutureBuilder<List<SongModel>>(
//             // Default values:
//             future: _audioQuery.querySongs(
//               sortType: null,
//               orderType: OrderType.ASC_OR_SMALLER,
//               uriType: UriType.EXTERNAL,
//               ignoreCase: true,
//             ),
//             builder: (context, item) {
//               for (var i = 0; i < item.data!.length; i++) {
//                 setSongDetails.
//               }
//               // Loading content
//               if (item.data == null) return const CircularProgressIndicator();
//
//               // When you try "query" without asking for [READ] or [Library] permission
//               // the plugin will return a [Empty] list.
//               if (item.data!.isEmpty) return const Text("Nothing found!");
//
//               // You can use [item.data!] direct or you can create a:
//               // List<SongModel> songs = item.data!;
//               return GridView.builder(
//                 physics: ScrollPhysics(),
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 2,
//                     childAspectRatio: 0.95 / 1.7,
//                     mainAxisSpacing: 18,
//                     crossAxisSpacing: 8),
//                 shrinkWrap: true,
//                 itemCount: item.data!.length,
//                 itemBuilder: (context, index) {
//                   return GestureDetector(
//                     onTap: () {
//                       setSongDetails.isSelectedOrNot = false;
//                       setSongDetails.getSongDetails(
//                           nameOfSong: item.data![index].title,
//                           nameOfArtist: item.data![index].artist,
//                           artistImage: item.data![index].id,
//                           artistType: ArtworkType.AUDIO,
//                           songPath: item.data![index].data);
//                     },
//                     child: Container(
//                       decoration: BoxDecoration(
//                         color: HexColor("#A6B9FF"),
//                         borderRadius: BorderRadius.circular(24),
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           QueryArtworkWidget(
//                             id: item.data![index].id,
//                             type: ArtworkType.AUDIO,
//                             nullArtworkWidget:
//                                 Image.asset("assets/images/defaultImage.png"),
//                             artworkHeight:
//                                 MediaQuery.of(context).size.height * 0.22,
//                             artworkBorder: const BorderRadius.only(
//                                 topRight: Radius.circular(24),
//                                 topLeft: Radius.circular(24)),
//                             artworkWidth: 200,
//                           ),
//                           const SizedBox(
//                             height: 7,
//                           ),
//                           Expanded(
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.end,
//                               children: [
//                                 IconButton(
//                                   onPressed: () {},
//                                   icon: Icon(CupertinoIcons.heart),
//                                 ),
//                                 PopupMenuButton(
//                                     itemBuilder: (context) => [
//                                           const PopupMenuItem(
//                                             child: Text("Add to Playlist"),
//                                             value: 1,
//                                           ),
//                                           const PopupMenuItem(
//                                             child: Text("Create Playlist"),
//                                             value: 2,
//                                           )
//                                         ])
//                               ],
//                             ),
//                           ),
//                           SizedBox(
//                             height: 7,
//                           ),
//                           Expanded(
//                             child: Padding(
//                               padding: const EdgeInsets.only(left: 20),
//                               child: commonText(
//                                   text:
//                                       item.data![index].artist ?? "No Artist",
//                                   color: Colors.grey.shade500,
//                                   size: 12),
//                             ),
//                           ),
//                           SizedBox(
//                             height: 7,
//                           ),
//                           Expanded(
//                             child: Padding(
//                               padding:
//                                   const EdgeInsets.only(left: 20, bottom: 10),
//                               child: commonText(
//                                   text: item.data![index].title, size: 17),
//                             ),
//                           ),
//                           SizedBox(
//                             height: 7,
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               );
//             },
//           ));
// }

// Playing Using Asset
//   ImageContainer() {
//     return GridView.builder(
//       physics: ScrollPhysics(),
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 2,
//           childAspectRatio: 0.95 / 1.7,
//           mainAxisSpacing: 18,
//           crossAxisSpacing: 8),
//       shrinkWrap: true,
//       itemCount: 20,
//       itemBuilder: (context, index) {
//         return GestureDetector(
//           onTap: () {
//             isSelected = false;
//             setState(() {});
//           },
//           child: Container(
//             decoration: BoxDecoration(
//               color: HexColor("#A6B9FF"),
//               borderRadius: BorderRadius.circular(24),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Container(
//                   height: 80,
//                   width: 80,
//                   decoration: const BoxDecoration(
//                       image: DecorationImage(
//                     image: ExactAssetImage("assets/images/defaultImage.png"),
//                     fit: BoxFit.cover,
//                   )),
//                 ),
//                 const SizedBox(
//                   height: 7,
//                 ),
//                 Expanded(
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: [
//                       IconButton(
//                         onPressed: () {},
//                         icon: Icon(CupertinoIcons.heart),
//                       ),
//                       PopupMenuButton(
//                           itemBuilder: (context) => [
//                                 const PopupMenuItem(
//                                   child: Text("Add to Playlist"),
//                                   value: 1,
//                                 ),
//                                 const PopupMenuItem(
//                                   child: Text("Create Playlist"),
//                                   value: 2,
//                                 )
//                               ])
//                     ],
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 7,
//                 ),
//                 Expanded(
//                   child: Padding(
//                     padding: const EdgeInsets.only(left: 20),
//                     child: commonText(
//                         text: "ABBA", color: Colors.grey.shade500, size: 12),
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 7,
//                 ),
//                 Expanded(
//                   child: Padding(
//                     padding: const EdgeInsets.only(left: 20, bottom: 10),
//                     child: commonText(text: "Don't Let Me Go", size: 17),
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 7,
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

// Playing Using Asset

// ImageContainer Working By passing The Data to Provider by user click

//   ImageContainer() {
//     return GridView.builder(
//       physics: ScrollPhysics(),
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 2,
//           childAspectRatio: 0.95 / 1.7,
//           mainAxisSpacing: 18,
//           crossAxisSpacing: 8),
//       shrinkWrap: true,
//       itemCount: 20,
//       itemBuilder: (context, index) {
//         return Consumer<PlayerCurrespondingItems>(
//           builder: (_, setSongDetails, child) =>GestureDetector(
//             onTap: () {
//               isSelected = false;
//               setSongDetails.isSelectedOrNot = false;
//               setSongDetails.getSongDetails(
//                 totalDuration: 3.12,
//                 artistType: ArtistModel,
//                 artistImage: "assets/images/defaultImage.png",
//                 nameOfArtist: "ABBA",
//                 nameOfSong: "Don't Let Me Go",
//                 songPath: "assets/music/Best of Bollywood Shreya Ghoshal CD 1 TRACK 2 (320).mp3"
//               );
//               setState(() {
//               }
//               );debugPrint("Tapped");
//             },
//             child: Container(
//               decoration: BoxDecoration(
//                 color: HexColor("#A6B9FF"),
//                 borderRadius: BorderRadius.circular(24),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Container(
//                     height: 80,
//                     width: 80,
//                     decoration: const BoxDecoration(
//                         image: DecorationImage(
//                       image: ExactAssetImage("assets/images/defaultImage.png"),
//                       fit: BoxFit.cover,
//                     )),
//                   ),
//                   const SizedBox(
//                     height: 7,
//                   ),
//                   Expanded(
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
//                         IconButton(
//                           onPressed: () {},
//                           icon: Icon(CupertinoIcons.heart),
//                         ),
//                         PopupMenuButton(
//                             itemBuilder: (context) => [
//                                   const PopupMenuItem(
//                                     child: Text("Add to Playlist"),
//                                     value: 1,
//                                   ),
//                                   const PopupMenuItem(
//                                     child: Text("Create Playlist"),
//                                     value: 2,
//                                   )
//                                 ])
//                       ],
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 7,
//                   ),
//                   Expanded(
//                     child: Padding(
//                       padding: const EdgeInsets.only(left: 20),
//                       child: commonText(
//                           text: "ABBA", color: Colors.grey.shade500, size: 12),
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 7,
//                   ),
//                   Expanded(
//                     child: Padding(
//                       padding: const EdgeInsets.only(left: 20, bottom: 10),
//                       child: commonText(text: "Don't Let Me Go", size: 17),
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 7,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
}
