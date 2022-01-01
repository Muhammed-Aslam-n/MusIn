import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:musin/controller/musincontroller.dart';
import 'package:musin/database/database.dart';
import 'package:musin/materials/colors.dart';
import 'package:musin/pages/addsongtoplaylist.dart';
import 'package:musin/pages/widgets/commonminiplayer.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '/pages/widgets/widgets.dart';

class PlaylistSongs extends StatefulWidget {
  int? selectedPlaylistKey;
  int totalNumberOfSongs = 0;

  PlaylistSongs({Key? key, this.selectedPlaylistKey}) : super(key: key);

  @override
  _PlaylistSongsState createState() => _PlaylistSongsState();
}

class _PlaylistSongsState extends State<PlaylistSongs> {
  final musinController = Get.find<MusinController>();
  List<String> songsPaths = [];

  @override
  void initState() {
    getSongPathsMan();
    debugPrint("Inited");
    super.initState();
  }

  Future<void> getSongPathsMan() async {
    if (musinController.playlistSongsPlaylist.isEmpty) {
      debugPrint("\n---------------------------");
      debugPrint("INITIL - Playlistinte Akathulla Value");
      for (var element in musinController.userPlaylistSongsDbInstance!.values) {
        if (widget.selectedPlaylistKey == element.currespondingPlaylistId) {
          songsPaths.add(element.songPath ?? '');
          musinController.alreadyPlayingPlaylistIndex =
              element.currespondingPlaylistId!;
        }
      }
      debugPrint("\n---------------------------");
    } else {
      if (musinController.alreadyPlayingPlaylistIndex !=
          widget.selectedPlaylistKey) {
        musinController.playlistSongsPlaylist.clear();
        debugPrint("\n---------------------------");
        debugPrint("INITIL - PLAYLIST SONGLIST Playlistinte Akathulla Value");
        for (var element
            in musinController.userPlaylistSongsDbInstance!.values) {
          if (element.currespondingPlaylistId == widget.selectedPlaylistKey) {
            songsPaths.add(element.songPath!);
            debugPrint(element.songPath);
          }
        }
        musinController.alreadyPlayingPlaylistIndex =
            widget.selectedPlaylistKey!;
      }

      debugPrint("\n---------------------------");
    }
  }

  Future<void> changePlaylistMode() async {
    musinController.getPlaylistSongsPaths(songsPaths);
    musinController.test = widget.selectedPlaylistKey!;
    musinController.modeOfPlaylist = 3;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(),
      body: Stack(
        children: [
          ListView(
            shrinkWrap: true,
            children: [
              ValueListenableBuilder(
                  valueListenable:
                      musinController.userPlaylistNameDbInstance!.listenable(),
                  builder:
                      (context, Box<UserPlaylistNames> playlistNameFetcher, _) {
                    final songDatas =
                        playlistNameFetcher.get(widget.selectedPlaylistKey);
                    return SizedBox(
                      width: 180,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  Get.back();
                                },
                                icon: const Icon(
                                  Icons.chevron_left_outlined,
                                  size: 27,
                                ),
                              ),
                              commonText(text: songDatas?.playlistNames),
                            ],
                          ),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  musinController
                                      .isAddingSongsToExistingPlaylist = true;
                                  musinController
                                      .updatePlaylistAfterAddingSong = true;
                                  musinController.currentPlaylistName =
                                      songDatas!.playlistNames;
                                  musinController.currentPlaylistKey =
                                      widget.selectedPlaylistKey;
                                  musinController.totalPlaylistSongs =
                                      widget.totalNumberOfSongs;
                                  Get.to(const AddToPlaylistHolder());
                                },
                                icon: const Icon(Icons.add),
                                tooltip: "Add More",
                              ),
                              const SizedBox(
                                width: 20,
                              )
                            ],
                          )
                        ],
                      ),
                    );
                  }),
              const SizedBox(
                height: 20,
              ),
              playlistSongTileView(context),
            ],
          ),
          CommonMiniPlayer(),
        ],
      ),
    );
  }

  playlistSongTileView(BuildContext context) {
    List tempList = [];
    return ValueListenableBuilder(
        valueListenable:
            musinController.userPlaylistSongsDbInstance!.listenable(),
        builder: (context, Box<UserPlaylistSongs> songFetcher, _) {
          List<int> keys = songFetcher.keys
              .cast<int>()
              .where((key) =>
                  songFetcher.get(key)!.currespondingPlaylistId ==
                  widget.selectedPlaylistKey)
              .toList();
          widget.totalNumberOfSongs = keys.length;

          // debugPrint("\n---------------------------");
          // debugPrint("Length of SongsPath Before Adding is ${songsPaths.length}");
          // debugPrint("Length of FavsPath Before Adding is ${setSongDetails.playlistSongsPlaylist.length}");
          // debugPrint("\n---------------------------");

          if (musinController.playlistSongsPlaylist.isNotEmpty) {
            debugPrint("ENTERED INTO UPDATING FUNCTION 1");
            tempList.clear();
            for (var element
                in musinController.userPlaylistSongsDbInstance!.values) {
              if (element.currespondingPlaylistId ==
                  musinController.alreadyPlayingPlaylistIndex) {
                tempList.add(element.songPath);
              }
            }
            debugPrint("\n---------------------------");
            debugPrint("Value in TempList is ");
            for (var element in tempList) {
              debugPrint(element.toString());
            }
            debugPrint("\n---------------------------");

            if (tempList.length !=
                musinController.playlistSongsPlaylist.length) {
              debugPrint("ENTERED INTO UPDATING FUNCTION 2");
              musinController.playlistSongsPlaylist.clear();
              for (var i = 0; i < tempList.length; i++) {
                musinController.playlistSongsPlaylist
                    .add(Audio.file(tempList[i]));
                if (musinController.currentlyPlayingSongPath == tempList[i]) {
                  musinController.selectedSongKey = i;
                }
              }
              musinController.isPlaylistUpdatedAnyWay = true;
            }
          }

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
                return GestureDetector(
                  onTap: () async {
                    await changePlaylistMode();
                    musinController.isAudioPlayingFromPlaylist = true;
                    musinController.isSelectedOrNot = false;
                    musinController.selectedSongKey = index;
                    debugPrint("Selected Index in Playlist Song is $index");
                    debugPrint("Selected Key  in Playlist Song is $key");
                    musinController
                        .opnPlaylist(musinController.selectedSongKey);
                  },
                  child: ListTile(
                    leading: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: QueryArtworkWidget(
                          id: songDatas!.songImageId!,
                          type: ArtworkType.AUDIO,
                          nullArtworkWidget: ClipRRect(
                              child: Image.asset(
                                "assets/images/playlist_Bg/playlist16.jpg",
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
                    trailing: SizedBox(
                      width: 80,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: IconButton(
                              icon: const Icon(
                                CupertinoIcons.minus_circled,
                              ),
                              onPressed: () {
                                debugPrint("Delete Item Key is $key");
                                songFetcher.delete(key);
                                if (index == tempList.length - 1 ||
                                    tempList.length == index) {
                                  musinController.isSelectedOrNot = true;
                                  tempList.removeAt(index);
                                  musinController.stop();
                                  setState(() {});
                                } else {
                                  setState(() {
                                    tempList.removeAt(index);
                                  });
                                }
                                debugPrint("Delete Button Clicked");
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        });
  }
}
