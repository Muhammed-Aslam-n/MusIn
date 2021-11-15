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
import 'package:provider/provider.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

Color commonColor = HexColor("#A6B9FF");

class _HomeState extends State<Home> {
  Box<SongDetailsList>? songDetailsList;
  List<SongModel> queriedSongs=[];

  final OnAudioQuery _audioQuery = OnAudioQuery();
  @override
  void initState() {
    requestPermission();
    songDetailsList = Hive.box<SongDetailsList>(songDetailListBoxName);
    // querySongs();
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

  querySongs()async{
    queriedSongs = await _audioQuery.querySongs();
    queriedSongs.forEach((element) {
      //   // var i=0;
      //   // debugPrint("Data in List ${element.data}");
      //   // debugPrint("Uri in List ${element.uri}");
      //   // debugPrint("Album in List ${element.album}");
      //   // debugPrint("Artist in List ${element.artist}");
      //   // debugPrint("Size in List ${element.size}");
      //   // debugPrint("ID in List ${element.id}");
      //   // debugPrint("Album Id in List ${element.albumId}");
      //   // debugPrint("Duration in List ${element.duration}");
      //   // debugPrint("SongName in List ${element.title}\n---------------------------------------------------");
      // final model = SongDetailsList(songName: element.title,artistName: element.artist,songId: element.id,path: element.data,duration: element.duration,);
      // songDetailsList!.add(model);
      //   songDetailsList!.clear();
    });
  }






  int currentIndex = 0;
  PageController _pageController =
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
    SongsListMain(),
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
          const Text(
            "MusIn",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
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
