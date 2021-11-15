// import 'package:flutter/material.dart';
//
// class IconChanger with ChangeNotifier{
//   bool isIconChanged = true;
//   bool get isIconChangedgetter => isIconChanged;
//   void changeIcon(){
//     isIconChanged? isIconChanged=false:isIconChanged=true;
//     notifyListeners();
//   }
// }


import 'package:flutter/cupertino.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:musin/materials/colors.dart';
import 'package:musin/pages/widgets/widgets.dart';
import 'package:on_audio_query/on_audio_query.dart';

class PlayerCurrespondingItems extends ChangeNotifier {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  final player = AssetsAudioPlayer();


  showFavouriteSnackBar(BuildContext context) {
    final snack = SnackBar(
      content: commonText(text: "Removed from Favourites",
          color: Colors.red,
          size: 13,
          weight: FontWeight.w500,
          isCenter: true),
      duration: Duration(seconds: 1),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24),),
      backgroundColor: Colors.white,
      width: 250,
    );
    return ScaffoldMessenger.of(context).showSnackBar(snack);
  }




  List SongDetailsList = [];

  var isSelectedOrNot = true;
  var isIconChanged = false;
  var isNotificationOn = true;
  bool isRepeat = false;
  var songName, artistName, path, image, type,duration;

  bool get isIconSelectedgetter => isSelectedOrNot;

  getSongDetails(
      {nameOfSong, nameOfArtist, songPath, artistImage, artistType,totalDuration}) {
    songName = nameOfSong;
    artistName = nameOfArtist;
    path = songPath;
    image = artistImage;
    type = artistType;
    duration = totalDuration;
    notifyListeners();
  }
  void changeIcon() {
    finishedOrNot();
    isIconChanged ? isIconChanged = false : isIconChanged = true;
    if(isIconChanged){
      playSong(path);
      getDuration();
      totalDuration();
    }else{
      pauseSong();
    }
    notifyListeners();
  }
  playSong(link) async {
    try {
      await player.open(
        Audio(link),
        showNotification: isNotificationOn,notificationSettings: NotificationSettings(
        customPlayPauseAction: (player){
          changeIcon();
        }
      )
      );
    } catch (t) {
      //mp3 unreachable
      debugPrint("Cannot Play Song");
      // showFavouriteSnackBar(context);
    }
  }
  pauseSong()async{
    await player.pause();
    isRepeat = false;   // to Disable the Looping when user clicks the Button
  }


//------------------------Finished Or Not -------------

  finishedOrNot(){
      player.playlistAudioFinished.listen((event) {
        debugPrint("Current Loop Mode is ${player.currentLoopMode!.index}");
        if(player.currentLoopMode!.index == 0){
        isIconChanged = false;
        debugPrint("Entered inside loop ${player.currentLoopMode}");
        notifyListeners();
      }else if(player.currentLoopMode!.index == 1){
          isIconChanged = true;
          notifyListeners();
        }
    });
    notifyListeners();
  }

  //----------------------------------------Loop Songs Area-----------------
  loopSongs(){
    if(isRepeat == false && isIconChanged == true){
      player.setLoopMode(LoopMode.single);
      isRepeat = true;
      debugPrint("False : Loop Mode in If ${player.currentLoopMode}");
      notifyListeners();
    }
    else if(isRepeat == true){
      player.setLoopMode(LoopMode.none);
      isRepeat = false;

      debugPrint(" True: Loop Mode in Else ${player.currentLoopMode}");
      notifyListeners();
    }
  }


  // ------------------------------Duration/Slider Area------------------
  Duration? currentPosition = Duration(seconds: 0);
  Duration? dur=Duration(seconds: 0);
  double curr=0;

  totalDuration(){
    player.current.listen((event) {
      dur = event!.audio.duration;
    });
    return commonText(
        text: dur.toString().split(".")[0],
        color: HexColor("#656F77"),
        weight: FontWeight.w400,
        size: 12);
  }
  getDuration(){
    return StreamBuilder(
        stream: player.currentPosition,
        builder: (context, asyncSnapshot) {
          currentPosition = asyncSnapshot.data as Duration;
          return commonText(
              text: currentPosition.toString().split(".")[0],
              color: HexColor("#656F77"),
              weight: FontWeight.w400,
              size: 12);
        });
  }
  current(){
    curr = currentPosition!.inSeconds.toDouble();
    notifyListeners();
  }
  Widget slider() {
    return Slider(
      activeColor: HexColor("#656F77"),
      inactiveColor: Colors.grey,
      value:curr.toDouble(),
      min: 0.0,
      max: dur!.inSeconds.toDouble(),
      onChanged: (double newValue) {
        changeToSeconds(curr.toInt());
        curr = newValue;
        notifyListeners();
      },
    );
  }
  void changeToSeconds(int seconds){
    Duration newDuration = Duration(seconds: seconds);
    player.seek(newDuration);
    debugPrint("\n---------------------------Seconds in Function is $seconds\n-----------------------\n"
        "Duration in Function is $newDuration");
    notifyListeners();
  }

// Getting Album Images
var songImage;
albumImage(){
    songImage = player.getCurrentAudioAlbum.toString();
}


}
