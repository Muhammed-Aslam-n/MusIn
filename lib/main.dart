import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musin/SettingsPages/feedback.dart';
import 'package:musin/SettingsPages/privacypolicy.dart';
import 'package:musin/controller/musincontroller.dart';
import 'package:musin/pages/favourites.dart';
import 'package:musin/pages/home.dart';
import 'package:musin/pages/onboarding.dart';
import 'package:musin/pages/playlist.dart';
import 'package:musin/pages/playlist_songs.dart';
import 'package:path_provider/path_provider.dart';
import '/SettingsPages/feedback.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'constants/constants.dart';
import 'database/database.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AssetsAudioPlayer.setupNotificationsOpenAction((notification) {
    return true;
  });
  final directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  Hive.registerAdapter(UserSongsAdapter());
  Hive.registerAdapter(UserPlaylistNamesAdapter());
  Hive.registerAdapter(UserPlaylistSongsAdapter());
  await Hive.openBox<UserSongs>(userSongBoxName);
  await Hive.openBox<UserPlaylistNames>(userPlaylistBoxName);
  await Hive.openBox<UserPlaylistSongs>(userPlaylistSongBoxName);
  Get.put(MusinController());
  runApp(const MusinApp());
}

class MusinApp extends StatelessWidget {
  const MusinApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        title: 'Musin',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/splashscreen',
        getPages: [
          GetPage(name: '/splashscreen', page: () => const SplashScreen()),
          GetPage(name: '/onboarding', page: () => const OnBoarding()),
          GetPage(name: '/home', page: () => const Home()),
          GetPage(name: '/playlist', page: () => const PlayList()),
          GetPage(name: '/playlistsongs', page: () => PlaylistSongs()),
          GetPage(name: '/favourites', page: () => const Favourites()),
          GetPage(name: '/feedback', page: () => const UserFeedback()),
          GetPage(name: '/privacypolicy', page: () => const PrivacyPolicy()),
        ],
    );
  }
}
