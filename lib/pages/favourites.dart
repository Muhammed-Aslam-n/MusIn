import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:musin/database/database.dart';
import 'package:musin/materials/colors.dart';
import 'package:musin/pages/widgets/commonminiplayer.dart';
import 'package:musin/pages/widgets/widgets.dart';
import 'package:musin/provider/provider_class.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

import '../main.dart';

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
  Box<UserSongs>? userSongDbInstance;
  List<String> songsPaths =[];
  @override
  void initState() {
    userSongDbInstance = Hive.box<UserSongs>(songDetailListBoxName);
    getSongPathsMan();
    super.initState();
  }

  getSongPathsMan(){
    final pInstance = Provider.of<PlayerCurrespondingItems>(context, listen: false);
    // pInstance.favPlaylist.clear();
    // debugPrint("\n---------------------------");
    // debugPrint("INITIL - FAV SONGLIST Playlistinte Akathulla Value");
      for (var element in userSongDbInstance!.values) {
        if (element.isFavourited == true) {
          songsPaths.add(element.songPath!);
          // debugPrint(element.songName?.split(" ")[0]);
        }
      }
    // debugPrint("\n---------------------------");
    pInstance.showKeys();
    // debugPrint("Favourites Done");
  }
  changeModeOfPlay(){
    final pInstance = Provider.of<PlayerCurrespondingItems>(context, listen: false);
    pInstance.getFavSongsPaths(songsPaths);
    pInstance.modeOfPlaylist = 2;
  }


  @override
  Widget build(BuildContext context) {
    return Consumer<PlayerCurrespondingItems>(
      builder: (_, setSongDetails, child) => ValueListenableBuilder(
        valueListenable: userSongDbInstance!.listenable(),
        builder: (context, Box<UserSongs> songFetcher, _) {
          List<int> keys = songFetcher.keys.cast<int>().where((key) => songFetcher.get(key)!.isFavourited == true).toList();


          // debugPrint("\n---------------------------");
          // debugPrint("Length of SongsPath Before Adding is ${songsPaths.length}");
          // debugPrint("Length of FavsPath Before Adding is ${setSongDetails.favPlaylist.length}");
          // debugPrint("\n---------------------------");
          if(setSongDetails.favPlaylist.isNotEmpty){
            // debugPrint("ENTERED INTO UPDATING FUNCTION 1");
            if(songsPaths.length != setSongDetails.favPlaylist.length ){
              // debugPrint("ENTERED INTO UPDATING FUNCTION 2");
              songsPaths.clear();
              for (var element in userSongDbInstance!.values) {
                if (element.isFavourited == true) {
                  // debugPrint("Veendum Updating SOngsPaths");
                  songsPaths.add(element.songPath!);
                  debugPrint(element.songName?.split(" ")[0]);
                }
              }

              // debugPrint("CURRENTLY PLAYING SONG PATH IS "+setSongDetails.currentlyPlayingSongPath.toString());
              setSongDetails.favPlaylist.clear();
              for(var i = 0; i<songsPaths.length;i++){
                setSongDetails.favPlaylist.add(Audio.file(songsPaths[i]));
                if(setSongDetails.currentlyPlayingSongPath == songsPaths[i]){
                  // debugPrint("NEW INDEX IS $i");
                  setSongDetails.selectedSongKey = i;
                }
              }
              setSongDetails.isPlaylistUpdatedAnyWay = true;
            }
            // debugPrint("\n---------------------------");
            // debugPrint("UPDATIL - FAV SONGSPATHS Playlistinte Akathulla Value");
            for (var element in songsPaths) {
              debugPrint(element.toString());
            }
            // debugPrint("\n---------------------------");
            // debugPrint("UPDATIL - FAV PLAYLIST Playlistinte Akathulla Value");
             for (var element in setSongDetails.favPlaylist) {
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
            return Column(
                children: [
                  ListView.builder(
                    itemCount: keys.length,
                    shrinkWrap: true,
                    physics: const ScrollPhysics(),
                    itemBuilder: (context, index) {
                      final key = keys[index];
                      final songDatas = songFetcher.get(key);
                      return GestureDetector(
                        onTap: () async{
                          setSongDetails.isAudioPlayingFromPlaylist = false;
                          changeModeOfPlay();
                          setSongDetails.isSelectedOrNot = false;
                          setSongDetails.selectedSongKey = index;
                          setSongDetails.opnPlaylist(setSongDetails.selectedSongKey);
                        },
                        child: ListTile(
                          leading: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: QueryArtworkWidget(
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
                                      Icons.remove_circle_outline,
                                    ),
                                    onPressed: () {
                                      final model = UserSongs(songName: songDatas.songName,artistName: songDatas.artistName,songPath: songDatas.songPath,isFavourited: false,isAddedtoPlaylist: false,imageId: songDatas.imageId,duration: songDatas.duration);
                                      songFetcher.put(key, model);
                                      debugPrint("INDEX IS $index");
                                      if(index == songsPaths.length - 1 || songsPaths.length == index){
                                        setSongDetails.isSelectedOrNot = true;
                                        songsPaths.removeAt(index);
                                        setSongDetails.stop();
                                        setState(() {

                                        });
                                      }else{
                                        songsPaths.removeAt(index);
                                        setState(() {

                                        });
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 70,
                  )
                ]
            );
          }
        },
      ),
    );
  }
}
