// Provider not using Database only using based on the Data passed
//
// import 'package:flutter/material.dart';

// class IconChanger with ChangeNotifier{
//   bool isIconChanged = true;
//   bool get isIconChangedgetter => isIconChanged;
//   void changeIcon(){
//     isIconChanged? isIconChanged=false:isIconChanged=true;
//     notifyListeners();
//   }
// }

//
// import 'package:flutter/cupertino.dart';
// import 'package:assets_audio_player/assets_audio_player.dart';
// import 'package:flutter/material.dart';
// import 'package:musin/materials/colors.dart';
// import 'package:musin/pages/widgets/widgets.dart';
// import 'package:on_audio_query/on_audio_query.dart';
//
// class PlayerCurrespondingItems extends ChangeNotifier {
//   final OnAudioQuery _audioQuery = OnAudioQuery();
//   final player = AssetsAudioPlayer();
//   // showFavouriteSnackBar(BuildContext context) {
//   //   final snack = SnackBar(
//   //     content: commonText(text: "Removed from Favourites",
//   //         color: Colors.red,
//   //         size: 13,
//   //         weight: FontWeight.w500,
//   //         isCenter: true),
//   //     duration: Duration(seconds: 1),
//   //     behavior: SnackBarBehavior.floating,
//   //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24),),
//   //     backgroundColor: Colors.white,
//   //     width: 250,
//   //   );
//   //   return ScaffoldMessenger.of(context).showSnackBar(snack);
//   // }
//
//   var isSelectedOrNot = true;
//   var isIconChanged = false;
//   var isNotificationOn = true;
//   bool isRepeat = false;
//   var songName, artistName, path, image, type,duration;
//
//   bool get isIconSelectedgetter => isSelectedOrNot;
//
//   getSongDetails(
//       {nameOfSong, nameOfArtist, songPath, artistImage, artistType,totalDuration}) {
//     songName = nameOfSong;
//     artistName = nameOfArtist;
//     path = songPath;
//     image = artistImage;
//     type = artistType;
//     duration = totalDuration;
//     notifyListeners();
//   }
//   void changeIcon() {
//     finishedOrNot();
//     isIconChanged ? isIconChanged = false : isIconChanged = true;
//     if(isIconChanged){
//       playSong(path);
//       getDuration();
//       totalDuration();
//     }else{
//       pauseSong();
//     }
//     notifyListeners();
//   }
//   playSong(link) async {
//     try {
//       await player.open(
//         Audio(link),
//         showNotification: isNotificationOn,notificationSettings: NotificationSettings(
//         customPlayPauseAction: (player){
//           changeIcon();
//         }
//       )
//       );
//     } catch (t) {
//       //mp3 unreachable
//       debugPrint("Cannot Play Song");
//       // showFavouriteSnackBar(context);
//     }
//   }
//   pauseSong()async{
//     await player.pause();
//     isRepeat = false;   // to Disable the Looping when user clicks the Button
//   }
//
//
// //------------------------Finished Or Not -------------
//
//   finishedOrNot(){
//       player.playlistAudioFinished.listen((event) {
//         debugPrint("Current Loop Mode is ${player.currentLoopMode!.index}");
//         if(player.currentLoopMode!.index == 0){
//         isIconChanged = false;
//         debugPrint("Entered inside loop ${player.currentLoopMode}");
//         notifyListeners();
//       }else if(player.currentLoopMode!.index == 1){
//           isIconChanged = true;
//           notifyListeners();
//         }
//     });
//     notifyListeners();
//   }
//
//   //----------------------------------------Loop Songs Area-----------------
//   loopSongs(){
//     if(isRepeat == false && isIconChanged == true){
//       player.setLoopMode(LoopMode.single);
//       isRepeat = true;
//       debugPrint("False : Loop Mode in If ${player.currentLoopMode}");
//       notifyListeners();
//     }
//     else if(isRepeat == true){
//       player.setLoopMode(LoopMode.none);
//       isRepeat = false;
//
//       debugPrint(" True: Loop Mode in Else ${player.currentLoopMode}");
//       notifyListeners();
//     }
//   }
//
//
//   // ------------------------------Duration/Slider Area------------------
//   Duration? currentPosition = Duration(seconds: 0);
//   Duration? dur=Duration(seconds: 0);
//   double curr=0;
//
//   totalDuration(){
//     player.current.listen((event) {
//       dur = event!.audio.duration;
//     });
//     return commonText(
//         text: dur.toString().split(".")[0],
//         color: HexColor("#656F77"),
//         weight: FontWeight.w400,
//         size: 12);
//   }
//   getDuration(){
//     return StreamBuilder(
//         stream: player.currentPosition,
//         builder: (context, asyncSnapshot) {
//           currentPosition = asyncSnapshot.data as Duration;
//           return commonText(
//               text: currentPosition.toString().split(".")[0],
//               color: HexColor("#656F77"),
//               weight: FontWeight.w400,
//               size: 12);
//         });
//   }
//   current(){
//     curr = currentPosition!.inSeconds.toDouble();
//     notifyListeners();
//   }
//   Widget slider() {
//     return Slider(
//       activeColor: HexColor("#656F77"),
//       inactiveColor: Colors.grey,
//       value:curr.toDouble(),
//       min: 0.0,
//       max: dur!.inSeconds.toDouble(),
//       onChanged: (double newValue) {
//         changeToSeconds(curr.toInt());
//         curr = newValue;
//         notifyListeners();
//       },
//     );
//   }
//   void changeToSeconds(int seconds){
//     Duration newDuration = Duration(seconds: seconds);
//     player.seek(newDuration);
//     debugPrint("\n---------------------------Seconds in Function is $seconds\n-----------------------\n"
//         "Duration in Function is $newDuration");
//     notifyListeners();
//   }
//
// // Getting Album Images
// var songImage;
// albumImage(){
//     songImage = player.getCurrentAudioAlbum.toString();
// }
//
// }


//
// import 'package:flutter/cupertino.dart';
// import 'package:assets_audio_player/assets_audio_player.dart';
// import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';
// import 'package:musin/database/database.dart';
// import 'package:musin/materials/colors.dart';
// import 'package:musin/pages/widgets/widgets.dart';
// import 'package:on_audio_query/on_audio_query.dart';
//
// import '../main.dart';
//
// class PlayerCurrespondingItems extends ChangeNotifier {
//   // final OnAudioQuery _audioQuery = OnAudioQuery();
//   final player = AssetsAudioPlayer();
//
//   // Getting Song key using Function
//   var songKeyCurrent = 0;
//   int nextKey=0;
//   var songName, artistName, path, image, type, duration;
//   var songKey;
//   var currentPos;
//
//   getSongKey({currentSongKey}) {
//     songKeyCurrent = currentSongKey;
//     notifyListeners();
//   }
//   // int? prevKey;
//
//
//
//
//   // Player Console Functions Starts
//     var isSelectedOrNot = true;
//   var isIconChanged = false;
//   var isNotificationOn = true;
//   bool isRepeat = false;
//
//   bool get isIconSelectedgetter => isSelectedOrNot;
//
//   // Listen if Player Clicked Play
//   void playOrpause(path) {
//     finishedOrNot();
//     isIconChanged ? isIconChanged = false : isIconChanged = true;
//     if (isSelectedOrNot) {
//       playSong(path);
//       getDuration();
//       // totalDuration();
//     } else {
//       pauseSong();
//     }
//     notifyListeners();
//   }
//
//   playSong(String link) async {
//     try {
//       debugPrint("\n--------------------------Path in Audio Player is ${link.replaceAll(' ', '')} \n----------------------------");
//       await player.open(Audio.file(link), showNotification: isNotificationOn,
//           notificationSettings:
//               NotificationSettings(customPlayPauseAction: (player) {
//         playOrpause(link);
//       }));
//     } catch (t) {
//       //mp3 unreachable
//       debugPrint("Cannot Play Song");
//       // showFavouriteSnackBar(context);
//     }
//   }
//
//   pauseSong() async {
//     await player.pause();
//     isRepeat = false; // to Disable the Looping when user clicks the Button
//   }
//
// //------------------------Finished Or Not -------------
//
//   finishedOrNot() {
//     player.playlistAudioFinished.listen((event) {
//       debugPrint("Current Loop Mode is ${player.currentLoopMode!.index}");
//       if (player.currentLoopMode!.index == 0) {
//         isIconChanged = false;
//         debugPrint("Entered inside loop ${player.currentLoopMode}");
//         notifyListeners();
//       } else if (player.currentLoopMode!.index == 1) {
//         isIconChanged = true;
//         notifyListeners();
//       }
//     });
//     notifyListeners();
//   }
//
//   //----------------------------------------Loop Songs Area-----------------
//   loopSongs() {
//     if (isRepeat == false && isIconChanged == true) {
//       playeoopMode(LoopMode.single);
//       isRepeat = true;
//       debugPrint("False : Loop Mode in If ${player.currentLoopMode}");
//       notifyListeners();
//     } else if (isRepeat == true) {
//       player.setLoopMode(LoopMode.none);
//       isRepeat = false;
//
//       debugPrint(" True: Loop Mode in Else ${player.currentLoopMode}");
//       notifyListeners();
//     }
//   }
//
//   // ------------------------------Duration/Slider Area------------------
//   Duration? currentPosition = Duration(seconds: 0);
//   Duration? dur = Duration(seconds: 0);
//   double curr = 0;
//
//   // totalDuration() {
//   //   player.current.listen((event) {
//   //     dur = event!.audio.duration;
//   //   });
//   //   return commonText(
//   //       text: dur.toString().split(".")[0],
//   //       color: HexColor("#656F77"),
//   //       weight: FontWeight.w400,
//   //       size: 12);
//   // }
//
//   var songDur;
//
//   getDuration() {
//     return StreamBuilder(
//         stream: player.currentPosition,
//         builder: (context, asyncSnapshot) {
//           currentPosition = asyncSnapshot.data as Duration;
//           return commonText(
//               text: currentPosition.toString().split(".")[0],
//               color: HexColor("#656F77"),
//               weight: FontWeight.w400,
//               size: 12);
//         });
//   }
//   current() {
//     curr = currentPosition!.inSeconds.toDouble();
//     notifyListeners();
//   }
//
//   Widget slider() {
//     return Slider(
//       activeColor: HexColor("#656F77"),
//       inactiveColor: Colors.grey,
//       value: curr.toDouble(),
//       min: 0.0,
//       max: dur!.inSeconds.toDouble(),
//       onChanged: (double newValue) {
//         changeToSeconds(curr.toInt());
//         curr = newValue;
//         notifyListeners();
//       },
//     );
//   }
//
//   void changeToSeconds(int seconds) {
//     Duration newDuration = Duration(seconds: seconds);
//     player.seek(newDuration);
//     notifyListeners();
//   }
//
// // Getting Album Images
//   var songImage;
//
//   albumImage() {
//     songImage = player.getCurrentAudioAlbum.toString();
//   }
//
//   // showFavouriteSnackBar(BuildContext context) {
//   //   final snack = SnackBar(
//   //     content: commonText(
//   //         text: "Removed from Favourites",
//   //         color: Colors.red,
//   //         size: 13,
//   //         weight: FontWeight.w500,
//   //         isCenter: true),
//   //     duration: Duration(seconds: 1),
//   //     behavior: SnackBarBehavior.floating,
//   //     shape: RoundedRectangleBorder(
//   //       borderRadius: BorderRadius.circular(24),
//   //     ),
//   //     backgroundColor: Colors.white,
//   //     width: 250,
//   //   );
//   //   return ScaffoldMessenger.of(context).showSnackBar(snack);
//   // }
// }



// Changes to accommada

import 'package:flutter/cupertino.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:musin/database/database.dart';
import 'package:musin/materials/colors.dart';
import 'package:musin/pages/widgets/widgets.dart';

import '../main.dart';

class PlayerCurrespondingItems extends ChangeNotifier {

  List<String> songsPathList = [];

  List<String> sampleKeys =[];
  getAllSongsPaths(List<String> songPathList){
    songPathList.forEach((element) {
      final audio = Audio.file(element);
      allSongsplayList.add(audio);
    });
  }
  getFavSongsPaths(List<String> songPathList){
    songPathList.forEach((element) {
      final audio = Audio.file(element);
      favPlaylist.add(audio);
    });
  }
  bool didUserClickedANewPlaylst = false;

  getPlaylistSongsPaths(List<String> songPathList){
    songPathList.forEach((element) {
      final audio = Audio.file(element);
      playlistSongsPlaylist.add(audio);
    });
  }
  showKeys(){
    selectModeOfPlaylist().forEach((element) {debugPrint(element.path);});
  }

  bool isSelectedOrNot = true;
  int? currentSongKey = 0;
  bool isNotificationOn=true;
  String? currentSongDuration;
  int? selectedSongKey;
  bool isIconChanged = false;
  bool isRepeat = false;


  final _assetsAudioPlayer = AssetsAudioPlayer();
  List<Audio> allSongsplayList = <Audio>[];
  List<Audio> favPlaylist = <Audio>[];
  List<Audio> playlistSongsPlaylist = <Audio>[];
  int modeOfPlaylist = 1;
  selectModeOfPlaylist(){
    if(modeOfPlaylist == 1){
      return allSongsplayList;
    }else if(modeOfPlaylist == 2){
      return favPlaylist;
    }else if(modeOfPlaylist == 3){
      return playlistSongsPlaylist;
    }
  }

 opnPlaylist(startingIndex) async{
   listenEverything();
   change();
    try{
      await _assetsAudioPlayer.open(
       Playlist(audios: selectModeOfPlaylist(),startIndex: startingIndex!),autoStart: true,loopMode: LoopMode.playlist,showNotification: true,
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
     selectedSongKey = _assetsAudioPlayer.current.value!.index;
   });
  }
  bool isShuffled=false;
  shuffleSongs(){
    _assetsAudioPlayer.toggleShuffle();
    _assetsAudioPlayer.shuffle?isShuffled = false:isShuffled=true;
    notifyListeners();
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

  Widget slider() {
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
  void changeToSeconds(int seconds) {
    Duration newDuration = Duration(seconds: seconds);
    _assetsAudioPlayer.seek(newDuration);
    notifyListeners();
  }


// showFavouriteSnackBar(BuildContext context) {
//   final snack = SnackBar(
//     content: commonText(
//         text: "Removed from Favourites",
//         color: Colors.red,
//         size: 13,
//         weight: FontWeight.w500,
//         isCenter: true),
//     duration: Duration(seconds: 1),
//     behavior: SnackBarBehavior.floating,
//     shape: RoundedRectangleBorder(
//       borderRadius: BorderRadius.circular(24),
//     ),
//     backgroundColor: Colors.white,
//     width: 250,
//   );
//   return ScaffoldMessenger.of(context).showSnackBar(snack);
// }
}
