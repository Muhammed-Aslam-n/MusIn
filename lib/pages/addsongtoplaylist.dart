import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:musin/controller/musincontroller.dart';
import 'package:musin/database/database.dart';
import 'package:musin/materials/colors.dart';
import 'package:musin/pages/playlist_songs.dart';
import 'package:musin/pages/widgets/widgets.dart';
import 'package:on_audio_query/on_audio_query.dart';

List songLeftToAddToPlaylist = [];

class AddToPlaylistHolder extends StatelessWidget {
  const AddToPlaylistHolder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(),
      body: ListView(
        physics: const ScrollPhysics(),
        shrinkWrap: true,
        children: [
          AddToPlaylistHeader(),
          sizedh1,
          const AddSongstoPlaylist(),
        ],
      ),
    );
  }
}

class AddToPlaylistHeader extends StatelessWidget {
  AddToPlaylistHeader({Key? key}) : super(key: key);
  final musinController = Get.find<MusinController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 40, top: 20, bottom: 5),
          child: commonText(text: musinController.currentPlaylistName),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 5),
          child: commonText(
            text: "Add Songs to Playlist",
            color: HexColor("#ACB8C2"),
            weight: FontWeight.w400,
            size: 15,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Expanded(flex: 2, child: SizedBox()),
            Expanded(
              flex: 2,
              child: GetBuilder<MusinController>(
                builder: (musinController) => Visibility(
                  maintainState: true,
                  maintainAnimation: true,
                  visible: true,
                  child: musinController.selectedSongCount == 1
                      ? Text(
                          "${musinController.selectedSongCount} Song Selected",
                          style: TextStyle(color: HexColor("#A6B9FF")),
                        )
                      : Text(
                          "${musinController.selectedSongCount} Songs Selected",
                          style: TextStyle(color: HexColor("#A6B9FF")),
                        ),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (musinController.selectedSongCount >= 1) {
                  addFn();
                } else {
                  return;
                }
                musinController.isAddingSongsToExistingPlaylist = false;
              },
              child: const Text(
                "Add",
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                primary: HexColor("#A6B9FF"),
                fixedSize: const Size(30, 10),
              ),
            ),
            sizedw2,
          ],
        ),
      ],
    );
  }

  Future addFn() async {
    for (var i = 0; i < musinController.checkBoxList.length; i++) {
      debugPrint(musinController.checkBoxList[i].toString());
      if (musinController.checkBoxList[i] == true) {
        final songData =
            musinController.userSongsInstance!.get(songLeftToAddToPlaylist[i]);
        final model = UserPlaylistSongs(
            songName: songData?.songName,
            artistName: songData?.artistName,
            songDuration: songData?.duration,
            songImageId: songData?.imageId,
            currespondingPlaylistId: musinController.currentPlaylistKey,
            songPath: songData?.songPath);
        musinController.userPlaylistSongsDbInstance?.add(model);
      }
    }
    musinController.isAddingSongsToExistingPlaylist
        ? Get.back()
        : Get.off(
            PlaylistSongs(
              selectedPlaylistKey: musinController.currentPlaylistKey,
            ),
          );
    musinController.selectedSongCount = 0;
  }
}

class AddSongstoPlaylist extends StatefulWidget {
  const AddSongstoPlaylist({Key? key}) : super(key: key);

  @override
  _AddSongstoPlaylistState createState() => _AddSongstoPlaylistState();
}

class _AddSongstoPlaylistState extends State<AddSongstoPlaylist> {
  final musinController = Get.find<MusinController>();
  bool isAdded = false;

  createCheckBoxList() {
    var nKeys = musinController.userSongsInstance!.keys.cast<int>().toList();

    if (musinController.isAddingSongsToExistingPlaylist == true) {
      int balanceKeys =
          nKeys.length - musinController.totalPlaylistSongs!.toInt();
      musinController.generateSampleList(balanceKeys);
    } else {
      musinController.generateSampleList(nKeys.length);
    }
  }

  @override
  void initState() {
    createCheckBoxList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const ScrollPhysics(),
      shrinkWrap: true,
      children: [
        ValueListenableBuilder(
            valueListenable: musinController.userSongsInstance!.listenable(),
            builder: (context, Box<UserSongs> songFetcher, _) {
              List<int> keys = [];
              List<int> songDbList = [];
              keys = songFetcher.keys.cast<int>().toList();

              if (musinController.isAddingSongsToExistingPlaylist == true) {
                var pSongList = [];
                for (var element
                    in musinController.userPlaylistSongsDbInstance!.values) {
                  if (element.currespondingPlaylistId ==
                      musinController.currentPlaylistKey) {
                    pSongList.add(element.songName);
                  }
                }
                var uList = musinController.userSongsInstance!.values.toList();
                for (var i = 0;
                    i < musinController.userSongsInstance!.length;
                    i++) {
                  for (var j = 0; j < pSongList.length; j++) {
                    if (uList[i].songName == pSongList[j]) {
                      songDbList.add(i);
                    }
                  }
                }
                for (var i = 0; i < keys.length; i++) {
                  for (var j = 0; j < songDbList.length; j++) {
                    if (keys[i] == songDbList[j]) {
                      keys.remove(keys[i]);
                    }
                  }
                }
              }
              songLeftToAddToPlaylist = keys;

              // final pSongKey = userPlaylistSongsDbInstane!.keys.cast<int>().where((element) => userPlaylistSongsDbInstane!.get(element)!.currespondingPlaylistId == widget.currentPlaylistKey).toList();

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
                      final songData = songFetcher.get(key);

                      return ListTile(
                        leading: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: QueryArtworkWidget(
                              id: songData!.imageId!,
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
                              text: songData.songName,
                              size: 15,
                              weight: FontWeight.w600),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: commonMarquees(
                              text: songData.artistName,
                              size: 12.0,
                              color: HexColor("#ACB8C2"),
                              weight: FontWeight.w600,
                              hPadding: 0.0,
                              vPadding: 1.0),
                        ),
                        trailing: GetBuilder<MusinController>(
                          builder: (musinController) =>  Checkbox(
                            value: musinController.checkBoxList[index],
                            onChanged: (value) {
                              debugPrint("Before CheckBox value is $value");
                              musinController.updateCheck(value, index);
                              musinController.checkBoxList[index]
                                  ? musinController.selectedSongCount++
                                  : musinController.selectedSongCount--;
                            },
                            shape: const CircleBorder(),
                            activeColor: HexColor("#A6B9FF"),
                          ),
                        ),
                      );
                    },
                );
              }
            }),
      ],
    );
  }
}
