import 'package:assets_audio_player/assets_audio_player.dart' as aap;
import 'package:assets_audio_player/assets_audio_player.dart';
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

class CommonAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CommonAppBar({Key? key}) : super(key: key);

  @override
  _CommonAppBarState createState() => _CommonAppBarState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(80);
}

class _CommonAppBarState extends State<CommonAppBar> {
  bool _switchValue = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Padding(
          padding: const EdgeInsets.only(top: 18),
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
                                var pInstance = Provider.of<PlayerCurrespondingItems>(context,listen: false);
                                pInstance.turnNotificationOn?AssetsAudioPlayer.addNotificationOpenAction((notification) => false):AssetsAudioPlayer.addNotificationOpenAction((notification) => true);

                                pInstance.turnNotificationOn?pInstance.turnNotificationOn = false:pInstance.turnNotificationOn = true;


                                _switchValue = value;
                                Navigator.of(context).pop();
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



// Provider Integrated Working Player database

class CommonMiniPlayer extends StatefulWidget {
  const CommonMiniPlayer({
    Key? key,
  }) : super(key: key);

  @override
  State<CommonMiniPlayer> createState() => _CommonMiniPlayerState();
}

class _CommonMiniPlayerState extends State<CommonMiniPlayer> {
  Box<UserSongs>? songDetailsBox;
  Box<UserPlaylistNames>? userPlaylistNameInstance;
  Box<UserPlaylistSongs>? userPlaylistSongsInstance;
  bool addToFavs = false;

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
                      } else if (songDetailsProvider.modeOfPlaylist == 2){
                        keys = songFetcher.keys
                            .cast<int>()
                            .where((key) =>
                                songFetcher.get(key)!.isFavourited == true)
                            .toList();
                      }

                      if (keys.isNotEmpty) {
                        debugPrint("\n---------------------");
                        debugPrint("The Keys in Key According to the Mode is ");
                        keys.forEach((element) {
                          debugPrint(element.toString() );
                        });
                        debugPrint("\n---------------------");
                        songDetailsProvider.currentSongKey =keys[songDetailsProvider.selectedSongKey??0];
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
                                  nullArtworkWidget: ClipRRect( 
                                    borderRadius: BorderRadius.circular(100),
                                    child: Image.asset(
                                        "assets/images/playlist_Bg/playlist16.jpg",fit: BoxFit.cover,height: 50,width: 50,),
                                  ),
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
                  // MiniPlayer For Playlist is Here !!!!
                  return ValueListenableBuilder(
                    valueListenable: userPlaylistSongsInstance!.listenable(),
                    builder: (context, Box<UserPlaylistSongs> songFetcher, _) {
                      List keys = songFetcher.keys
                          .cast<int>()
                          .where((key) =>
                              songFetcher.get(key)!.currespondingPlaylistId ==
                              songDetailsProvider.test)
                          .toList();

                      if (keys.isNotEmpty) {
                        debugPrint("\n---------------------");
                        debugPrint("The Keys in Key According to the Playlist Mode is ");
                        keys.forEach((element) {
                          debugPrint(element.toString() );
                        });
                        debugPrint("\n---------------------");
                        songDetailsProvider.currentSongKey =keys[songDetailsProvider.selectedSongKey??0];
                      }
                      // songDetailsProvider.currentSongKey =
                      //     keys[songDetailsProvider.selectedSongKey??0];
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
                                  nullArtworkWidget: ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: Image.asset(
                                        "assets/images/playlist_Bg/playlist16.jpg",height: 50,width: 50,),
                                  ),
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
                                                      addToFavourites(songFetcher: songFetcher,songDatas: songData,key: songDetailsProvider.currentSongKey);
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
                                                            context, setSongDetails.currentSongKey,songData.songName);
                                                      } else {
                                                        showPlaylistNameToRemove(
                                                            context, songData.songName);
                                                      }
                                                    },
                                                    itemBuilder: (context) => [
                                                      const PopupMenuItem(
                                                        child: Text("Add to Playlist"),
                                                        value: 1,
                                                      ),
                                                      const PopupMenuItem(
                                                        child: Text("Remove from Playlist"),
                                                        value: 2,
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
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
                                                "assets/images/playlist_Bg/playlist16.jpg",
                                                height: 100,fit: BoxFit.cover,
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
                                              child: setSongDetails.giveProgressBar(),
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
                  // MiniPlayer For Playlist is Here !!!!
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
                                                "assets/images/playlist_Bg/playlist16.jpg",
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
                                              child: setSongDetails.giveProgressBar(),
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

  addToFavourites({required Box songFetcher, UserSongs? songDatas, key}) {
    if (songDatas?.isFavourited == true) {
      addToFavs = false;
    } else {
      addToFavs = true;
    }
    final model = UserSongs(
        songName: songDatas?.songName,
        artistName: songDatas?.artistName,
        duration: songDatas?.duration,
        songPath: songDatas?.songPath,
        imageId: songDatas?.imageId,
        isAddedtoPlaylist: false,
        isFavourited: addToFavs);
    songFetcher.putAt(key, model);
    showFavouriteSnackBar(context: context, isFavourite: addToFavs);
  }

  showPlaylistNameToRemove(BuildContext context, songName) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Remove from...'),
        content: SizedBox(
          height: 100,
          width: 200,
          child: ValueListenableBuilder(
              valueListenable: userPlaylistNameInstance!.listenable(),
              builder: (context, Box<UserPlaylistNames> songFetcher, _) {
                List<int> allCurrespondingKeys = [];
                List<int> verumKeys = userPlaylistSongsInstance!.keys
                    .cast<int>()
                    .where((key) =>
                userPlaylistSongsInstance!.get(key)!.songName ==
                    songName)
                    .toList();
                for (var element in userPlaylistSongsInstance!.values) {
                  if (element.songName == songName) {
                    allCurrespondingKeys
                        .add(element.currespondingPlaylistId ?? 0);
                  }
                }

                int globalKey = 0;
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      flex: 2,
                      child: ListView.separated(
                          shrinkWrap: true,
                          itemBuilder: (_, index) {
                            final key = allCurrespondingKeys[index];
                            final currentPlaylist = songFetcher.get(key);
                            globalKey = key;
                            return GestureDetector(
                              onTap: () {
                                List<int> keys = userPlaylistSongsInstance!.keys
                                    .cast<int>()
                                    .where((key) =>
                                userPlaylistSongsInstance!
                                    .get(key)!
                                    .currespondingPlaylistId ==
                                    key)
                                    .toList();
                                var songFetch = verumKeys[index];
                                // var songData = songFetch!.get(key);
                                showPlaylistSnackBar(
                                    context: context, isAdded: false);
                                userPlaylistSongsInstance!.delete(songFetch);
                                Navigator.of(context).pop();
                              },
                              child: Padding(
                                padding:
                                const EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        currentPlaylist!.playlistNames
                                            .toString(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (_, index) => const Divider(),
                          itemCount: allCurrespondingKeys.length),
                    ),
                    Expanded(
                      child: ListTile(
                        title: const Text("New Playlist"),
                        trailing: IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            createPlaylistAndAdd(context, songKey: globalKey);
                          },
                          icon: const Icon(Icons.add),
                        ),
                      ),
                    ),
                  ],
                );
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

  createPlaylistAndAdd(BuildContext context, {songKey}) {
    var playlistName = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Create New Playlist'),
        content: TextFormField(
          controller: playlistName,
          decoration: const InputDecoration(hintText: "Your playlist name"),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              createPlaylistSub(playlistName);
              final songData = songDetailsBox!.get(songKey);
              addToCreatedPlaylist(songData);
            },
            child: const Text('create'),
          ),
        ],
      ),
    );
  }

  createPlaylistSub(playlistName) {
    final playlistNameFromTextField = playlistName.text;
    final playlistModelVariable =
    UserPlaylistNames(playlistNames: playlistNameFromTextField);
    userPlaylistNameInstance!.add(playlistModelVariable);
  }

  addToCreatedPlaylist(
      UserSongs? songData,
      ) {
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
  }

  showPlaylistNames(BuildContext context, songKey, songName) {
    bool alreadyExists = false;
    int? curr = 0;
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
              List songNonRepeatingPlaylistKey =
              userPlaylistNameInstance!.keys.cast<int>().toList();

              for (var element in userPlaylistSongsInstance!.values) {
                if (element.songName == songName) {
                  alreadyExists = true;
                }
              }

              if (alreadyExists) {
                for (var element in userPlaylistSongsInstance!.values) {
                  if (element.songName == songName) {
                    curr = element.currespondingPlaylistId;
                  }
                  for (var i = 0; i < songNonRepeatingPlaylistKey.length; i++) {
                    if (songNonRepeatingPlaylistKey[i] == curr) {
                      songNonRepeatingPlaylistKey.remove(curr);
                    }
                  }
                }
              } else if (alreadyExists == false) {
                songNonRepeatingPlaylistKey =
                    userPlaylistNameInstance!.keys.cast<int>().toList();
              }

              if (userPlaylistNameInstance!.isEmpty) {
                return SizedBox(
                  height: 200,
                  child: Column(
                    children: [
                      const ListTile(
                        title: Text("No Playlists Found"),
                      ),
                      Expanded(
                        child: ListTile(
                          title: Text(
                            "Create & Add",
                            style: TextStyle(color: HexColor("#A6B9FF")),
                          ),
                          trailing: IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              createPlaylistAndAdd(context, songKey: songKey);
                            },
                            icon: Icon(Icons.add, color: HexColor("#A6B9FF")),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                if (songNonRepeatingPlaylistKey.isEmpty) {
                  return Text(
                    "This Song has been added to your Playlists",
                    style: TextStyle(color: HexColor("#A6B9FF")),
                  );
                } else {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        flex: 2,
                        child: ListView.separated(
                          shrinkWrap: true,
                          itemBuilder: (_, index) {
                            final key = songNonRepeatingPlaylistKey[index];
                            final currentPlaylist = songFetcher.get(key);
                            return GestureDetector(
                              onTap: () {
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
                                showPlaylistSnackBar(
                                    context: context, isAdded: true);
                              },
                              child: Padding(
                                padding:
                                const EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        currentPlaylist!.playlistNames
                                            .toString(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (_, index) => const Divider(),
                          itemCount: songNonRepeatingPlaylistKey.length,
                        ),
                      ),
                      Expanded(
                        child: ListTile(
                          title: Text(
                            "Create & Add",
                            style: TextStyle(color: HexColor("#A6B9FF")),
                          ),
                          trailing: IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              createPlaylistAndAdd(context, songKey: songKey);
                            },
                            icon: Icon(Icons.add, color: HexColor("#A6B9FF")),
                          ),
                        ),
                      ),
                    ],
                  );
                }
              }
            },
          ),
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

var screenHeight,screenWidth;

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
