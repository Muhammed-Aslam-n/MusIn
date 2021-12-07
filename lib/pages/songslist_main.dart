
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:marquee/marquee.dart';
import 'package:musin/database/database.dart';
import 'package:musin/materials/colors.dart';
import 'package:musin/pages/widgets/commonminiplayer.dart';
import 'package:musin/pages/widgets/widgets.dart';
import 'package:musin/provider/provider_class.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

import '../main.dart';

class SongListMainHolder extends StatefulWidget {
  const SongListMainHolder({Key? key}) : super(key: key);

  @override
  _SongListMainHolderState createState() => _SongListMainHolderState();
}

class _SongListMainHolderState extends State<SongListMainHolder> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: const [
          SongListViewHolder(),
          CommonMiniPlayer(),
        ],
      ),
    );
  }
}

class SongsMainHeaderClass extends StatelessWidget {
  const SongsMainHeaderClass({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 13, top: 20),
      child: Align(
        alignment: Alignment.topLeft,
        child: commonText(text: "Your Songs"),
      ),
    );
  }
}

class SongListViewHolder extends StatelessWidget {
  const SongListViewHolder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            const SongsMainHeaderClass(),
            sizedh1,
            const SongsListMain(),
          ],
        ),
      ),
    );
  }
}

class SongsListMain extends StatefulWidget {
  const SongsListMain({Key? key}) : super(key: key);

  @override
  _SongsListMainState createState() => _SongsListMainState();
}

var isSelected = true;

class _SongsListMainState extends State<SongsListMain> {
  final OnAudioQuery audioQuery = OnAudioQuery();
  Box<UserSongs>? songDbInstance;
  Box<UserPlaylistNames>? userPlaylistNameInstance;
  Box<UserPlaylistSongs>? userPlaylistSongsInstance;
  List<String> songsPaths = [];

  @override
  void initState() {
    songDbInstance = Hive.box<UserSongs>(songDetailListBoxName);
    userPlaylistNameInstance = Hive.box<UserPlaylistNames>(userPlaylistBoxName);
    userPlaylistSongsInstance =
        Hive.box<UserPlaylistSongs>(userPlaylistSongBoxName);
    getSongPathsMan();
    super.initState();
  }

  getSongPathsMan() {
    final pInstance =
        Provider.of<PlayerCurrespondingItems>(context, listen: false);
    if (pInstance.allSongsplayList.isEmpty) {
      for (var element in songDbInstance!.values) {
        songsPaths.add(element.songPath!);
      }
    }
    pInstance.showKeys();
    debugPrint("SonglistMain Done");
  }

  changeModeOfPlay() {
    final pInstance =
        Provider.of<PlayerCurrespondingItems>(context, listen: false);
    pInstance.getAllSongsPaths(songsPaths);
    pInstance.modeOfPlaylist = 1;
  }

  bool addToFavs = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<PlayerCurrespondingItems>(
      builder: (_, setSongDetails, child) => ValueListenableBuilder(
        valueListenable: songDbInstance!.listenable(),
        builder: (context, Box<UserSongs> songFetcher, _) {
          List<int> keys = songFetcher.keys.cast<int>().toList();
          if (songFetcher.isEmpty) {
            return Column(
              children:  [
                const Text("No Songs So Far..."),
                showRestartToast(context: context),
              ],
            );
          } else {
            return GridView.builder(
              physics: const ScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.34 / 1.9,
                  mainAxisSpacing: 18,
                  crossAxisSpacing: 12),
              shrinkWrap: true,
              itemCount: keys.length,
              itemBuilder: (context, index) {
                final key = keys[index];
                final songDatas = songFetcher.get(key);
                return GestureDetector(
                  onTap: () {
                    setSongDetails.isAudioPlayingFromPlaylist = false;
                    changeModeOfPlay();
                    setSongDetails.isSelectedOrNot = false;
                    setSongDetails.selectedSongKey = index;
                    setSongDetails.opnPlaylist(setSongDetails.selectedSongKey);
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
                          id: songDatas!.imageId!,
                          type: ArtworkType.AUDIO,
                          nullArtworkWidget: ClipRRect(
                            child: Image.asset(
                              "assets/images/playlist_Bg/playlist8.jpg",
                              height:
                                  MediaQuery.of(context).size.height * 0.196,
                              width: double.infinity,
                              fit: BoxFit.fill,
                            ),
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(24),
                                topRight: Radius.circular(24)),
                          ),
                          artworkHeight:
                              MediaQuery.of(context).size.height * 0.199,
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
                                onPressed: () {
                                  addToFavourites(songFetcher, songDatas, key);
                                },
                                icon: Icon(CupertinoIcons.heart,
                                    color: songDatas.isFavourited
                                        ? Colors.red
                                        : Colors.black87),
                              ),
                              PopupMenuButton(
                                onSelected: (result) {
                                  if (result == 1) {
                                    showPlaylistNames(
                                        context, key, songDatas.songName);
                                  } else {
                                    showPlaylistNameToRemove(
                                        context, songDatas.songName);
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
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Marquee(
                              text: songDatas.artistName ?? "No Artist",
                              blankSpace: 100,
                              velocity: 30,
                              pauseAfterRound: const Duration(seconds: 3),numberOfRounds: 1,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Marquee(
                              style: const TextStyle(fontFamily: "Poppins-Regular",fontSize: 18,fontWeight: FontWeight.w700),
                              text: songDatas.songName ?? "No Song name",
                              blankSpace: 100,
                              velocity: 30,
                              pauseAfterRound: const Duration(seconds: 3),numberOfRounds: 1,
                            ),
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

  addToFavourites(Box songFetcher, UserSongs? songDatas, key) {
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
                                final songData = songDbInstance!.get(songKey);
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
              final songData = songDbInstance!.get(songKey);
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

  showRestartToast({required BuildContext context}) {
    final snack = SnackBar(
      content:  commonText(
          text: "Please Restart Application",
          color: Colors.green,
          size: 13,
          weight: FontWeight.w500,
          isCenter: true),
      duration: const Duration(seconds:10),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      backgroundColor: Colors.white,
      width: 250,
    );
    return ScaffoldMessenger.of(context).showSnackBar(snack);
  }



}
