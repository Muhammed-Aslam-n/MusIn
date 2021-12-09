import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/entypo_icons.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:fluttericon/typicons_icons.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:musin/database/database.dart';
import 'package:musin/materials/colors.dart';
import 'package:musin/pages/widgets/widgets.dart';
import 'package:musin/provider/provider_class.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import '../home.dart';

// Provider Integrated Working Player database


// Class For Showing MiniPlayer in Application

class CommonMiniPlayer extends StatefulWidget {
  const CommonMiniPlayer({
    Key? key,
  }) : super(key: key);

  @override
  State<CommonMiniPlayer> createState() => _CommonMiniPlayerState();
}

class _CommonMiniPlayerState extends State<CommonMiniPlayer> {
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
                  return const MiniPlayerForAllSongsAndFavourites();
                } else {
                  // MiniPlayer For Playlist is Here !!!!
                  return const MiniPlayerForPlaylist();
                }
              } else {
                if (songDetailsProvider.isAudioPlayingFromPlaylist == false) {
                  return const MainSongForAllSongsAndFavourites();
                } else {
                  // MiniPlayer For Playlist is Here !!!!
                  return const MainPageForPlaylist();
                }
              }
            },
          ),
        );
      },
    );
  }
}






//--------------------------------------------------------------------------------------
// MiniPlayerClass For Displaying Both Songs from Song Database(All Songs and Favourites)

class MiniPlayerForAllSongsAndFavourites extends StatefulWidget {
  const MiniPlayerForAllSongsAndFavourites({Key? key}) : super(key: key);

  @override
  State<MiniPlayerForAllSongsAndFavourites> createState() =>
      _MiniPlayerForAllSongsAndFavouritesState();
}

class _MiniPlayerForAllSongsAndFavouritesState
    extends State<MiniPlayerForAllSongsAndFavourites> {
  Box<UserSongs>? songDetailsBox;

  @override
  void initState() {
    songDetailsBox = Hive.box<UserSongs>(songDetailListBoxName);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PlayerCurrespondingItems>(
      builder: (_, songDetailsProvider, child) {
        return ValueListenableBuilder(
          valueListenable: songDetailsBox!.listenable(),
          builder: (context, Box<UserSongs> songFetcher, _) {
            List keys = [];
            if (songDetailsProvider.modeOfPlaylist == 1) {
              keys = songDetailsBox!.keys.cast<int>().toList();
            } else if (songDetailsProvider.modeOfPlaylist == 2) {
              keys = songFetcher.keys
                  .cast<int>()
                  .where((key) => songFetcher.get(key)!.isFavourited == true)
                  .toList();
            }

            if (keys.isNotEmpty) {
              // debugPrint("\n---------------------");
              // songDetailsProvider.modeOfPlaylist == 1
              //     ? debugPrint("The Keys in Key According to the AllSongs is ")
              //     : debugPrint(
              //         "The Keys in Key According to the Favourite is ");
              // for (var element in keys) {
              //   var songData = songFetcher.get(element);
              //   debugPrint(
              //       "Song Name : ${songData?.songName?.split(" ")[0]} || Song's Key " +
              //           element.toString());
              // }
              // debugPrint("\n---------------------");
              songDetailsProvider.currentSongKey =
                  keys[songDetailsProvider.selectedSongKey ?? 0];
              debugPrint('GETTING CURRENT KEY IS ${songDetailsProvider.selectedSongKey}');
            }

            var songData = songFetcher.get(songDetailsProvider.currentSongKey);

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
                            "assets/images/playlist_Bg/playlist16.jpg",
                            fit: BoxFit.cover,
                            height: 50,
                            width: 50,
                          ),
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
      },
    );
  }
}

//--------------------------------------------------------------------------------------
// MiniPlayerClass For Displaying Songs from Playlist Database

class MiniPlayerForPlaylist extends StatefulWidget {
  const MiniPlayerForPlaylist({Key? key}) : super(key: key);

  @override
  _MiniPlayerForPlaylistState createState() => _MiniPlayerForPlaylistState();
}

class _MiniPlayerForPlaylistState extends State<MiniPlayerForPlaylist> {
  Box<UserPlaylistSongs>? userPlaylistSongsInstance;

  @override
  void initState() {
    userPlaylistSongsInstance =
        Hive.box<UserPlaylistSongs>(userPlaylistSongBoxName);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PlayerCurrespondingItems>(
      builder: (_, songDetailsProvider, child) => ValueListenableBuilder(
        valueListenable: userPlaylistSongsInstance!.listenable(),
        builder: (context, Box<UserPlaylistSongs> songFetcher, _) {
          List keys = songFetcher.keys
              .cast<int>()
              .where((key) =>
                  songFetcher.get(key)!.currespondingPlaylistId ==
                  songDetailsProvider.test)
              .toList();

          if (keys.isNotEmpty) {
            // debugPrint("\n---------------------");
            // debugPrint("The Keys in Key According to the Playlist Mode is ");
            // for (var element in keys) {
            //   var songData = songFetcher.get(element);
            //   debugPrint("Song Name : ${songData?.songName} || Song's Key " +
            //       element.toString());
            // }
            // debugPrint("\n---------------------");
            songDetailsProvider.currentSongKey =
                keys[songDetailsProvider.selectedSongKey ?? 0];
          }

          var songData = songFetcher.get(songDetailsProvider.currentSongKey);

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
                          "assets/images/playlist_Bg/playlist16.jpg",
                          height: 50,
                          width: 50,
                        ),
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
      ),
    );
  }
}


//--------------------------------------------------------------------------------------
// MainSongPlayingClass For Displaying Both Songs from Song Database(All Songs and Favourites)

class MainSongForAllSongsAndFavourites extends StatefulWidget {
  const MainSongForAllSongsAndFavourites({Key? key}) : super(key: key);

  @override
  _MainSongForAllSongsAndFavouritesState createState() =>
      _MainSongForAllSongsAndFavouritesState();
}

class _MainSongForAllSongsAndFavouritesState
    extends State<MainSongForAllSongsAndFavourites> {
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
      builder: (_, setSongDetails, child) => Container(
        margin: const EdgeInsets.only(top: 20),
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24), topRight: Radius.circular(24))),
        child: ListView(
          shrinkWrap: true,
          children: [
            ValueListenableBuilder(
              valueListenable: songDetailsBox!.listenable(),
              builder: (context, Box<UserSongs> songFetcher, _) {
                List keys = [];
                if (setSongDetails.modeOfPlaylist == 1) {
                  if(setSongDetails.isShuffled){
                    //
                    // debugPrint("Is the List is Shuffling Aslam ? ${setSongDetails.isShuffled}");
                    //
                    // debugPrint("Then The Songs List after Shuffling is ");
                    // setSongDetails.showKeys();
                  }



                  keys = songDetailsBox!.keys.cast<int>().toList();
                } else if (setSongDetails.modeOfPlaylist == 2) {
                  keys = songFetcher.keys
                      .cast<int>()
                      .where(
                          (key) => songFetcher.get(key)!.isFavourited == true)
                      .toList();
                }

                if (keys.isNotEmpty) {
                  // debugPrint("\n---------------------");
                  // debugPrint("The Keys in Key According to the Mode is ");
                  // for (var element in keys) {
                  //   debugPrint(element.toString());
                  // }
                  // debugPrint("\n---------------------");
                  setSongDetails.currentSongKey =
                      keys[setSongDetails.selectedSongKey ?? 0];
                }

                var songData = songFetcher.get(setSongDetails.currentSongKey);
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
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              commonText(text: "Now Playing", size: 17),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      if (songData!.isFavourited == true) {
                                        addToFavs = false;
                                      } else {
                                        addToFavs = true;
                                      }
                                      makeFavouriteSong(
                                        songFetcher: songFetcher,
                                        songDatas: songData,
                                        putKey: setSongDetails.currentSongKey,
                                        addToFav: addToFavs,
                                        context: context,
                                      );
                                      debugPrint(
                                          "Added to Favourites $addToFavs");
                                      showFavouriteSnackBar(
                                          context: context,
                                          isFavourite: addToFavs);
                                    },
                                    icon: const Icon(CupertinoIcons.heart),
                                    color: songData!.isFavourited
                                        ? Colors.red
                                        : Colors.black87,
                                  ),
                                  PopupMenuButton(
                                    onSelected: (result) {
                                      if (result == 1) {
                                        showPlaylistNames(
                                            context,
                                            setSongDetails.currentSongKey,
                                            songData.songName);
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
                          height: MediaQuery.of(context).size.height * 0.05,
                        ),
                        Container(
                          height: 200,
                          width: 200,
                          decoration: BoxDecoration(
                              border: Border.all(color: commonColor, width: 3),
                              shape: BoxShape.circle),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: QueryArtworkWidget(
                              id: songData.imageId!,
                              type: ArtworkType.AUDIO,
                              artworkBorder:
                                  const BorderRadius.all(Radius.circular(100)),
                              artworkFit: BoxFit.fill,
                              artworkHeight: double.infinity,
                              artworkWidth: double.infinity,
                              nullArtworkWidget: ClipRRect(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(100)),
                                child: Image.asset(
                                  "assets/images/playlist_Bg/playlist16.jpg",
                                  height: 100,
                                  fit: BoxFit.cover,
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
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                            Icons.playlist_play_outlined,
                                            size: 26,
                                            color: Colors.blueAccent,
                                          )
                                        : const Icon(
                                            Icons.loop_outlined,
                                            size: 26,
                                          ),
                              ),
                              sizedw1,
                              IconButton(
                                onPressed: () {
                                  setSongDetails.prev();
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
                                    shape: BoxShape.circle, color: commonColor),
                                child: IconButton(
                                  onPressed: () {
                                    setSongDetails.playOrpause();
                                  },
                                  icon: setSongDetails.isIconChanged
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
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: setSongDetails.getDuration(),
                              ),
                              Expanded(
                                flex: 3,
                                child: setSongDetails.giveProgressBar(),
                              ),
                              Expanded(
                                child: setSongDetails.totalDuration(),
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

  makeFavouriteSong(
      {required BuildContext context,
      UserSongs? songDatas,
      required Box songFetcher,
      required putKey,
      addToFav}) {
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
    songFetcher.putAt(putKey, model);
    return showFavouriteSnackBar(context: context, isFavourite: addToFavs);
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
                                // List<int> keys = userPlaylistSongsInstance!.keys
                                //     .cast<int>()
                                //     .where((key) =>
                                //         userPlaylistSongsInstance!
                                //             .get(key)!
                                //             .currespondingPlaylistId ==
                                //         key)
                                //     .toList();
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

//--------------------------------------------------------------------------------------
// MainSongPlayingClass For Displaying Songs from Playlist Database

class MainPageForPlaylist extends StatefulWidget {
  const MainPageForPlaylist({Key? key}) : super(key: key);

  @override
  _MainPageForPlaylistState createState() => _MainPageForPlaylistState();
}

class _MainPageForPlaylistState extends State<MainPageForPlaylist> {
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
      builder: (_, setSongDetails, child) => Container(
        margin: const EdgeInsets.only(top: 20),
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24), topRight: Radius.circular(24))),
        child: ListView(
          shrinkWrap: true,
          children: [
            ValueListenableBuilder(
              valueListenable: userPlaylistSongsInstance!.listenable(),
              builder: (context, Box<UserPlaylistSongs> songFetcher, _) {
                List keys = songFetcher.keys
                    .cast<int>()
                    .where((key) =>
                        songFetcher.get(key)!.currespondingPlaylistId ==
                        setSongDetails.test)
                    .toList();

                setSongDetails.currentSongKey =
                    keys[setSongDetails.selectedSongKey ?? 0];

                // songDetailsProvider.selectedSongKey;

                var songData = songFetcher.get(setSongDetails.currentSongKey);

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
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: commonText(text: "Now Playing", size: 17),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05,
                        ),
                        Container(
                          height: 200,
                          width: 200,
                          decoration: BoxDecoration(
                              border: Border.all(color: commonColor, width: 3),
                              shape: BoxShape.circle),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: QueryArtworkWidget(
                              id: songData!.songImageId ?? 0,
                              type: ArtworkType.AUDIO,
                              artworkBorder:
                                  const BorderRadius.all(Radius.circular(100)),
                              artworkFit: BoxFit.fill,
                              artworkHeight: double.infinity,
                              artworkWidth: double.infinity,
                              nullArtworkWidget: ClipRRect(
                                borderRadius: const BorderRadius.all(
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
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                            Icons.playlist_play_outlined,
                                            size: 26,
                                            color: Colors.blueAccent,
                                          )
                                        : const Icon(
                                            Icons.loop_outlined,
                                            size: 26,
                                          ),
                              ),
                              sizedw1,
                              IconButton(
                                onPressed: () {
                                  setSongDetails.prev();
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
                                    shape: BoxShape.circle, color: commonColor),
                                child: IconButton(
                                  onPressed: () {
                                    setSongDetails.playOrpause();
                                  },
                                  icon: setSongDetails.isIconChanged
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
                                    color: setSongDetails.isShuffled
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
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: setSongDetails.getDuration(),
                              ),
                              Expanded(
                                flex: 3,
                                child: setSongDetails.giveProgressBar(),
                              ),
                              Expanded(
                                child: setSongDetails.totalDuration(),
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
