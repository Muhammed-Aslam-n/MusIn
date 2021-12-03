import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:musin/SettingsPages/feedback.dart';
import 'package:musin/SettingsPages/privacypolicy.dart';
import 'package:musin/SettingsPages/termsandcondiotion.dart';
import 'package:musin/pages/favourites.dart';
import 'package:musin/pages/home.dart';
import 'package:musin/pages/onboarding.dart';
import 'package:musin/pages/playlist.dart';
import 'package:musin/pages/playlist_songs.dart';
import 'package:musin/pages/songlist.dart';
import 'package:musin/provider/provider_class.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import '/SettingsPages/feedback.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'database/database.dart';

const String songDetailListBoxName = 'userSongs';
const String userPlaylistBoxName = 'userPlaylistNames';
const String userPlaylistSongBoxName = 'userPlaylistSongs';



void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  AssetsAudioPlayer.setupNotificationsOpenAction((notification) {
    return true;
  });
  final directory =await getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  Hive.registerAdapter(UserSongsAdapter());
  Hive.registerAdapter(UserPlaylistNamesAdapter());
  Hive.registerAdapter(UserPlaylistSongsAdapter());
  await Hive.openBox<UserSongs>(songDetailListBoxName);
  await Hive.openBox<UserPlaylistNames>(userPlaylistBoxName);
  await Hive.openBox<UserPlaylistSongs>(userPlaylistSongBoxName);
  runApp(const MusinApp());
}

class MusinApp extends StatelessWidget {
  const MusinApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PlayerCurrespondingItems>(
      create: (_)=>PlayerCurrespondingItems(),
      child: MaterialApp(
        title: 'Musin',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/splashscreen',
        routes: {
          '/splashscreen': (context) => const SplashScreen(),
          '/onboarding': (context) =>  const OnBoarding(),
          '/home': (context) => const Home(),
          '/songlist': (context) => const SongList(),
          // '/songplayingpage': (context) => SongPlayingPage(),
          // // '/searchSong': (context) => const SearchSong(),
          // '/settings': (context) => const Settings(),
          '/playlist': (context) => const PlayList(),
          '/playlistsongs': (context) => PlaylistSongs(),
          // '/upcomingsongs': (context) => const UpcomingSongs(),
          '/favourites': (context) => const Favourites(),
          '/feedback': (context) => const UserFeedback(),
          '/privacypolicy': (context) => const PrivacyPolicy(),
          '/termsandcondition': (context) => const TermsandCondition(),

        },
      ),
    );
  }
}
