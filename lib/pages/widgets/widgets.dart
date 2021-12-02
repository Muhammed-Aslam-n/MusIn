import 'package:assets_audio_player/assets_audio_player.dart' as aap;
import 'package:fluttericon/typicons_icons.dart';
import 'package:marquee/marquee.dart';
import 'package:musin/SettingsPages/feedback.dart';
import 'package:musin/SettingsPages/privacypolicy.dart';
import 'package:musin/SettingsPages/termsandcondiotion.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/entypo_icons.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:musin/database/database.dart';
import 'package:musin/main.dart';
import 'package:musin/materials/colors.dart';
import 'package:musin/pages/home.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:musin/pages/songslist_main.dart';
import 'package:musin/provider/provider_class.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import 'package:provider/src/provider.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import '../settings.dart';
import '../songplayingpage.dart';
import 'package:path_provider/path_provider.dart';

commonAppBar(BuildContext context) {
  bool _switchValue = true;
  return PreferredSize(
    preferredSize: Size.fromHeight(80),
    child: Padding(
      padding: EdgeInsets.only(top: 18),
      child: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leadingWidth: 55,
        leading: Container(
          margin: const EdgeInsets.only(left: 15),
          child: Image.asset("assets/images/MusInNoBackground.png"),
        ),
        title: commonText(text: "MusIn", color: HexColor("#A6adFF")),
        centerTitle: true,
        actions: [
          PopupMenuButton(
            tooltip: "Settings",
            color: Colors.white.withOpacity(0.8),
            icon: const Icon(
              CupertinoIcons.settings,
              color: Colors.black87,
            ),
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Notification"),
                    Transform.scale(
                      scale: 0.8,
                      child: CupertinoSwitch(
                          value: _switchValue,
                          onChanged: (value) {
                            _switchValue = value;
                          }),
                    )
                  ],
                ),
                value: 1,
              ),
              PopupMenuItem(
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const UserFeedback()));
                  },
                  child: Row(
                    children: const [
                      Icon(
                        Icons.feedback,
                        color: Colors.black45,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text("Feedback"),
                    ],
                  ),
                ),
                value: 1,
              ),
              PopupMenuItem(
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const PrivacyPolicy()));
                  },
                  child: Row(
                    children: const [
                      Icon(
                        Icons.lock,
                        color: Colors.black45,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text("Privacy Policy"),
                    ],
                  ),
                ),
                value: 1,
              ),
              PopupMenuItem(
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const TermsandCondition()));
                  },
                  child: Row(
                    children: const [
                      Icon(
                        Typicons.clipboard,
                        color: Colors.black45,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text("Terms and Conditions"),
                    ],
                  ),
                ),
                value: 1,
              ),
              PopupMenuItem(
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                    showAbout(context);
                  },
                  child: Row(
                    children: const [
                      Icon(
                        Entypo.info,
                        color: Colors.black45,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text("About"),
                    ],

                  ),
                ),
                value: 1,
              ),
            ],
          ),
          sizedw2,
        ],
      ),
    ),
  );
}

showAbout(BuildContext context) {
  return showAboutDialog(
      context: (context),
      applicationIcon: Image.asset(
        "assets/images/MusInNoBackground.png",
        height: 45,
        width: 55,
        fit: BoxFit.cover,
      ),
      applicationName: "MusIn",
      applicationVersion: "1.0.00.1",
      children: [
        commonText(
            text:
                "This Application is Developed by CrossRoads Ddevelopment Company\n"
                "All Rights Reserved to CrossRoads Pvt.Limited",
            size: 12,
            weight: FontWeight.w400)
      ]);
}

commonText(
    {text,
    color = Colors.black,
    double size = 18,
    family = "Poppins-Regular",
    weight = FontWeight.w700,
    isCenter = false}) {
  return Text(
    text.toString(),
    textAlign: isCenter ? TextAlign.center : TextAlign.left,
    style: style(weight: weight, size: size, family: family, color: color),
  );
}

style({color, size, family, weight}) {
  return TextStyle(
    color: color,
    fontSize: size,
    fontFamily: family,
    fontWeight: weight,
  );
}

class CommonHeaders extends StatelessWidget {
  var title, subtitle;

  CommonHeaders({this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.13,
      decoration: BoxDecoration(
          color: HexColor("#fff"),
          borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(24),
              bottomRight: Radius.circular(24))),
      child: Padding(
        padding: const EdgeInsets.only(left: 32, top: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            commonText(
              text: this.title,
            ),
            const SizedBox(
              height: 5,
            ),
            commonText(
              text: this.subtitle,
              size: 14,
              color: HexColor("#656F77"),
            ),
          ],
        ),
      ),
    );
  }
}

// Cunstructor Based Play and Pause

// class CommonMiniPlayer extends StatefulWidget {
//   bool isSelected;
//   final songName, artistName, image, path, type, duration;
//
//   CommonMiniPlayer({this.isSelected = true,
//     this.songName,
//     this.artistName,
//     this.image,
//     this.path,
//     this.duration,
//     this.type});
//   @override
//   State<CommonMiniPlayer> createState() => _CommonMiniPlayerState();
// }
//
// class _CommonMiniPlayerState extends State<CommonMiniPlayer> {
//   bool playOrPaused=false,isIconChanged = false;
//   bool isRepeat=false;
//
//   late AssetsAudioPlayer player;
//   @override
//   void initState() {
//     player = AssetsAudioPlayer();
//     super.initState();
//   }
//
// //-----------------------------------------------
//
//
//   playOrpause() async {
//     if (playOrPaused==false) {
//        await playSong(widget.path);
//        playOrPaused = true;
//        isIconChanged = true;
//       setState(() {});
//     } else if(playOrPaused == true){
//       await pauseSong();
//       playOrPaused = false;
//       isIconChanged = false;
//       setState(() {});
//     }
//   }
//   playSong(link)async{
//     try {
//       await player.open(
//         Audio(link),autoStart: true,
//         showNotification: true,
//       );
//       getDuration();
//       totalDuration();
//       finishedOrNot();
//     } catch (t) {
//       //mp3 unreachable
//     }
//   }
//   pauseSong() async {
//     await player.pause();
//   }
//   //------------------------------------------------------------
//   Duration? currentPosition = Duration(seconds: 0);
//   Duration? dur=Duration(seconds: 0);
//
//   totalDuration()async{
//    player.current.listen((event) {
//      dur = event!.audio.duration;
//      setState(() {
//
//      });
//    });
//   }
//
//   getDuration(){
//     return StreamBuilder(
//         stream: player.currentPosition,
//         builder: (context, asyncSnapshot) {
//           currentPosition = asyncSnapshot.data as Duration;
//           return commonText(
//               text: currentPosition.toString().split(".")[0],
//               color: HexColor("#656F77"),
//               weight: FontWeight.w400,
//               size: 12);
//         });
//   }
//   Widget slider() {
//     return Slider(
//       activeColor: HexColor("#656F77"),
//       inactiveColor: Colors.grey,
//       value:currentPosition!.inSeconds.toDouble(),
//       min: 0.0,
//       max: dur!.inSeconds.toDouble(),
//       onChanged: (double value) {
//         setState(() {
//           changeToSeconds(value.toInt());
//           value = value;
//         });
//       },
//     );
//   }
//   void changeToSeconds(int seconds){
//     Duration newDuration = Duration(seconds: seconds);
//     player.seek(newDuration);
//     setState(() {
//     });
//   }
//
//   finishedOrNot(){
//     player.playlistAudioFinished.listen((event) {
//       playOrPaused = false;
//       isIconChanged = false;
//       setState(() {
//       });
//     });
//     }
//
//
//
//   loopSongs(){
//     if(isRepeat == false){
//       player.setLoopMode(LoopMode.single);
//       isRepeat = true;
//
//       isIconChanged = true;
//       setState(() {
//
//       });
//       debugPrint("False : Loop Mode in If ${player.currentLoopMode}");
//     }
//     else if(isRepeat == true){
//       player.setLoopMode(LoopMode.none);
//       isRepeat = false;
//       setState(() {
//
//       });
//       debugPrint(" True: Loop Mode in Else ${player.currentLoopMode}");
//     }
//   }
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Offstage(
//       offstage: widget.isSelected,
//       child: Miniplayer(
//         maxHeight: MediaQuery.of(context).size.height,
//         minHeight: 80,
//         builder: (height, percentage) {
//           if (height <= 80) {
//             return Row(
//               children: [
//                 Expanded(
//                   flex: 2,
//                   child: ListTile(
//                     tileColor: Colors.white38,
//                     isThreeLine: true,
//                     leading: Container(
//                       width: 50,
//                       height: 50,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(8),
//                         image: DecorationImage(
//                           image: ExactAssetImage(
//                             widget.image ?? '',
//                           ),
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                     ),
//                     title: commonText(text: widget.songName ?? "", size: 13),
//                     subtitle:
//                         commonText(text: widget.artistName ?? "", size: 11),
//                   ),
//                 ),
//                 Expanded(
//                   flex: 1,
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Expanded(
//                         child: IconButton(
//                           onPressed: () {
//                             debugPrint("Previous Icon Pressed");
//                           },
//                           icon: const Icon(FontAwesome.left_dir),
//                         ),
//                       ),
//                       IconButton(
//                         onPressed: () {
//                           playOrpause();
//                         },
//                         icon: isIconChanged
//                             ? const Icon(
//                                 Icons.pause,
//                                 size: 32,
//                               )
//                             : const Icon(
//                                 Icons.play_arrow,
//                                 size: 32,
//                               ),
//                       ),
//                       IconButton(
//                         onPressed: () {
//                           debugPrint("Next Icon Pressed");
//                         },
//                         icon: const Icon(FontAwesome.right_dir),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             );
//           } else {
//             // return SongPlayingPage();
//             bool? isFavourite = false,
//                 isLoop = false,
//                 isShuffle = false,
//                 isAdded = false;
//             return Container(
//               margin: const EdgeInsets.only(top: 20),
//               width: double.infinity,
//               height: MediaQuery.of(context).size.height,
//               decoration: const BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(24),
//                       topRight: Radius.circular(24))),
//               child: ListView(
//                 children: [
//                   sizedh2,
//                   Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 30),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           commonText(text: "Now Playing", size: 17),
//                           Row(
//                             children: [
//                               IconButton(
//                                 onPressed: () {
//                                   isFavourite = !isFavourite!;
//                                   showFavouriteSnackBar(context, isFavourite);
//                                   setState(() {});
//                                 },
//                                 icon: const Icon(CupertinoIcons.heart),
//                                 color:
//                                     isFavourite! ? Colors.red : Colors.black87,
//                               ),
//                               IconButton(
//                                   onPressed: () {
//                                     isAdded = !isAdded!;
//                                     showPlaylistSnackBar(context, isAdded);
//                                     setState(() {});
//                                   },
//                                   icon: isAdded!
//                                       ? const Icon(
//                                           CupertinoIcons.add,
//                                         )
//                                       : const Icon(
//                                           CupertinoIcons.checkmark_circle,
//                                           color: Colors.green,
//                                         )),
//                             ],
//                           )
//                         ],
//                       )),
//                   SizedBox(
//                     height: MediaQuery.of(context).size.height * 0.05,
//                   ),
//                   Column(
//                     children: [
//                       Container(
//                         height: 200,
//                         width: 200,
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           border: Border.all(
//                             width: 5,
//                             color: commonColor,
//                           ),
//                         ),
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: CircleAvatar(
//                             backgroundImage: AssetImage(widget.image),
//                           ),
//                         ),
//                       ),
//                       sizedh2,
//                       commonText(
//                         text: widget.songName,
//                         size: 21,
//                       ),
//                       commonText(
//                           text: widget.artistName,
//                           size: 15,
//                           color: HexColor("656F77"),
//                           weight: FontWeight.w400),
//                       sizedh2,
//                       sizedh2,
//                       SizedBox(
//                         width: MediaQuery.of(context).size.width * 0.8,
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             IconButton(
//                               onPressed: () {
//                                 loopSongs();
//                                 debugPrint("Loop Clicked");
//                                 setState(() {
//
//                                 });
//                               },
//                               icon: Icon(Icons.loop_outlined,
//                                   size: 26,
//                                   color: isRepeat
//                                       ? Colors.blueAccent
//                                       : HexColor("#656F77")),
//                             ),
//                             sizedw1,
//                             const Icon(
//                               FontAwesome.left_dir,
//                               size: 37,
//                             ),
//                             sizedw2,
//                             Container(
//                               width: 80,
//                               height: 80,
//                               decoration: BoxDecoration(
//                                   shape: BoxShape.circle, color: commonColor),
//                               child: IconButton(
//                                 onPressed: () {
//                                   playOrpause();
//                                   setState(() {});
//                                   // setSongDetails.isIconChanged?setSongDetails.playSong(audio,context):songDetailsProvider.pauseSong();
//                                 },
//                                 icon: isIconChanged
//                                     ? const Icon(
//                                         Icons.pause,
//                                         size: 60,
//                                         color: Colors.white,
//                                       )
//                                     : const Icon(
//                                         Icons.play_arrow,
//                                         size: 60,
//                                         color: Colors.white,
//                                       ),
//                               ),
//                             ),
//                             sizedw2,
//                             IconButton(
//                               onPressed: () {
//                                 // setSongDetails.isIconChanged?setSongDetails.playSong(setSongDetails.path, context):setSongDetails.pauseSong();
//                                 // setSongDetails.duration();
//                               },
//                               icon: const Icon(
//                                 FontAwesome.right_dir,
//                                 size: 37,
//                               ),
//                             ),
//                             sizedw2,
//                             IconButton(
//                               onPressed: () {
//                                 isShuffle = !isShuffle!;
//                                 setState(() {});
//                               },
//                               icon: Icon(
//                                 Entypo.shuffle,
//                                 size: 22,
//                                 color: isShuffle!
//                                     ? Colors.blueAccent
//                                     : HexColor("#656F77"),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       sizedh2,
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 20),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Expanded(child: getDuration(),),
//                             Expanded(flex:3,child: slider(),),
//                             Expanded(
//                               child: commonText(
//                                   text: dur.toString().split(".")[0],
//                                   color: HexColor("#656F77"),
//                                   weight: FontWeight.w400,
//                                   size: 12),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             );
//           }
//         },
//       ),
//     );
//   }
//
//
//
//   showPlaylistSnackBar(BuildContext context, isAdded) {
//     final snack = SnackBar(
//       content: isAdded!
//           ? commonText(
//               text: "Added to Playlist",
//               color: Colors.green,
//               size: 13,
//               weight: FontWeight.w500,
//               isCenter: true)
//           : commonText(
//               text: "Removed from Playlist",
//               color: Colors.red,
//               size: 13,
//               weight: FontWeight.w500,
//               isCenter: true),
//       duration: Duration(seconds: 1),
//       behavior: SnackBarBehavior.floating,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(24),
//       ),
//       backgroundColor: Colors.white,
//       width: 250,
//     );
//     return ScaffoldMessenger.of(context).showSnackBar(snack);
//   }
//
//   showFavouriteSnackBar(BuildContext context, isFavourite) {
//     final snack = SnackBar(
//       content: isFavourite!
//           ? commonText(
//               text: "Added to Favourites",
//               color: Colors.green,
//               size: 13,
//               weight: FontWeight.w500,
//               isCenter: true)
//           : commonText(
//               text: "Removed from Favourites",
//               color: Colors.red,
//               size: 13,
//               weight: FontWeight.w500,
//               isCenter: true),
//       duration: Duration(seconds: 1),
//       behavior: SnackBarBehavior.floating,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(24),
//       ),
//       backgroundColor: Colors.white,
//       width: 250,
//     );
//     return ScaffoldMessenger.of(context).showSnackBar(snack);
//   }
// }

//
// class DrawerAll extends StatefulWidget {
//   const DrawerAll({Key? key}) : super(key: key);
//
//   @override
//   _DrawerAllState createState() => _DrawerAllState();
// }
//
// class _DrawerAllState extends State<DrawerAll> {
//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       child: ListView(
//         children: [
//           Container(
//             width: double.infinity,
//             padding: EdgeInsets.only(top: 50, left: 30),
//             height: 150,
//             decoration: BoxDecoration(
//               color: HexColor("#A6B9FF"),
//               borderRadius: BorderRadius.only(
//                   bottomLeft: Radius.circular(30),
//                   bottomRight: Radius.circular(30)),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     Image.asset(
//                       "assets/images/MusInNoBackground.png",
//                       height: 34,
//                       width: 45,
//                     ),
//                     commonText(
//                         text: "MusIn", color: HexColor("#1814E4"), size: 27),
//                   ],
//                 ),
//                 commonText(
//                     text: "\tHear The Best",
//                     size: 12,
//                     color: HexColor("#656F77"))
//               ],
//             ),
//           ),
//           const SizedBox(
//             height: 40,
//           ),
//           sizedh2,
//           Container(
//             margin: EdgeInsets.symmetric(horizontal: 35),
//             child: Column(
//               children: [
//                 drawerItems(itemName: "Favourites", routName: "/favourites"),
//                 sizedh2,
//                 drawerItems(itemName: "Playlist", routName: "/playlist"),
//                 // sizedh2,
//                 // drawerItems(itemName: "Search",routName: "/searchSong"),
//                 sizedh2,
//                 drawerItems(itemName: "Settings", routName: "/settings"),
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
//
//   drawerItems({required itemName, size, required routName}) {
//     return GestureDetector(
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           commonText(text: itemName, size: size ?? 17),
//           Icon(
//             Icons.arrow_forward_ios_rounded,
//             size: 15,
//           ),
//         ],
//       ),
//       onTap: () {
//         Navigator.of(context).pop();
//         Navigator.pushNamed(context, routName);
//       },
//     );
//   }
// }

// Provider Integrated Working Player database

class CommonMiniPlayer extends StatefulWidget {
  const CommonMiniPlayer({
    Key? key,
  }) : super(key: key);

  // var songName,artistName,image,path,type;

  @override
  State<CommonMiniPlayer> createState() => _CommonMiniPlayerState();
}

class _CommonMiniPlayerState extends State<CommonMiniPlayer> {
  Box<UserSongs>? songDetailsBox;
  Box<UserPlaylistNames>? userPlaylistNameInstance;
  Box<UserPlaylistSongs>? userPlaylistSongsInstance;

  @override
  void initState() {
    songDetailsBox = Hive.box<UserSongs>(songDetailListBoxName);
    userPlaylistNameInstance = Hive.box<UserPlaylistNames>(userPlaylistBoxName);
    userPlaylistSongsInstance =
        Hive.box<UserPlaylistSongs>(userPlaylistSongBoxName);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PlayerCurrespondingItems>(
      builder: (context, songDetailsProvider, child) {
        return Offstage(
          offstage: songDetailsProvider.isSelectedOrNot,
          child: Miniplayer(
            maxHeight: MediaQuery.of(context).size.height,
            minHeight: 80,
            builder: (height, percentage) {
              if (height <= 80) {
                if (songDetailsProvider.isAudioPlayingFromPlaylist == false) {
                  return ValueListenableBuilder(
                    valueListenable: songDetailsBox!.listenable(),
                    builder: (context, Box<UserSongs> songFetcher, _) {
                      List keys = [];
                      if (songDetailsProvider.modeOfPlaylist == 1) {
                        keys = songDetailsBox!.keys.cast<int>().toList();
                      } else if (songDetailsProvider.modeOfPlaylist == 2) {
                        keys = songFetcher.keys
                            .cast<int>()
                            .where((key) =>
                                songFetcher.get(key)!.isFavourited == true)
                            .toList();
                      }
                      if (keys.isNotEmpty) {
                        songDetailsProvider.currentSongKey =
                            keys[songDetailsProvider.selectedSongKey ?? 0];
                      }
                      var songData =
                          songFetcher.get(songDetailsProvider.currentSongKey);

                      if (songFetcher.isEmpty) {
                        return const Center(
                          child: Text("No Data Available"),
                        );
                      } else {
                        return Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: ListTile(
                                tileColor: Colors.white38,
                                isThreeLine: true,
                                leading: QueryArtworkWidget(
                                  id: songData?.imageId ?? 0,
                                  type: ArtworkType.AUDIO,
                                  nullArtworkWidget: Image.asset(
                                      "assets/images/defaultImage.png"),
                                  // artworkWidth: 200,
                                ),
                                title: commonMarquees(
                                    text: songData?.songName,
                                    hPadding: 0.0,
                                    size: 13.0,
                                    height: 25.0),
                                subtitle: commonMarquees(
                                    text: songData?.artistName,
                                    hPadding: 0.0,
                                    size: 11.0,
                                    height: 25.0),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: IconButton(
                                      onPressed: () {
                                        debugPrint("Previous Icon Clicked");
                                        songDetailsProvider.prev();
                                      },
                                      icon: const Icon(FontAwesome.left_dir),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      songDetailsProvider.playOrpause();
                                    },
                                    icon: songDetailsProvider.isIconChanged
                                        ? const Icon(
                                            Icons.pause,
                                            size: 32,
                                          )
                                        : const Icon(
                                            Icons.play_arrow,
                                            size: 32,
                                          ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      debugPrint("Next Icon Pressed");
                                      songDetailsProvider.next();
                                    },
                                    icon: const Icon(FontAwesome.right_dir),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  );
                } else {
                  return ValueListenableBuilder(
                    valueListenable: userPlaylistSongsInstance!.listenable(),
                    builder: (context, Box<UserPlaylistSongs> songFetcher, _) {
                      List keys = songFetcher.keys
                          .cast<int>()
                          .where((key) =>
                              songFetcher.get(key)!.currespondingPlaylistId ==
                              songDetailsProvider.test)
                          .toList();

                      songDetailsProvider.currentSongKey =
                          keys[songDetailsProvider.selectedSongKey!];
                      // songDetailsProvider.selectedSongKey;

                      var songData =
                          songFetcher.get(songDetailsProvider.currentSongKey);

                      if (songFetcher.isEmpty) {
                        return const Center(
                          child: Text("No Data Available"),
                        );
                      } else {
                        return Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: ListTile(
                                tileColor: Colors.white38,
                                isThreeLine: true,
                                leading: QueryArtworkWidget(
                                  id: songData!.songImageId!,
                                  type: ArtworkType.AUDIO,
                                  nullArtworkWidget: Image.asset(
                                      "assets/images/defaultImage.png"),
                                  // artworkWidth: 200,
                                ),
                                title: commonMarquees(
                                    text: songData.songName,
                                    hPadding: 0.0,
                                    size: 13.0,
                                    height: 25.0),
                                subtitle: commonMarquees(
                                    text: songData.artistName,
                                    hPadding: 0.0,
                                    size: 11.0,
                                    height: 25.0),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: IconButton(
                                      onPressed: () {
                                        debugPrint("Previous Icon Clicked");
                                        songDetailsProvider.prev();
                                      },
                                      icon: const Icon(FontAwesome.left_dir),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      songDetailsProvider.playOrpause();
                                    },
                                    icon: songDetailsProvider.isIconChanged
                                        ? const Icon(
                                            Icons.pause,
                                            size: 32,
                                          )
                                        : const Icon(
                                            Icons.play_arrow,
                                            size: 32,
                                          ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      debugPrint("Next Icon Pressed");
                                      songDetailsProvider.next();
                                    },
                                    icon: const Icon(FontAwesome.right_dir),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  );
                }
              } else {
                bool addToFavs = false;
                if (songDetailsProvider.isAudioPlayingFromPlaylist == false) {
                  return Consumer<PlayerCurrespondingItems>(
                    builder: (_, setSongDetails, child) => Container(
                      margin: const EdgeInsets.only(top: 20),
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height,
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(24),
                              topRight: Radius.circular(24))),
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          ValueListenableBuilder(
                            valueListenable: songDetailsBox!.listenable(),
                            builder: (context, Box<UserSongs> songFetcher, _) {
                              songDetailsProvider.currentSongKey =
                                  songDetailsProvider.selectedSongKey;

                              var songData = songFetcher
                                  .get(songDetailsProvider.currentSongKey);

                              if (songFetcher.isEmpty) {
                                return const Center(
                                  child: Text("No Songs Available"),
                                );
                              } else {
                                return SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      sizedh2,
                                      Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 30),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              commonText(
                                                  text: "Now Playing",
                                                  size: 17),
                                              Row(
                                                children: [
                                                  IconButton(
                                                    onPressed: () {
                                                      if (songData!
                                                              .isFavourited ==
                                                          true) {
                                                        addToFavs = false;
                                                      } else {
                                                        addToFavs = true;
                                                      }
                                                      final model = UserSongs(
                                                          songName:
                                                              songData.songName,
                                                          artistName: songData
                                                              .artistName,
                                                          duration:
                                                              songData.duration,
                                                          songPath:
                                                              songData.songPath,
                                                          imageId:
                                                              songData.imageId,
                                                          isAddedtoPlaylist:
                                                              false,
                                                          isFavourited:
                                                              addToFavs);
                                                      songFetcher.putAt(
                                                          songDetailsProvider
                                                              .currentSongKey!,
                                                          model);
                                                      debugPrint(
                                                          "Added to Favourites $addToFavs");
                                                      showFavouriteSnackBar(
                                                          context: context,
                                                          isFavourite:
                                                              addToFavs);
                                                    },
                                                    icon: const Icon(
                                                        CupertinoIcons.heart),
                                                    color:
                                                        songData!.isFavourited
                                                            ? Colors.red
                                                            : Colors.black87,
                                                  ),
                                                  PopupMenuButton(
                                                    onSelected: (result) {
                                                      if (result == 1) {
                                                        showPlaylistNames(
                                                            context,
                                                            songDetailsProvider
                                                                .currentSongKey);
                                                      } else if (result == 2) {
                                                        createPlaylist(
                                                            context,
                                                            songDetailsProvider
                                                                .currentSongKey);
                                                      }
                                                    },
                                                    itemBuilder: (context) => [
                                                      const PopupMenuItem(
                                                        child: Text(
                                                            "Add to Playlist"),
                                                        value: 1,
                                                      ),
                                                      const PopupMenuItem(
                                                        child: Text(
                                                            "Create Playlist"),
                                                        value: 2,
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              )
                                            ],
                                          )),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.05,
                                      ),
                                      Container(
                                        height: 200,
                                        width: 200,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: commonColor, width: 3),
                                            shape: BoxShape.circle),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: QueryArtworkWidget(
                                            id: songData.imageId!,
                                            type: ArtworkType.AUDIO,
                                            artworkBorder:
                                                const BorderRadius.all(
                                                    Radius.circular(100)),
                                            artworkFit: BoxFit.fill,
                                            artworkHeight: double.infinity,
                                            artworkWidth: double.infinity,
                                            nullArtworkWidget: ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(100)),
                                              child: Image.asset(
                                                "assets/images/defaultImage.png",
                                              ),
                                            ),
                                            // artworkWidth: 200,
                                          ),
                                        ),
                                      ),
                                      sizedh2,
                                      commonMarquees(
                                          text: songData.songName,
                                          size: 18.0,
                                          height: 30.0,
                                          duration: 23),
                                      commonMarquees(
                                        text: songData.artistName,
                                        size: 13.0,
                                        color: HexColor("656F77"),
                                      ),
                                      sizedh2,
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.8,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                setSongDetails.loopSongs();
                                              },
                                              icon: setSongDetails.loopIcon == 1
                                                  ? const Icon(
                                                      Typicons.loop,
                                                      size: 26,
                                                      color: Colors.blueAccent,
                                                    )
                                                  : setSongDetails.loopIcon == 2
                                                      ? const Icon(
                                                          Icons
                                                              .playlist_play_outlined,
                                                          size: 26,
                                                          color:
                                                              Colors.blueAccent,
                                                        )
                                                      : const Icon(
                                                          Icons.loop_outlined,
                                                          size: 26,
                                                        ),
                                              // icon: Icon(Icons.loop_outlined,
                                              //     size: 26,
                                              //     color: setSongDetails.isRepeat
                                              //         ? Colors.blueAccent
                                              //         : HexColor("#656F77")),
                                            ),
                                            sizedw1,
                                            IconButton(
                                              onPressed: () {
                                                songDetailsProvider.prev();
                                              },
                                              icon: const Icon(
                                                FontAwesome.left_dir,
                                                size: 37,
                                              ),
                                            ),
                                            sizedw2,
                                            Container(
                                              width: 80,
                                              height: 80,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: commonColor),
                                              child: IconButton(
                                                onPressed: () {
                                                  setSongDetails.playOrpause();
                                                },
                                                icon:
                                                    setSongDetails.isIconChanged
                                                        ? const Icon(
                                                            Icons.pause,
                                                            size: 60,
                                                            color: Colors.white,
                                                          )
                                                        : const Icon(
                                                            Icons.play_arrow,
                                                            size: 60,
                                                            color: Colors.white,
                                                          ),
                                              ),
                                            ),
                                            sizedw2,
                                            IconButton(
                                              onPressed: () {
                                                setSongDetails.next();
                                              },
                                              icon: const Icon(
                                                FontAwesome.right_dir,
                                                size: 37,
                                              ),
                                            ),
                                            sizedw2,
                                            IconButton(
                                              onPressed: () {
                                                setSongDetails.shuffleSongs();
                                              },
                                              icon: Icon(
                                                Entypo.shuffle,
                                                size: 22,
                                                color: setSongDetails.isShuffled
                                                    ? Colors.blueAccent
                                                    : HexColor("#656F77"),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      sizedh2,
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.8,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child:
                                                  setSongDetails.getDuration(),
                                            ),
                                            Expanded(
                                              flex: 3,
                                              child: setSongDetails.slider(),
                                            ),
                                            Expanded(
                                              child: setSongDetails
                                                  .totalDuration(),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return Consumer<PlayerCurrespondingItems>(
                    builder: (_, setSongDetails, child) => Container(
                      margin: const EdgeInsets.only(top: 20),
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height,
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(24),
                              topRight: Radius.circular(24))),
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          ValueListenableBuilder(
                            valueListenable:
                                userPlaylistSongsInstance!.listenable(),
                            builder: (context,
                                Box<UserPlaylistSongs> songFetcher, _) {
                              List keys = songFetcher.keys
                                  .cast<int>()
                                  .where((key) =>
                                      songFetcher
                                          .get(key)!
                                          .currespondingPlaylistId ==
                                      songDetailsProvider.test)
                                  .toList();

                              songDetailsProvider.currentSongKey = keys[
                                  songDetailsProvider.selectedSongKey ?? 0];
                              // songDetailsProvider.selectedSongKey;

                              var songData = songFetcher
                                  .get(songDetailsProvider.currentSongKey);

                              if (songFetcher.isEmpty) {
                                return const Center(
                                  child: Text("No Songs Available"),
                                );
                              } else {
                                return SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      sizedh2,
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 30),
                                        child: commonText(
                                            text: "Now Playing", size: 17),
                                      ),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.05,
                                      ),
                                      Container(
                                        height: 200,
                                        width: 200,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: commonColor, width: 3),
                                            shape: BoxShape.circle),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: QueryArtworkWidget(
                                            id: songData!.songImageId ?? 0,
                                            type: ArtworkType.AUDIO,
                                            artworkBorder:
                                                const BorderRadius.all(
                                                    Radius.circular(100)),
                                            artworkFit: BoxFit.fill,
                                            artworkHeight: double.infinity,
                                            artworkWidth: double.infinity,
                                            nullArtworkWidget: ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(100)),
                                              child: Image.asset(
                                                "assets/images/defaultImage.png",
                                              ),
                                            ),
                                            // artworkWidth: 200,
                                          ),
                                        ),
                                      ),
                                      sizedh2,
                                      commonMarquees(
                                          text: songData.songName,
                                          size: 18.0,
                                          height: 30.0,
                                          duration: 23),
                                      commonMarquees(
                                        text: songData.artistName,
                                        size: 13.0,
                                        color: HexColor("656F77"),
                                      ),
                                      sizedh2,
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.8,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                setSongDetails.loopSongs();
                                              },
                                              icon: setSongDetails.loopIcon == 1
                                                  ? const Icon(
                                                      Typicons.loop,
                                                      size: 26,
                                                      color: Colors.blueAccent,
                                                    )
                                                  : setSongDetails.loopIcon == 2
                                                      ? const Icon(
                                                          Icons
                                                              .playlist_play_outlined,
                                                          size: 26,
                                                          color:
                                                              Colors.blueAccent,
                                                        )
                                                      : const Icon(
                                                          Icons.loop_outlined,
                                                          size: 26,
                                                        ),
                                            ),
                                            sizedw1,
                                            IconButton(
                                              onPressed: () {
                                                songDetailsProvider.prev();
                                              },
                                              icon: const Icon(
                                                FontAwesome.left_dir,
                                                size: 37,
                                              ),
                                            ),
                                            sizedw2,
                                            Container(
                                              width: 80,
                                              height: 80,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: commonColor),
                                              child: IconButton(
                                                onPressed: () {
                                                  setSongDetails.playOrpause();
                                                },
                                                icon:
                                                    setSongDetails.isIconChanged
                                                        ? const Icon(
                                                            Icons.pause,
                                                            size: 60,
                                                            color: Colors.white,
                                                          )
                                                        : const Icon(
                                                            Icons.play_arrow,
                                                            size: 60,
                                                            color: Colors.white,
                                                          ),
                                              ),
                                            ),
                                            sizedw2,
                                            IconButton(
                                              onPressed: () {
                                                setSongDetails.next();
                                              },
                                              icon: const Icon(
                                                FontAwesome.right_dir,
                                                size: 37,
                                              ),
                                            ),
                                            sizedw2,
                                            Expanded(
                                              child: IconButton(
                                                onPressed: () {
                                                  setSongDetails.shuffleSongs();
                                                },
                                                icon: Icon(
                                                  Entypo.shuffle,
                                                  size: 22,
                                                  color:
                                                      setSongDetails.isShuffled
                                                          ? Colors.blueAccent
                                                          : HexColor("#656F77"),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      sizedh2,
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.8,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child:
                                                  setSongDetails.getDuration(),
                                            ),
                                            Expanded(
                                              flex: 3,
                                              child: setSongDetails.slider(),
                                            ),
                                            Expanded(
                                              child: setSongDetails
                                                  .totalDuration(),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                }
              }
            },
          ),
        );
      },
    );
  }

  showPlaylistNames(BuildContext context, songKey) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Add to...'),
        content: SizedBox(
          height: 100,
          width: 200,
          child: ValueListenableBuilder(
              valueListenable: userPlaylistNameInstance!.listenable(),
              builder: (context, Box<UserPlaylistNames> songFetcher, _) {
                List<int> allKeys =
                    userPlaylistNameInstance!.keys.cast<int>().toList();
                return ListView.separated(
                    itemBuilder: (_, index) {
                      final key = allKeys[index];
                      final currentPlaylist = songFetcher.get(key);
                      return GestureDetector(
                        onTap: () {
                          debugPrint(
                              "${currentPlaylist!.playlistNames} Selected");
                          debugPrint("Key is $key");
                          final songData = songDetailsBox!.get(songKey);
                          final model = UserPlaylistSongs(
                              currespondingPlaylistId: key,
                              songName: songData!.songName,
                              artistName: songData.artistName,
                              songPath: songData.songPath,
                              songImageId: songData.imageId,
                              songDuration: songData.duration);
                          userPlaylistSongsInstance!.add(model);
                          Navigator.of(context).pop();
                          showPlaylistSnackBar(context: context, isAdded: true);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  currentPlaylist!.playlistNames.toString(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (_, index) => const Divider(),
                    itemCount: allKeys.length);
              }),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  createPlaylist(BuildContext context, songKey) {
    var playlistName = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Create New Playlist'),
        content: TextFormField(
          controller: playlistName,
          decoration: const InputDecoration(
              hintText: "Enter The Name of Your Playlist"),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final playlistNameFromTextField = playlistName.text;
              final playlistModelVariable =
                  UserPlaylistNames(playlistNames: playlistNameFromTextField);
              userPlaylistNameInstance!.add(playlistModelVariable);
              final songData = songDetailsBox!.get(songKey);
              final model = UserPlaylistSongs(
                  currespondingPlaylistId: userPlaylistNameInstance!.keys.last,
                  songName: songData!.songName,
                  artistName: songData.artistName,
                  songImageId: songData.imageId,
                  songDuration: songData.duration,
                  songPath: songData.songPath);
              userPlaylistSongsInstance!.add(model);
              Navigator.of(context).pop();
              showPlaylistSnackBar(context: context, isAdded: true);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}

showFavouriteSnackBar({required BuildContext context, isFavourite}) {
  final snack = SnackBar(
    content: isFavourite!
        ? commonText(
            text: "Added to Favourites",
            color: Colors.green,
            size: 13,
            weight: FontWeight.w500,
            isCenter: true)
        : commonText(
            text: "Removed from Favourites",
            color: Colors.red,
            size: 13,
            weight: FontWeight.w500,
            isCenter: true),
    duration: const Duration(seconds: 1),
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(24),
    ),
    backgroundColor: Colors.white,
    width: 250,
  );
  return ScaffoldMessenger.of(context).showSnackBar(snack);
}

showPlaylistSnackBar({required BuildContext context, isAdded}) {
  final snack = SnackBar(
    content: isAdded!
        ? commonText(
            text: "Added to Playlist",
            color: Colors.green,
            size: 13,
            weight: FontWeight.w500,
            isCenter: true)
        : commonText(
            text: "Removed from Playlist",
            color: Colors.red,
            size: 13,
            weight: FontWeight.w500,
            isCenter: true),
    duration: const Duration(seconds: 1),
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(24),
    ),
    backgroundColor: Colors.white,
    width: 250,
  );
  return ScaffoldMessenger.of(context).showSnackBar(snack);
}

commonMarquees(
    {height,
    width,
    hPadding,
    vPadding,
    text = "",
    velocity,
    blankSpace,
    color,
    weight,
    size,
    family,
    duration}) {
  return SizedBox(
    height: height ?? 50,
    width: width ?? double.infinity,
    child: Padding(
      padding: EdgeInsets.symmetric(
        horizontal: hPadding ?? 40.0,
        vertical: vPadding ?? 0.0,
      ),
      child: Marquee(
        text: text ?? "Not Found",
        blankSpace: blankSpace ?? 300,
        numberOfRounds: 1,
        velocity: velocity ?? 30,
        pauseAfterRound: Duration(seconds: duration ?? 3),
        style: style(
            color: color ?? Colors.black,
            weight: weight ?? FontWeight.w700,
            size: size,
            family: family ?? "Poppins-Regular"),
      ),
    ),
  );
}

//
// class DrawerAll extends StatefulWidget {
//   const DrawerAll({Key? key}) : super(key: key);
//
//   @override
//   _DrawerAllState createState() => _DrawerAllState();
// }
//
// class _DrawerAllState extends State<DrawerAll> {
//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       child: ListView(
//         children: [
//           Container(
//             width: double.infinity,
//             padding: EdgeInsets.only(top: 50, left: 30),
//             height: 150,
//             decoration: BoxDecoration(
//               color: HexColor("#A6B9FF"),
//               borderRadius: BorderRadius.only(
//                   bottomLeft: Radius.circular(30),
//                   bottomRight: Radius.circular(30)),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     Image.asset(
//                       "assets/images/MusInNoBackground.png",
//                       height: 34,
//                       width: 45,
//                     ),
//                     commonText(
//                         text: "MusIn", color: HexColor("#1814E4"), size: 27),
//                   ],
//                 ),
//                 commonText(
//                     text: "\tHear The Best",
//                     size: 12,
//                     color: HexColor("#656F77"))
//               ],
//             ),
//           ),
//           const SizedBox(
//             height: 40,
//           ),
//           sizedh2,
//           Container(
//             margin: EdgeInsets.symmetric(horizontal: 35),
//             child: Column(
//               children: [
//                 drawerItems(itemName: "Favourites", routName: "/favourites"),
//                 sizedh2,
//                 drawerItems(itemName: "Playlist", routName: "/playlist"),
//                 // sizedh2,
//                 // drawerItems(itemName: "Search",routName: "/searchSong"),
//                 sizedh2,
//                 drawerItems(itemName: "Settings", routName: "/settings"),
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
//
//   drawerItems({required itemName, size, required routName}) {
//     return GestureDetector(
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           commonText(text: itemName, size: size ?? 17),
//           Icon(
//             Icons.arrow_forward_ios_rounded,
//             size: 15,
//           ),
//         ],
//       ),
//       onTap: () {
//         Navigator.of(context).pop();
//         Navigator.pushNamed(context, routName);
//       },
//     );
//   }
// }
//
// class FavouriteSongs extends StatefulWidget {
//   @override
//   _FavouriteSongsState createState() => _FavouriteSongsState();
// }
//
// class _FavouriteSongsState extends State<FavouriteSongs> {
//   Box<UserSongs>? userSongDbInstance;
//
//   @override
//   void initState() {
//     userSongDbInstance = Hive.box<UserSongs>(songDetailListBoxName);
//     super.initState();
//   }
//   @override
//   Widget build(BuildContext context) {
//
//   }
// }

var screenHeight, screenWidth;
var sizedh1 = const SizedBox(
  height: 10,
);
var sizedh2 = const SizedBox(
  height: 20,
);
var sizedw1 = const SizedBox(
  width: 10,
);
var sizedw2 = const SizedBox(
  width: 10,
);
