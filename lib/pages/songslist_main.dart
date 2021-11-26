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
          SongsListMain(),
          CommonMiniPlayer(),
        ],
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
  List<String> songsPaths =[];
  @override
  void initState() {
    songDbInstance = Hive.box<UserSongs>(songDetailListBoxName);
    userPlaylistNameInstance = Hive.box<UserPlaylistNames>(userPlaylistBoxName);
    userPlaylistSongsInstance = Hive.box<UserPlaylistSongs>(userPlaylistSongBoxName);
    getSongPathsMan();
    super.initState();
  }

  getSongPathsMan(){
    final pInstance = Provider.of<PlayerCurrespondingItems>(context, listen: false);
    if(pInstance.allSongsplayList.isEmpty){
      for (var element in songDbInstance!.values) {
        songsPaths.add(element.songPath!);
      }
    }
    pInstance.showKeys();
    debugPrint("SonglistMain Done");
  }
  changeModeOfPlay(){
    final pInstance = Provider.of<PlayerCurrespondingItems>(context, listen: false);
    pInstance.getAllSongsPaths(songsPaths);
    pInstance.modeOfPlaylist = 1;
  }

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
                  padding: const EdgeInsets.only(left: 13, top: 20),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: commonText(text: "Your Songs"),
                  ),
                ),
                sizedh1,
                imageContainer(context),
              ],
            ),
          ),
        ],
      ),
    );
  }



  // PLAYS WITH DATABASE and Provider also

  imageContainer(BuildContext context) {
    bool addToFavs = false;
    return Consumer<PlayerCurrespondingItems>(
      builder: (_, setSongDetails, child) => ValueListenableBuilder(
        valueListenable: songDbInstance!.listenable(),
        builder: (context, Box<UserSongs> songFetcher, _) {
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
                  childAspectRatio: 1.4 / 1.9,
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
                    // setSongDetails.isAllSongsAlreadyClicked = true;
                    changeModeOfPlay();
                    setSongDetails.isFavsAlreadyClicked = false;
                    setSongDetails.isSelectedOrNot = false;
                    setSongDetails.selectedSongKey = key;
                    setSongDetails.currentSongDuration =
                        songDatas?.duration.toString();
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
                              "assets/images/defaultImage.png",
                              height: MediaQuery.of(context).size.height * 0.16,
                              width: double.infinity,
                              fit: BoxFit.fill,
                            ),
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(24),
                                topRight: Radius.circular(24)),
                          ),
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
                                onPressed: () {
                                  if (songDatas.isFavourited == true) {
                                    addToFavs = false;
                                  } else {
                                    addToFavs = true;
                                  }
                                  final model = UserSongs(
                                      songName: songDatas.songName,
                                      artistName: songDatas.artistName,
                                      duration: songDatas.duration,
                                      songPath: songDatas.songPath,
                                      imageId: songDatas.imageId,
                                      isAddedtoPlaylist: false,
                                      isFavourited: addToFavs);
                                  songFetcher.putAt(key, model);
                                  debugPrint("Added to Favourites $addToFavs");
                                  showFavouriteSnackBar(
                                      context: context, isFavourite: addToFavs);
                                },
                                icon: Icon(CupertinoIcons.heart,
                                    color: songDatas.isFavourited
                                        ? Colors.red
                                        : Colors.black87),
                              ),
                              PopupMenuButton(
                                onSelected: (result) {
                                  if (result == 1) {
                                    showPlaylistNames(context, key);
                                  } else if (result == 2) {
                                    createPlaylist(context, key);
                                  }
                                },
                                itemBuilder: (context) => [
                                  const PopupMenuItem(
                                    child: Text("Add to Playlist"),
                                    value: 1,
                                  ),
                                  const PopupMenuItem(
                                    child: Text("Create Playlist"),
                                    value: 2,
                                  ),
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
                          showPlaylistSnackBar(context: context, isAdded: true);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
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
              final songData = songDbInstance!.get(songKey);
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
