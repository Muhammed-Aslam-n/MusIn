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
    pInstance.favPlaylist.clear();
    debugPrint("\n---------------------------");
    debugPrint("Fav Playlistinte Akathulla Value");
      for (var element in userSongDbInstance!.values) {
        if (element.isFavourited == true) {
          songsPaths.add(element.songPath!);
          debugPrint(element.songName?.split(" ")[0]);
        }
      }
    debugPrint("\n---------------------------");
    pInstance.showKeys();
    debugPrint("Favourites Done");
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
                          setSongDetails.selectedSongKey = index;
                          setSongDetails.isSelectedOrNot = false;
                          debugPrint("\n---------------------");
                          debugPrint("Selected Song Key in Favourite is $index");
                          debugPrint("Curresponding  Song Key in Favourite is $key");
                          debugPrint("\n---------------------");
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
