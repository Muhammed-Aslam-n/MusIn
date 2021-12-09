import 'package:assets_audio_player/assets_audio_player.dart';
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
    getSongPathsMan();
    debugPrint("Inited");
    super.initState();
  }

  Future<void>getSongPathsMan()async{
    final pInstance =  Provider.of<PlayerCurrespondingItems>(context, listen: false);
    if(pInstance.playlistSongsPlaylist.isEmpty){
      debugPrint("\n---------------------------");
      debugPrint("INITIL - Playlistinte Akathulla Value");
      for (var element in userPlaylistSongDbInstance!.values) {
       if(widget.selectedPlaylistKey == element.currespondingPlaylistId){
         songsPaths.add(element.songPath??'');
         pInstance.alreadyPlayingPlaylistIndex = element.currespondingPlaylistId!;
       }
      }
      debugPrint("\n---------------------------");
    }else{
         if(pInstance.alreadyPlayingPlaylistIndex != widget.selectedPlaylistKey ){
           pInstance.playlistSongsPlaylist.clear();
           debugPrint("\n---------------------------");
           debugPrint("INITIL - PLAYLIST SONGLIST Playlistinte Akathulla Value");
           for (var element in userPlaylistSongDbInstance!.values) {
             if(element.currespondingPlaylistId == widget.selectedPlaylistKey){
               songsPaths.add(element.songPath!);
               debugPrint(element.songPath);
             }
           }
           pInstance.alreadyPlayingPlaylistIndex = widget.selectedPlaylistKey!;
         }

         debugPrint("\n---------------------------");
    }
  }

  Future<void>changePlaylistMode() async{
    final pInstance = Provider.of<PlayerCurrespondingItems>(context,listen: false);
    pInstance.getPlaylistSongsPaths(songsPaths);
    pInstance.test = widget.selectedPlaylistKey!;
    pInstance.modeOfPlaylist = 3;
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
    List tempList = [];
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


          // debugPrint("\n---------------------------");
          // debugPrint("Length of SongsPath Before Adding is ${songsPaths.length}");
          // debugPrint("Length of FavsPath Before Adding is ${setSongDetails.playlistSongsPlaylist.length}");
          // debugPrint("\n---------------------------");

          if(setSongDetails.playlistSongsPlaylist.isNotEmpty){
            debugPrint("ENTERED INTO UPDATING FUNCTION 1");
            tempList.clear();
            for (var element in userPlaylistSongDbInstance!.values) {
              if(element.currespondingPlaylistId == setSongDetails.alreadyPlayingPlaylistIndex){
                tempList.add(element.songPath);
              }
            }
            debugPrint("\n---------------------------");
            debugPrint("Value in TempList is ");
            for (var element in tempList) {
              debugPrint(element.toString());
            }
            debugPrint("\n---------------------------");

            if(tempList.length != setSongDetails.playlistSongsPlaylist.length ){
              debugPrint("ENTERED INTO UPDATING FUNCTION 2");
              setSongDetails.playlistSongsPlaylist.clear();
              for(var i = 0; i<tempList.length;i++){
                setSongDetails.playlistSongsPlaylist.add(Audio.file(tempList[i]));
                if(setSongDetails.currentlyPlayingSongPath == tempList[i]){
                  setSongDetails.selectedSongKey = i;
                }
              }
              setSongDetails.isPlaylistUpdatedAnyWay = true;
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
                                if(index == tempList.length - 1 || tempList.length == index){
                                  setSongDetails.isSelectedOrNot = true;
                                  tempList.removeAt(index);
                                  setSongDetails.stop();
                                  setState(() {

                                  });
                                }else{
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
        },
      ),
    );
  }
}
