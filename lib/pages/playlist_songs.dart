import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:musin/database/database.dart';
import 'package:musin/main.dart';
import 'package:musin/materials/colors.dart';
import 'package:musin/pages/addsongtoplaylist.dart';
import 'package:musin/pages/home.dart';
import 'package:musin/pages/songlist.dart';
import 'package:musin/pages/songplayingpage.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '/pages/widgets/widgets.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:fluttericon/font_awesome_icons.dart';

class PlaylistSongs extends StatefulWidget {
  int? selectedPlaylistKey;

  PlaylistSongs({this.selectedPlaylistKey});

  @override
  _PlaylistSongsState createState() => _PlaylistSongsState();
}

bool isSelected = true;

class _PlaylistSongsState extends State<PlaylistSongs> {
  Box<UserPlaylistSongs>? userPlaylistSongDbInstance;
  Box<UserPlaylistNames>? userPlaylistNameDbInstance;

  @override
  void initState() {
    userPlaylistNameDbInstance =
        Hive.box<UserPlaylistNames>(userPlaylistBoxName);
    userPlaylistSongDbInstance =
        Hive.box<UserPlaylistSongs>(userPlaylistSongBoxName);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppBar(context),
      body: Stack(
        children: [
          ListView(
            shrinkWrap: true,
            children: [
              ValueListenableBuilder(
                  valueListenable: userPlaylistNameDbInstance!.listenable(),
                  builder: (context, Box<UserPlaylistNames>playlistNameFetcher,
                      _) {
                    List<int> keys = userPlaylistSongDbInstance!.keys.cast<int>()
                        .where((key) =>
                    userPlaylistSongDbInstance!.get(key)!.currespondingPlaylistId ==
                        widget.selectedPlaylistKey)
                        .toList();
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
                              commonText(text: songDatas!.playlistNames),
                            ],
                          ),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                   Navigator.push(context, MaterialPageRoute(builder: (context)=>AddSongstoPlaylist(currentPlaylistName: songDatas.playlistNames,currentPlaylistKey: widget.selectedPlaylistKey,)));
                                },
                                icon: const Icon(Icons.add),
                                tooltip: "Add More",
                              ),
                              IconButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  userPlaylistSongDbInstance!.deleteAll(keys);
                                  playlistNameFetcher.delete(
                                      widget.selectedPlaylistKey);
                                },
                                icon: const Icon(Icons.delete),
                                tooltip: "Delete Playlist",
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
          CommonMiniPlayer(
            // isSelected: isSelected,
          ),
        ],
      ),
    );
  }

  playlistSongTileView(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: userPlaylistSongDbInstance!.listenable(),
      builder: (context, Box<UserPlaylistSongs> songFetcher, _) {
        List<int> keys = songFetcher.keys.cast<int>()
            .where((key) =>
        songFetcher.get(key)!.currespondingPlaylistId ==
            widget.selectedPlaylistKey)
            .toList();
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
                onTap: () {},
                child: ListTile(
                  leading: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: QueryArtworkWidget(
                        id: songDatas!.songImageId!,
                        type: ArtworkType.AUDIO,
                        nullArtworkWidget: ClipRRect(
                            child: Image.asset(
                              "assets/images/defaultImage.png",
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
    );
  }
}
