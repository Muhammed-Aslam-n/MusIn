import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:musin/database/database.dart';
import 'package:musin/main.dart';
import 'package:musin/materials/colors.dart';
import 'package:musin/pages/addsongtoplaylist.dart';
import 'package:musin/pages/widgets/commonminiplayer.dart';
import 'package:musin/provider/provider_class.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import '/pages/widgets/widgets.dart';

class PlaylistSongs extends StatefulWidget {
  int? selectedPlaylistKey;
  int totalNumberOfSongs = 0;

  PlaylistSongs({this.selectedPlaylistKey});

  @override
  _PlaylistSongsState createState() => _PlaylistSongsState();
}


class _PlaylistSongsState extends State<PlaylistSongs> {
  Box<UserPlaylistSongs>? userPlaylistSongDbInstance;
  Box<UserPlaylistNames>? userPlaylistNameDbInstance;
  List<String> songsPaths =[];
  @override
  void initState() {
    userPlaylistNameDbInstance =
        Hive.box<UserPlaylistNames>(userPlaylistBoxName);
    userPlaylistSongDbInstance =
        Hive.box<UserPlaylistSongs>(userPlaylistSongBoxName);
    final pInstance = Provider.of<PlayerCurrespondingItems>(context,listen: false);
    getSongPathsMan();
    pInstance.showKeys();
    super.initState();
  }

  Future<void>getSongPathsMan()async{
    final pInstance =  Provider.of<PlayerCurrespondingItems>(context, listen: false);
    var data = await userPlaylistNameDbInstance!.get(widget.selectedPlaylistKey);
    debugPrint(data!.playlistNames.toString().toUpperCase());
    if(pInstance.playlistSongsPlaylist.isEmpty){
      for (var element in userPlaylistSongDbInstance!.values) {
       if(widget.selectedPlaylistKey == element.currespondingPlaylistId){
         debugPrint("Path is ${element.songName}");
         songsPaths.add(element.songPath??'');
         pInstance.alreadyPlayingPlaylistIndex = element.currespondingPlaylistId!;
       }
      }
      pInstance.previousPlaylistLength = songsPaths.length;
    }else{
         if(pInstance.alreadyPlayingPlaylistIndex != widget.selectedPlaylistKey ){
           pInstance.playlistSongsPlaylist.clear();
           for (var element in userPlaylistSongDbInstance!.values) {
             if(element.currespondingPlaylistId == widget.selectedPlaylistKey){
               songsPaths.add(element.songPath!);
               debugPrint(element.songPath);
             }
           }
           pInstance.alreadyPlayingPlaylistIndex = widget.selectedPlaylistKey!;
         }
         pInstance.previousPlaylistLength = songsPaths.length;
    }
  }

  Future<void>changePlaylistMode() async{
    final pInstance = Provider.of<PlayerCurrespondingItems>(context,listen: false);
    pInstance.getPlaylistSongsPaths(songsPaths);
    pInstance.test = widget.selectedPlaylistKey!;
    pInstance.modeOfPlaylist = 3;
    // debugPrint("\n---------------------------------");
    // debugPrint("The Song Paths if List is  Empty ");
    // pInstance.showKeys();
    // debugPrint("\n---------------------------------");
  }
  // getSongPathsMan(){
  //   final pInstance = Provider.of<PlayerCurrespondingItems>(context, listen: false);
  //   userPlaylistSongDbInstance!.values.forEach((element) {
  //     if(!pInstance.didUserClickedANewPlaylst){
  //       if(element.currespondingPlaylistId == widget.selectedPlaylistKey){
  //         songsPaths.add(element.songPath!);
  //       }
  //     }else{
  //       pInstance.playlistSongsPlaylist.clear();
  //       if(element.currespondingPlaylistId == widget.selectedPlaylistKey){
  //         songsPaths.add(element.songPath!);
  //       }
  //     }
  //
  //   });
  //   pInstance.getPlaylistSongsPaths(songsPaths);
  //   pInstance.modeOfPlaylist = 3;
  //   pInstance.showKeys();
  // }


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
                  valueListenable: userPlaylistNameDbInstance!.listenable(),
                  builder: (context, Box<UserPlaylistNames>playlistNameFetcher,
                      _) {
                    final songDatas = playlistNameFetcher.get(
                        widget.selectedPlaylistKey);
                    return SizedBox(
                      width: 180,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                icon: const Icon(
                                  Icons.chevron_left_outlined, size: 27,),),
                              commonText(text: songDatas?.playlistNames),
                            ],
                          ),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  var pInstance = Provider.of<PlayerCurrespondingItems>(context,listen: false);
                                  pInstance.isAddingSongsToExistingPlaylist = true;
                                  pInstance.updatePlaylistAfterAddingSong = true;
                                  pInstance.currentPlaylistName = songDatas!.playlistNames;
                                  pInstance.currentPlaylistKey = widget.selectedPlaylistKey;
                                  pInstance.totalPlaylistSongs = widget.totalNumberOfSongs;
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>const AddToPlaylistHolder()));
                                },
                                icon: const Icon(Icons.add),
                                tooltip: "Add More",
                              ),
                              // IconButton(
                              //   onPressed: () {
                              //     Navigator.of(context).pop();
                              //     userPlaylistSongDbInstance!.deleteAll(keys);
                              //     playlistNameFetcher.delete(
                              //         widget.selectedPlaylistKey);
                              //     var pInstance = Provider.of<PlayerCurrespondingItems>(context,listen: false);
                              //     pInstance.isSelectedOrNot = true;
                              //   },
                              //   icon: const Icon(Icons.delete),
                              //   tooltip: "Delete Playlist",
                              // )
                              const SizedBox(
                                width: 20,
                              )
                            ],
                          )
                        ],
                      ),
                    );
                  }
              ),
              const SizedBox(
                height: 20,
              ),
              playlistSongTileView(context),
            ],
          ),
          const CommonMiniPlayer(),
        ],
      ),
    );
  }

  playlistSongTileView(BuildContext context) {
    return Consumer<PlayerCurrespondingItems>(
        builder: (_, setSongDetails, child) =>ValueListenableBuilder(
        valueListenable: userPlaylistSongDbInstance!.listenable(),
        builder: (context, Box<UserPlaylistSongs> songFetcher, _) {
          List<int> keys = songFetcher.keys.cast<int>()
              .where((key) =>
          songFetcher.get(key)!.currespondingPlaylistId ==
              widget.selectedPlaylistKey)
              .toList();
          widget.totalNumberOfSongs = keys.length;
         // if(setSongDetails.updatePlaylistAfterAddingSong){
         //   if(setSongDetails.playlistSongsPlaylist.length != setSongDetails.previousPlaylistLength){
         //     getSongPathsMan();
         //     setSongDetails.previousPlaylistLength = setSongDetails.playlistSongsPlaylist.length;
         //   }
         //   setSongDetails.updatePlaylistAfterAddingSong = false;
         //
         // }


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
                  onTap: () async{
                    await changePlaylistMode();
                    setSongDetails.isAudioPlayingFromPlaylist = true;
                    setSongDetails.isSelectedOrNot = false;
                    setSongDetails.selectedSongKey = index;
                    debugPrint("Selected Index in Playlist Song is $index");
                    debugPrint("Selected Key  in Playlist Song is $key");
                    setSongDetails.opnPlaylist(setSongDetails.selectedSongKey);
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
        },
      ),
    );
  }
}
