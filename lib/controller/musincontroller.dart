import 'package:get/get.dart';
import 'dart:async';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:musin/constants/constants.dart';
import 'package:musin/database/database.dart';
import 'package:musin/materials/colors.dart';
import 'package:musin/pages/widgets/widgets.dart';

class MusinController extends GetxController {
  Box<UserSongs>? userSongsInstance;
  Box<UserPlaylistSongs>? userPlaylistSongsDbInstance;
  Box<UserPlaylistNames>? userPlaylistNameDbInstance;

  @override
  void onInit() {
    userSongsInstance = Hive.box<UserSongs>(userSongBoxName);
    userPlaylistNameDbInstance =
        Hive.box<UserPlaylistNames>(userPlaylistBoxName);
    userPlaylistSongsDbInstance =
        Hive.box<UserPlaylistSongs>(userPlaylistSongBoxName);
    super.onInit();
  }

  // TextEditingControllers
  final newPlaylistName = TextEditingController().obs();
  final formKey = GlobalKey<FormState>();

  TextEditingController searchController = TextEditingController().obs();
  String? searchSongName = ''.obs();

  onSearchChanged(TextEditingController searchQuery) {
    Timer? _debounce;
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      searchSongName = searchQuery.text;
      update(['searchBuilder']);
    });
  }

  @override
  void dispose() {
    newPlaylistName.dispose();
    searchController.dispose();
    super.dispose();
  }

  List<String> songsPathList = <String>[].obs();

  List<String> sampleKeys = <String>[].obs();

  Future<void> getAllSongsPaths(List<String> songPathList) async {
    for (var element in songPathList) {
      final audio = Audio.file(element);
      allSongsplayList.add(audio);
    }
  }

  Future<void> getFavSongsPaths(List<String> songPathList) async {
    for (var element in songPathList) {
      final audio = Audio.file(element);
      favPlaylist.add(audio);
    }
  }

  Future<void> getPlaylistSongsPaths(List<String> songPathList) async {
    for (var element in songPathList) {
      final audio = Audio.file(element);
      playlistSongsPlaylist.add(audio);
    }
  }

  showKeys() {
    selectModeOfPlaylist().forEach((element) {
      debugPrint(element.path);
    });
  }

  bool isSelectedOrNot = true.obs();
  int? currentSongKey = 0.obs();

  bool isNotificationOn = true.obs();
  bool turnNotificationOn = false.obs();

  disableNotification() {
    _assetsAudioPlayer.showNotification = false.obs();
  }

  enableNotification() {
    _assetsAudioPlayer.showNotification = true.obs();
  }

  // Variables to Store Playlist Details

  String? currentPlaylistName = ''.obs();
  int? currentPlaylistKey = -1.obs();
  int? totalPlaylistSongs = -1.obs();
  int selectedSongCount = 0.obs();

  //----------------------------

  String? currentSongDuration = ''.obs();
  int? selectedSongKey = 0.obs();
  bool isIconChanged = false.obs();
  bool isRepeat = false.obs();

  bool isAudioPlayingFromPlaylist = false.obs();
  bool isPlaylistSongAlreadyPlaying = false.obs();
  int alreadyPlayingPlaylistIndex = 0.obs();
  int test = 0.obs();

  // Deletion Handling Section
  String? currentlyPlayingSongPath = ''
      .obs(); // Important which Stores the Currently Opened Song from Playlist
  bool isPlaylistUpdatedAnyWay = false
      .obs(); // Important , this stores the bool value as if the playlists get update anyway
  // AddSongsToPlaylist

  List<bool> checkBoxList = <bool>[].obs();
  int selectedSongsCount = 0.obs();

  generateSampleList(length) {
    checkBoxList = List<bool>.filled(length, false);
    // update();
  }

  updateCheck(value,index){
    checkBoxList[index] = value;
    update();
  }

  bool isAddingSongsToExistingPlaylist = false.obs();
  bool updatePlaylistAfterAddingSong = false.obs();

  final _assetsAudioPlayer = AssetsAudioPlayer();

  List<Audio> allSongsplayList = <Audio>[].obs();
  List<Audio> favPlaylist = <Audio>[].obs();
  List<Audio> playlistSongsPlaylist = <Audio>[].obs();
  int modeOfPlaylist = 1.obs();
  int playlistLength = 0.obs();

  selectModeOfPlaylist() {
    if (modeOfPlaylist == 1) {
      return allSongsplayList;
    } else if (modeOfPlaylist == 2) {
      return favPlaylist;
    } else if (modeOfPlaylist == 3) {
      return playlistSongsPlaylist;
    }
    update();
  }

  opnPlaylist(selectedSongKey) async {
    listenEverything();
    change();
    try {
      await _assetsAudioPlayer.open(
          Playlist(
              audios: selectModeOfPlaylist(), startIndex: selectedSongKey ?? 0),
          autoStart: true,
          loopMode: LoopMode.playlist,
          showNotification: turnNotificationOn,
          notificationSettings: NotificationSettings(
            customPlayPauseAction: (handle) {
              playOrpause();
            },
            customNextAction: (handle) {
              next();
            },
            customPrevAction: (handle) {
              prev();
            },
            customStopAction: (handle) {
              _assetsAudioPlayer.stop();
            },
          ));
      update();
    } catch (e) {
      debugPrint("Can't Play Songs");
      update();
    }
  }

  listenEverything() {
    _assetsAudioPlayer.current.listen((event) {
      selectedSongKey = _assetsAudioPlayer.current.value?.index;
      currentlyPlayingSongPath =
          _assetsAudioPlayer.current.value?.audio.audio.path;
      debugPrint("Now Playing Song is $selectedSongKey");
    });
  }

  bool isShuffled = false.obs();

  shuffleSongs() {
    _assetsAudioPlayer.toggleShuffle();
    _assetsAudioPlayer.isShuffling.listen((event) {
      debugPrint(
          "Index inside iSShuffle is ${_assetsAudioPlayer.current.value!.index}");
    });
    if (_assetsAudioPlayer.isShuffling.value) {
      isShuffled = true;
      update();
    } else {
      isShuffled = false;
      update();
    }
    update();
  }

  next() {
    if (isPlaylistUpdatedAnyWay) {
      opnPlaylist(selectedSongKey! + 1);
      isPlaylistUpdatedAnyWay = false;
    } else {
      _assetsAudioPlayer.next();
    }
  }

  prev() {
    if (isPlaylistUpdatedAnyWay) {
      opnPlaylist(selectedSongKey! - 1);
      isPlaylistUpdatedAnyWay = false;
    } else {
      _assetsAudioPlayer.previous();
    }
  }

  change() {
    _assetsAudioPlayer.isPlaying.listen((event) {
      debugPrint(
          "Playing Or Not ${_assetsAudioPlayer.isPlaying.value.toString()}");
      if (_assetsAudioPlayer.isPlaying.value == true) {
        isIconChanged = true;
        update();
      } else {
        isIconChanged = false;
        update();
      }
      update();
    });
  }

  playOrpause() {
    _assetsAudioPlayer.playOrPause();
  }

  stop() {
    _assetsAudioPlayer.stop();
  }

  showFavPlaylist() {
    for (var element in favPlaylist) {
      debugPrint("Path : $element");
    }
  }

  removePathAt(index) {
    _assetsAudioPlayer.playlist?.remove(favPlaylist[index]);
    debugPrint(_assetsAudioPlayer.playlist?.audios.toString());
  }

  int? loopIcon = 0.obs();

  loopSongs() {
    _assetsAudioPlayer.toggleLoop();
    if (_assetsAudioPlayer.currentLoopMode!.index == 1) {
      loopIcon = 1;
    } else if (_assetsAudioPlayer.currentLoopMode!.index == 2) {
      loopIcon = 2;
    } else {
      loopIcon = 3;
    }
    update();
  }

  // ------------------------------Duration/Slider Area------------------
  dynamic currentPosition;

  Duration? dur = const Duration(seconds: 0);
  double? curr = 0;

  totalDuration() {
    _assetsAudioPlayer.current.listen((event) {
      dur = event!.audio.duration;
    });
    return commonText(
        text: dur.toString().split(".")[0],
        color: HexColor("#656F77"),
        weight: FontWeight.w400,
        size: 12);
  }

  getDuration() {
    return StreamBuilder(
        stream: _assetsAudioPlayer.currentPosition,
        builder: (context, asyncSnapshot) {
          if (!asyncSnapshot.hasData) {
            return commonText(
                text: 0.00,
                color: HexColor("#656F77"),
                weight: FontWeight.w400,
                size: 12);
          }
          currentPosition = asyncSnapshot.data;
          return commonText(
              text: currentPosition.toString().split(".")[0],
              color: HexColor("#656F77"),
              weight: FontWeight.w400,
              size: 12);
        },);
  }

  current() {
    curr = currentPosition!.inSeconds.toDouble();
    update();
  }

  giveProgressBar() {
    return StreamBuilder(
        stream: _assetsAudioPlayer.currentPosition,
        builder: (context, asyncSnapshot) {
          return Slider(
            activeColor: HexColor("#656F77"),
            inactiveColor: Colors.grey,
            min: 0.0,
            max: dur!.inSeconds.toDouble(),
            value: currentPosition?.inSeconds.toDouble() ?? 0,
            onChanged: (double value) {
              changeToSeconds(curr!.toInt());
              curr = value;
              update();
            },
          );
        });
  }

  Future<Widget> slider() async {
    return Slider(
      activeColor: HexColor("#656F77"),
      inactiveColor: Colors.grey,
      value: curr!.toDouble(),
      min: 0.0,
      max: dur!.inSeconds.toDouble(),
      onChanged: (double newValue) {
        changeToSeconds(curr!.toInt());
        curr = newValue;
        update();
      },
    );
  }

  Future<void> changeToSeconds(int seconds) async {
    Duration newDuration = Duration(seconds: seconds);
    _assetsAudioPlayer.seek(newDuration);
    update();
  }
}
