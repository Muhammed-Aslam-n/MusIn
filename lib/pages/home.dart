import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:musin/controller/musincontroller.dart';
import 'package:musin/database/database.dart';
import 'package:musin/materials/colors.dart';
import 'package:musin/pages/favourites.dart';
import 'package:musin/pages/onboarding.dart';
import 'package:musin/pages/playlist.dart';
import 'package:musin/pages/searchsong.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:musin/pages/songslist_main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:get/get.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

Color commonColor = HexColor("#A6B9FF");

class _HomeState extends State<Home> {
  final musinController = Get.find<MusinController>();
  List<SongModel> queriedSongs=[];

  final OnAudioQuery _audioQuery = OnAudioQuery();
  @override
  void initState() {
    requestPermission();
    querySongs();
    super.initState();
  }
  requestPermission() async {
    // Web platform don't support permissions methods.
    if (!kIsWeb) {
      bool permissionStatus = await _audioQuery.permissionsStatus();
      if (!permissionStatus) {
        await _audioQuery.permissionsRequest();
      }
      setState(() {});
    }
  }
  querySongs()async {
    queriedSongs = await _audioQuery.querySongs();

    if (musinController.userSongsInstance!.isEmpty) {
      for (var element in queriedSongs) {
        final model = UserSongs(songName: element.title,
            artistName: element.artist,
            imageId: element.id,
            songPath: element.data,
            duration: element.duration);
        musinController.userSongsInstance!.add(model);
      }
    }else {
      // userSong!.clear();
      var list = musinController.userSongsInstance!.values.toList();
      for(var i=0;i<queriedSongs.length;i++){
        for(var j=0;j<musinController.userSongsInstance!.length;j++){
          if(queriedSongs[i].title != list[i].songName){
            final model = UserSongs(songName: queriedSongs[i].title,
                artistName: queriedSongs[i].artist,
                imageId: queriedSongs[i].id,
                songPath: queriedSongs[i].data,
                duration: queriedSongs[i].duration);
            musinController.userSongsInstance!.add(model);
          }else{
            break;
          }
        }
      }
    }
  }

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return
        Scaffold(
      body: tabs[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: HexColor("#9baffa"),
        elevation: 0,
        showUnselectedLabels: false,
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.music_note), label: "Songs"),
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.search), label: "Search"),
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.heart), label: "Favourites"),
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.music_note_list), label: "Playlist"),
        ],
        onTap: (index) {
          setState(() {
            currentIndex = index;
           });
        },
      ),
      // ),
    );
  }
  final tabs = [
    const SongListMainHolder(),
    const SearchSong(),
    const Favourites(),
    const PlayList(),
  ];
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  bool isLaunched = false;
  late SharedPreferences launchData;
  @override
  void initState() {
    getSharedPreference();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Column(
        children: [
          ClipRect(
            clipBehavior: Clip.hardEdge,
            child: Image.asset(
              "assets/images/MusInNoBackground.png",
              height: 50,
              width: 50,
              fit: BoxFit.contain,
            ),
          ),
          const Expanded(
            child: Text(
              "MusIn",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
          )
        ],
      ),
      nextScreen: isLaunched ? const Home() : const OnBoarding(),
      splashTransition: SplashTransition.fadeTransition,
    );
  }


  Future<void> getSharedPreference() async {
    final sharedPref = await SharedPreferences.getInstance();
    isLaunched = sharedPref.getBool('launchSharedData') ?? false;
    debugPrint("SharedPreference in SplashScreen is : $isLaunched");
  }
}
