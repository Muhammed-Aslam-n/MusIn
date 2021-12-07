
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:musin/materials/colors.dart';
import 'package:musin/pages/widgets/widgets.dart';

class PlayerCurrespondingItems extends ChangeNotifier {

  List<String> songsPathList = [];

  List<String> sampleKeys =[];
  Future<void>getAllSongsPaths(List<String> songPathList)async{
    songPathList.forEach((element) {
      final audio = Audio.file(element);
      allSongsplayList.add(audio);
    });
  }
  Future<void>getFavSongsPaths(List<String> songPathList)async{
    songPathList.forEach((element)async {
      final audio = await Audio.file(element);
      favPlaylist.add(audio);
    });
  }
  bool didUserClickedANewPlaylst = false;

  Future<void>getPlaylistSongsPaths(List<String> songPathList)async{
    songPathList.forEach((element) async {
      final audio = await Audio.file(element);
      playlistSongsPlaylist.add(audio);
    });
  }
  showKeys(){
    selectModeOfPlaylist().forEach((element) {debugPrint(element.path);});
  }

  bool isSelectedOrNot = true;
  int? currentSongKey = 0;

  bool isNotificationOn=true;
  bool  turnNotificationOn = false;

 disableNotification(){
   _assetsAudioPlayer.showNotification = false;
 }
  enableNotification(){
    _assetsAudioPlayer.showNotification = true;
  }

  // Variables to Store Playlist Details


  String? currentPlaylistName;
  int? currentPlaylistKey;
  int? totalPlaylistSongs;
  int selectedSongCount = 0;

  //////////////////////////////////



  String? currentSongDuration;
  int? selectedSongKey;
  bool isIconChanged = false;
  bool isRepeat = false;


  bool isAudioPlayingFromPlaylist = false;
  bool isPlaylistSongAlreadyPlaying = false;
  int alreadyPlayingPlaylistIndex = 0;
  int test =0;






  var searchSongName;
  onSearchChanged(TextEditingController searchQuery){
    Timer? _debounce;
    if(_debounce?.isActive??false) _debounce?.cancel();
      _debounce = Timer(const Duration(milliseconds: 500),()
    {
      searchSongName = searchQuery.text;
      notifyListeners();
    });
  }


  // AddSongsToPlaylist

  List<bool> checkBoxList = [];
  int selectedSongsCount = 0;

  generateSampleList(length){
    checkBoxList = List<bool>.filled(length, false);
  }

  bool isAddingSongsToExistingPlaylist  = false;
  bool updatePlaylistAfterAddingSong = false;
  bool updateFavouitesAfterAddingSong = false;
  int? previousPlaylistLength;
  int? previousFavouriteLength;
  int? previousFavouriteSongPosition;






  final _assetsAudioPlayer = AssetsAudioPlayer();
  List<Audio> allSongsplayList = <Audio>[];
  List<Audio> favPlaylist = <Audio>[];
  List<Audio> playlistSongsPlaylist = <Audio>[];
  int modeOfPlaylist = 1;
  int playlistLength = 0;
  selectModeOfPlaylist(){
    if(modeOfPlaylist == 1){
      return allSongsplayList;
    }else if(modeOfPlaylist == 2){
      return favPlaylist;
    }else if(modeOfPlaylist == 3){
      return playlistSongsPlaylist;
    }
  }

 opnPlaylist(selectedSongKey) async{
   listenEverything();
   change();
    try{
      await _assetsAudioPlayer.open(
       Playlist(audios: selectModeOfPlaylist(),startIndex: selectedSongKey??0),autoStart: true,loopMode: LoopMode.playlist,showNotification: turnNotificationOn,
        notificationSettings: NotificationSettings(
          customPlayPauseAction: (handle){
             playOrpause();
          },
          customNextAction: (handle){
            next();
          },
          customPrevAction: (handle){
            prev();
          },
          customStopAction: (handle){
            _assetsAudioPlayer.stop();
          },

        )
     );
     notifyListeners();
    }catch(e){
      debugPrint("Can't Play Songs");
      notifyListeners();

    }
    notifyListeners();
  }
  listenEverything(){
   _assetsAudioPlayer.current.listen((event) {
     selectedSongKey = _assetsAudioPlayer.current.value?.index;
     // debugPrint("\n-----------------");
     debugPrint("Now Playing Song is $selectedSongKey");
     // debugPrint("Now Playing Song Name : ${_assetsAudioPlayer.getCurrentAudioTitle}");
     // debugPrint("\n-----------------");
   });

  }

  bool isShuffled=false;
  shuffleSongs(){
    _assetsAudioPlayer.toggleShuffle();
    _assetsAudioPlayer.isShuffling.listen((event) {
      debugPrint("Index inside iSShuffle is ${_assetsAudioPlayer.current.value!.index}");
    });
    if(_assetsAudioPlayer.isShuffling.value){
      isShuffled = true;
      notifyListeners();
    }else{
      isShuffled = false;
      notifyListeners();
    }
  }
  next(){
   _assetsAudioPlayer.next();
  }
  prev(){
   _assetsAudioPlayer.previous();
  }

  change(){
    _assetsAudioPlayer.isPlaying.listen((event) {
      debugPrint("Playing Or Not ${_assetsAudioPlayer.isPlaying.value.toString()}");
      if(_assetsAudioPlayer.isPlaying.value == true){
        isIconChanged = true;
        notifyListeners();
      }else{
        isIconChanged = false;
        notifyListeners();
      }
      notifyListeners();
    });
  }
  playOrpause(){
    _assetsAudioPlayer.playOrPause();
  }

  stop(){
    _assetsAudioPlayer.stop();
  }

  showFavPlaylist(){
    favPlaylist.forEach((element) {
      debugPrint("Path : $element");
    });
  }

  removePathAt(index){
    _assetsAudioPlayer.playlist?.remove(favPlaylist[index]);
    debugPrint(_assetsAudioPlayer.playlist?.audios.toString());
  }

  int? loopIcon=0;
  loopSongs(){
   _assetsAudioPlayer.toggleLoop();
    if(_assetsAudioPlayer.currentLoopMode!.index == 1){
      loopIcon = 1;
    }else if(_assetsAudioPlayer.currentLoopMode!.index == 2){
      loopIcon = 2;
    }else{
      loopIcon = 3;
    }
    notifyListeners();
  }

  // ------------------------------Duration/Slider Area------------------
  var currentPosition ;
  Duration? dur = const Duration(seconds: 0);
  double? curr = 0;

  totalDuration()  {
    _assetsAudioPlayer.current.listen((event)   {
      dur = event!.audio.duration;
    });
    return commonText(
        text: dur.toString().split(".")[0],
        color: HexColor("#656F77"),
        weight: FontWeight.w400,
        size: 12);
  }
  getDuration()  {
    return StreamBuilder(
        stream: _assetsAudioPlayer.currentPosition,
        builder: (context, asyncSnapshot) {
          if(!asyncSnapshot.hasData) {
            return commonText(
                text: 0.00,
                color: HexColor("#656F77"),
                weight: FontWeight.w400,
                size: 12);
          }
          currentPosition = asyncSnapshot.data;
          return
            commonText(
              text: currentPosition.toString().split(".")[0],
              color: HexColor("#656F77"),
              weight: FontWeight.w400,
              size: 12);
        });
  }
  current() {
    curr = currentPosition!.inSeconds.toDouble();
    notifyListeners();
  }
  giveProgressBar()  {
    return StreamBuilder(
      stream: _assetsAudioPlayer.currentPosition,
        builder: (context,asyncSnapshot){
        return Slider(
          activeColor: HexColor("#656F77"),
          inactiveColor: Colors.grey,
          min: 0.0,
          max: dur!.inSeconds.toDouble(),
          value: currentPosition?.inSeconds.toDouble()??0,
          onChanged: (double value) {
            changeToSeconds(curr!.toInt());
            curr = value;
            notifyListeners();
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
        notifyListeners();
      },
    );
  }
  Future<void> changeToSeconds(int seconds) async {
    Duration newDuration = Duration(seconds: seconds);
    _assetsAudioPlayer.seek(newDuration);
    notifyListeners();
  }


}
