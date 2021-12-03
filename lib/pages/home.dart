import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:musin/database/database.dart';
import 'package:musin/main.dart';
import 'package:musin/materials/colors.dart';
import 'package:musin/pages/favourites.dart';
import 'package:musin/pages/onboarding.dart';
import 'package:musin/pages/playlist.dart';
import 'package:musin/pages/searchsong.dart';
import 'package:musin/pages/widgets/widgets.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:musin/pages/songslist_main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

Color commonColor = HexColor("#A6B9FF");

class _HomeState extends State<Home> {
  Box<UserSongs>? userSong;
  List<SongModel> queriedSongs=[];

  final OnAudioQuery _audioQuery = OnAudioQuery();
  @override
  void initState() {
    requestPermission();
    userSong = Hive.box<UserSongs>(songDetailListBoxName);
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

    if (userSong!.isEmpty) {
      for (var element in queriedSongs) {
        final model = UserSongs(songName: element.title,
            artistName: element.artist,
            imageId: element.id,
            songPath: element.data,
            duration: element.duration);
        userSong!.add(model);
      }
    }else {
      // userSong!.clear();
      var list = userSong!.values.toList();
      for(var i=0;i<queriedSongs.length;i++){
        for(var j=0;j<userSong!.length;j++){
          if(queriedSongs[i].title != list[i].songName){
            final model = UserSongs(songName: queriedSongs[i].title,
                artistName: queriedSongs[i].artist,
                imageId: queriedSongs[i].id,
                songPath: queriedSongs[i].data,
                duration: queriedSongs[i].duration);
            userSong!.add(model);
          }else{
            userSong!.delete(i);
          }
        }
      }
    }
  }

  int currentIndex = 0;
  final PageController _pageController =
      PageController(initialPage: 0, keepPage: true);

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return
        // WillPopScope(
        // onWillPop: () async{
        //   final timegap = DateTime.now().difference(pre_backpress);
        //   final cantExit = timegap >= Duration(seconds: 2);
        //   pre_backpress = DateTime.now();
        //   if(cantExit){
        //     //show snackbar
        //     final snack = SnackBar(content: Text('Press Back button again to Exit'),duration: Duration(seconds: 2),);
        //     debugPrint("BackButton Pressed");
        //     ScaffoldMessenger.of(context).showSnackBar(snack);
        //     return false;
        //   }else{
        //     debugPrint("Exiting...");
        //     return true;
        //   }
        // },
        // child:
        Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        children: tabs,
      ),
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
            _pageController.animateToPage(index, duration: Duration(milliseconds: 500), curve: Curves.ease);
          });
        },
      ),
      // ),
    );
  }

  final tabs = [
    SongListMainHolder(),
    SearchSong(),
    Favourites(),
    PlayList(),
  ];
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late SharedPreferences launchData;
  bool newUser = false;

  @override
  void initState() {
    super.initState();
    debugPrint("isLaunched Value in SplashScreen Init is $isLaunched");
    getSharedPreference();
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
          Expanded(
            child: const Text(
              "MusIn",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
          )
        ],
      ),
      nextScreen: isLaunched ? Home() : OnBoarding(),
      splashTransition: SplashTransition.fadeTransition,
      // animationDuration: Duration(milliseconds: 1),
    );
  }

  bool isLaunched = false;

  Future<void> getSharedPreference() async {
    final sharedPref = await SharedPreferences.getInstance();
    isLaunched = await sharedPref.getBool('a') ?? false;
    debugPrint("The IsLaunched Value in Future of SplitScreen is $isLaunched");
  }
}
