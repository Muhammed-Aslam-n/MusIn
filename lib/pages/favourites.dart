import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:musin/controller/musincontroller.dart';
import 'package:musin/database/database.dart';
import 'package:musin/materials/colors.dart';
import 'package:musin/pages/widgets/commonminiplayer.dart';
import 'package:musin/pages/widgets/widgets.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:get/get.dart';

class Favourites extends StatelessWidget {
  const Favourites({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(),
      body: Stack(
        children: [
          ListView(
            children: const [
              CommonHeaders(
                title: "Favourites",
                subtitle: "Hear the Best",
              ),
              SizedBox(
                height: 20,
              ),
              FavouriteSongList(),
            ],
          ),
          const CommonMiniPlayer(),
        ],
      ),
    );
  }
}

class FavouriteSongList extends StatefulWidget {
  const FavouriteSongList({Key? key}) : super(key: key);

  @override
  _FavouriteSongListState createState() => _FavouriteSongListState();
}

class _FavouriteSongListState extends State<FavouriteSongList> {

  final musinController = Get.find<MusinController>();
  List<String> songsPaths = [];

  @override
  void initState() {
    getSongPathsMan();
    super.initState();
  }

  getSongPathsMan() {

    // pInstance.favPlaylist.clear();
    // debugPrint("\n---------------------------");
    // debugPrint("INITIL - FAV SONGLIST Playlistinte Akathulla Value");
    for (var element in musinController.userSongsInstance!.values) {
      if (element.isFavourited == true) {
        songsPaths.add(element.songPath!);
        // debugPrint(element.songName?.split(" ")[0]);
      }
    }
    // debugPrint("\n---------------------------");
    musinController.showKeys();
    // debugPrint("Favourites Done");
  }

  changeModeOfPlay() {
    musinController.getFavSongsPaths(songsPaths);
    musinController.modeOfPlaylist = 2;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: musinController.userSongsInstance!.listenable(),
        builder: (context, Box<UserSongs> songFetcher, _) {
          List<int> keys = songFetcher.keys
              .cast<int>()
              .where((key) => songFetcher.get(key)!.isFavourited == true)
              .toList();

          // debugPrint("\n---------------------------");
          // debugPrint("Length of SongsPath Before Adding is ${songsPaths.length}");
          // debugPrint("Length of FavsPath Before Adding is ${setSongDetails.favPlaylist.length}");
          // debugPrint("\n---------------------------");
          if (musinController.favPlaylist.isNotEmpty) {
            // debugPrint("ENTERED INTO UPDATING FUNCTION 1");
            if (songsPaths.length != musinController.favPlaylist.length) {
              // debugPrint("ENTERED INTO UPDATING FUNCTION 2");
              songsPaths.clear();
              for (var element in musinController.userSongsInstance!.values) {
                if (element.isFavourited == true) {
                  // debugPrint("Veendum Updating SOngsPaths");
                  songsPaths.add(element.songPath!);
                  debugPrint(element.songName?.split(" ")[0]);
                }
              }

              // debugPrint("CURRENTLY PLAYING SONG PATH IS "+setSongDetails.currentlyPlayingSongPath.toString());
              musinController.favPlaylist.clear();
              for (var i = 0; i < songsPaths.length; i++) {
                musinController.favPlaylist.add(Audio.file(songsPaths[i]));
                if (musinController.currentlyPlayingSongPath == songsPaths[i]) {
                  // debugPrint("NEW INDEX IS $i");
                  musinController.selectedSongKey = i;
                }
              }
              musinController.isPlaylistUpdatedAnyWay = true;
            }
            // debugPrint("\n---------------------------");
            // debugPrint("UPDATIL - FAV SONGSPATHS Playlistinte Akathulla Value");
            for (var element in songsPaths) {
              debugPrint(element.toString());
            }
            // debugPrint("\n---------------------------");
            // debugPrint("UPDATIL - FAV PLAYLIST Playlistinte Akathulla Value");
            for (var element in musinController.favPlaylist) {
              debugPrint(element.path.split(" ")[0].toString());
            }
          }
          // debugPrint("\n---------------------------");
          if (songFetcher.isEmpty) {
            return Column(
              children: const [
                Text("No Songs So Far..."),
              ],
            );
          } else {
            return Column(children: [
              ListView.builder(
                itemCount: keys.length,
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                itemBuilder: (context, index) {
                  final key = keys[index];
                  final songDatas = songFetcher.get(key);
                  return GestureDetector(
                    onTap: () async {
                      musinController.isAudioPlayingFromPlaylist = false;
                      changeModeOfPlay();
                      musinController.isSelectedOrNot = false;
                      musinController.selectedSongKey = index;
                      musinController
                          .opnPlaylist(musinController.selectedSongKey);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: ListTile(
                        leading: QueryArtworkWidget(
                            id: songDatas!.imageId!,
                            type: ArtworkType.AUDIO,
                            nullArtworkWidget: ClipRRect(
                                child: Image.asset(
                                  "assets/images/playlist_Bg/playlist16.jpg",
                                  height: 50,
                                  width: 50,
                                  fit: BoxFit.fill,
                                ),
                                borderRadius: BorderRadius.circular(10)),
                            artworkHeight: 80,
                            artworkWidth: 50,
                            artworkFit: BoxFit.fill,
                            artworkBorder: BorderRadius.circular(10)),
                        title: Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: commonMarquees(
                              text: songDatas.songName,
                              size: 13.0,
                              color: Colors.black,
                              weight: FontWeight.w600,
                              hPadding: 0.0,
                              vPadding: 1.0,
                              height: 25.0),
                        ),
                        subtitle: commonMarquees(
                            text: songDatas.artistName,
                            size: 12.0,
                            color: HexColor("#ACB8C2"),
                            weight: FontWeight.w600,
                            hPadding: 0.0,
                            vPadding: 1.0),
                        trailing: SizedBox(
                          width: 80,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.remove_circle_outline,
                                  ),
                                  onPressed: () {
                                    final model = UserSongs(
                                        songName: songDatas.songName,
                                        artistName: songDatas.artistName,
                                        songPath: songDatas.songPath,
                                        isFavourited: false,
                                        isAddedtoPlaylist: false,
                                        imageId: songDatas.imageId,
                                        duration: songDatas.duration);
                                    songFetcher.put(key, model);
                                    debugPrint("INDEX IS $index");
                                    if (index == songsPaths.length - 1 ||
                                        songsPaths.length == index) {
                                      musinController.isSelectedOrNot = true;
                                      songsPaths.removeAt(index);
                                      musinController.stop();
                                      setState(() {});
                                    } else {
                                      songsPaths.removeAt(index);
                                      setState(() {});
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(
                height: 70,
              )
            ]);
          }
        },
      );
  }
}
