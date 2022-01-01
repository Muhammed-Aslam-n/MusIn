import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:marquee/marquee.dart';
import 'package:musin/controller/musincontroller.dart';
import 'package:musin/database/database.dart';
import 'package:musin/materials/colors.dart';
import 'package:musin/pages/widgets/commonminiplayer.dart';
import 'package:musin/pages/widgets/widgets.dart';
import 'package:on_audio_query/on_audio_query.dart';

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
        children: [
          const SongListViewHolder(),
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
      appBar: CommonAppBar(),
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
  final musinController = Get.find<MusinController>();
  final OnAudioQuery audioQuery = OnAudioQuery();
  List<String> songsPaths = [];

  @override
  void initState() {
    getSongPathsMan();
    super.initState();
  }

  getSongPathsMan() {
    if (musinController.allSongsplayList.isEmpty) {
      for (var element in musinController.userSongsInstance!.values) {
        songsPaths.add(element.songPath!);
      }
    }
    musinController.playlistLength = songsPaths.length;
  }

  changeModeOfPlay() {
    musinController.getAllSongsPaths(songsPaths);
    musinController.modeOfPlaylist = 1;
  }

  bool addToFavourite = false;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: musinController.userSongsInstance!.listenable(),
        builder: (context, Box<UserSongs> songFetcher, _) {
          List<int> keys = songFetcher.keys.cast<int>().toList();
          if (songFetcher.isEmpty) {
            return Column(
              children:  const [
                Text("No Songs So Far..."),
                SizedBox(
                  height: 20,
                ),
                Text("Please Restart the Application")
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
                final songData = songFetcher.get(key);
                return GestureDetector(
                  onTap: () {
                    musinController.isAudioPlayingFromPlaylist = false;
                    changeModeOfPlay();
                    musinController.isSelectedOrNot = false;
                    musinController.selectedSongKey = index;
                    musinController.opnPlaylist(musinController.selectedSongKey);
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
                          id: songData!.imageId!,
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
                                  addToFavourites(songFetcher, songData, key);
                                },
                                icon: Icon(CupertinoIcons.heart,
                                    color: songData.isFavourited
                                        ? Colors.red
                                        : Colors.black87),
                              ),
                              PopupMenuButton(
                                onSelected: (result) {
                                  if (result == 1) {
                                    showPlaylistNames(
                                        context, key, songData.songName);
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
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Marquee(
                              text: songData.artistName ?? "No Artist",
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
                              text: songData.songName ?? "No Song name",
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
        }
    );
  }

  addToFavourites(Box songFetcher, UserSongs? songData, key) {
    if (songData?.isFavourited == true) {
      addToFavourite= false;
    } else {
      addToFavourite = true;
    }
    final model = UserSongs(
        songName: songData?.songName,
        artistName: songData?.artistName,
        duration: songData?.duration,
        songPath: songData?.songPath,
        imageId: songData?.imageId,
        isAddedtoPlaylist: false,
        isFavourited: addToFavourite);
    songFetcher.putAt(key, model);
    showFavouriteSnackBar(context,isFavourite: addToFavourite);
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
              valueListenable: musinController.userPlaylistNameDbInstance!.listenable(),
              builder: (context, Box<UserPlaylistNames> songFetcher, _) {
                List<int> allCurrespondingKeys = [];
                List<int> keys = musinController.userPlaylistSongsDbInstance!.keys
                    .cast<int>()
                    .where((key) =>
                musinController.userPlaylistSongsDbInstance!.get(key)!.songName ==
                        songName)
                    .toList();
                for (var element in musinController.userPlaylistSongsDbInstance!.values) {
                  if (element.songName == songName) {
                    allCurrespondingKeys
                        .add(element.currespondingPlaylistId ?? 0);
                  }
                }
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
                            return GestureDetector(
                              onTap: () {
                                var songFetch = keys[index];
                                showPlaylistSnackBar(
                                    context: context, isAdded: false);
                                musinController.userPlaylistSongsDbInstance!.delete(songFetch);
                                Get.back();
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
                  ],
                );
              }),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Get.back(),
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
            valueListenable: musinController.userPlaylistNameDbInstance!.listenable(),
            builder: (context, Box<UserPlaylistNames> songFetcher, _) {
              List songNonRepeatingPlaylistKey =
              musinController.userPlaylistNameDbInstance!.keys.cast<int>().toList();

              for (var element in musinController.userPlaylistSongsDbInstance!.values) {
                if (element.songName == songName) {
                  alreadyExists = true;
                }
              }

              if (alreadyExists) {
                for (var element in musinController.userPlaylistSongsDbInstance!.values) {
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
                    musinController.userPlaylistNameDbInstance!.keys.cast<int>().toList();
              }

              if (musinController.userPlaylistNameDbInstance!.isEmpty) {
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
                              Get.back();
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
                                final songData = musinController.userSongsInstance!.get(songKey);
                                final model = UserPlaylistSongs(
                                    currespondingPlaylistId: key,
                                    songName: songData!.songName,
                                    artistName: songData.artistName,
                                    songPath: songData.songPath,
                                    songImageId: songData.imageId,
                                    songDuration: songData.duration);
                                musinController.userPlaylistSongsDbInstance!.add(model);
                                Get.back();
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
                              Get.back();
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
            onPressed: () => Get.back(),
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
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              createPlaylistSub(playlistName);
              final songData = musinController.userSongsInstance!.get(songKey);
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
    musinController.userPlaylistNameDbInstance!.add(playlistModelVariable);
  }

  addToCreatedPlaylist(
    UserSongs? songData,
  ) {
    final model = UserPlaylistSongs(
        currespondingPlaylistId: musinController.userPlaylistNameDbInstance!.keys.last,
        songName: songData!.songName,
        artistName: songData.artistName,
        songImageId: songData.imageId,
        songDuration: songData.duration,
        songPath: songData.songPath);
    musinController.userPlaylistSongsDbInstance!.add(model);
    Get.back();
    showPlaylistSnackBar(context: context, isAdded: true);
  }
}
