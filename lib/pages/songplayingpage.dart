// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttericon/entypo_icons.dart';
// import 'package:musin/materials/colors.dart';
// import 'package:musin/pages/home.dart';
// import 'package:fluttericon/font_awesome_icons.dart';
// import 'package:musin/pages/songlist.dart';
// import 'package:musin/pages/widgets/widgets.dart';
// import 'package:musin/provider/provider_class.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:provider/provider.dart';
//
// class SongPlayingPage extends StatefulWidget {
//   SongPlayingPage({Key? key}) : super(key: key);
//
//   @override
//   _SongPlayingPageState createState() => _SongPlayingPageState();
// }
//
// class _SongPlayingPageState extends State<SongPlayingPage> {
//   bool? isFavourite = false, isLoop = false, isShuffle = false, isAdded = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Consumer<PlayerCurrespondingItems>(
//         builder: (_, setSongDetails, child) => Container(
//           margin: const EdgeInsets.only(top: 20),
//           width: double.infinity,
//           height: MediaQuery.of(context).size.height,
//           decoration: const BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(24), topRight: Radius.circular(24))),
//           child: ListView(
//             children: [
//               sizedh2,
//               Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 30),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       commonText(text: "Now Playing", size: 17),
//                       Row(
//                         children: [
//                           IconButton(
//                             onPressed: () {
//                               isFavourite = !isFavourite!;
//                               showFavouriteSnackBar(context);
//                               setState(() {});
//                             },
//                             icon: const Icon(CupertinoIcons.heart),
//                             color: isFavourite! ? Colors.red : Colors.black87,
//                           ),
//                           IconButton(
//                               onPressed: () {
//                                 isAdded = !isAdded!;
//                                 showPlaylistSnackBar(context);
//                                 setState(() {});
//                               },
//                               icon: isAdded!
//                                   ? const Icon(
//                                       CupertinoIcons.add,
//                                     )
//                                   : const Icon(
//                                       CupertinoIcons.checkmark_circle,
//                                       color: Colors.green,
//                                     )),
//                         ],
//                       )
//                     ],
//                   )),
//               SizedBox(
//                 height: MediaQuery.of(context).size.height * 0.05,
//               ),
//               Column(
//                 children: [
//                   Container(
//                     height: 200,
//                     width: 200,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       border: Border.all(
//                         width: 5,
//                         color: commonColor,
//                       ),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: CircleAvatar(
//                         backgroundImage: AssetImage(setSongDetails.image),
//                       ),
//                     ),
//                   ),
//                   sizedh2,
//                   commonText(
//                     text: setSongDetails.songName,
//                     size: 21,
//                   ),
//                   commonText(
//                       text: setSongDetails.artistName,
//                       size: 15,
//                       color: HexColor("656F77"),
//                       weight: FontWeight.w400),
//                   sizedh2,
//                   sizedh2,
//                   SizedBox(
//                     width: MediaQuery.of(context).size.width * 0.8,
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         IconButton(
//                           onPressed: () {
//                             setSongDetails.loop();
//                           },
//                           icon: Icon(Icons.loop_outlined,
//                               size: 26,
//                               color: setSongDetails.isLoop
//                                   ? Colors.blueAccent
//                                   : HexColor("#656F77")),
//                         ),
//                         sizedw1,
//                         const Icon(
//                           FontAwesome.left_dir,
//                           size: 37,
//                         ),
//                         sizedw2,
//                         Container(
//                           width: 80,
//                           height: 80,
//                           decoration: BoxDecoration(
//                               shape: BoxShape.circle, color: commonColor),
//                           child: IconButton(
//                             onPressed: () {
//                               setSongDetails.changeIcon();
//                               // setSongDetails.isIconChanged?setSongDetails.playSong(audio,context):songDetailsProvider.pauseSong();
//                             },
//                             icon: setSongDetails.isIconChanged
//                                 ? const Icon(
//                                     Icons.pause,
//                                     size: 60,
//                                     color: Colors.white,
//                                   )
//                                 : const Icon(
//                                     Icons.play_arrow,
//                                     size: 60,
//                                     color: Colors.white,
//                                   ),
//                           ),
//                         ),
//                         sizedw2,
//                         IconButton(
//                           onPressed: () {
//                             // setSongDetails.isIconChanged?setSongDetails.playSong(setSongDetails.path, context):setSongDetails.pauseSong();
//                             // setSongDetails.duration();
//                           },
//                           icon: const Icon(
//                             FontAwesome.right_dir,
//                             size: 37,
//                           ),
//                         ),
//                         sizedw2,
//                         IconButton(
//                           onPressed: () {
//                             isShuffle = !isShuffle!;
//                             setState(() {});
//                           },
//                           icon: Icon(
//                             Entypo.shuffle,
//                             size: 22,
//                             color: isShuffle!
//                                 ? Colors.blueAccent
//                                 : HexColor("#656F77"),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   sizedh2,
//                   SizedBox(
//                     width: MediaQuery.of(context).size.width * 0.8,
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         commonText(
//                             text: setSongDetails.currentPosition().toString(),
//                             color: HexColor("#656F77"),
//                             weight: FontWeight.w400,
//                             size: 12),
//                         sizedw1,
//                         Expanded(
//                           child: SliderTheme(
//                             data: SliderTheme.of(context).copyWith(
//                                 thumbColor: Colors.orange,
//                                 activeTrackColor: Colors.black87),
//                             child: Slider(
//                               thumbColor: Colors.black54,
//                               onChanged: (value) {},
//                               min: 0,
//                               max: 100,
//                               value: 40,
//                             ),
//                           ),
//                         ),
//                         sizedw1,
//                         commonText(
//                             text: setSongDetails.duration??'',
//                             color: HexColor("#656F77"),
//                             weight: FontWeight.w400,
//                             size: 12),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   showPlaylistSnackBar(BuildContext context) {
//     final snack = SnackBar(
//       content: isAdded!
//           ? commonText(
//               text: "Added to Playlist",
//               color: Colors.green,
//               size: 13,
//               weight: FontWeight.w500,
//               isCenter: true)
//           : commonText(
//               text: "Removed from Playlist",
//               color: Colors.red,
//               size: 13,
//               weight: FontWeight.w500,
//               isCenter: true),
//       duration: Duration(seconds: 1),
//       behavior: SnackBarBehavior.floating,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(24),
//       ),
//       backgroundColor: Colors.white,
//       width: 250,
//     );
//     return ScaffoldMessenger.of(context).showSnackBar(snack);
//   }
//
//   showFavouriteSnackBar(BuildContext context) {
//     final snack = SnackBar(
//       content: isFavourite!
//           ? commonText(
//               text: "Added to Favourites",
//               color: Colors.green,
//               size: 13,
//               weight: FontWeight.w500,
//               isCenter: true)
//           : commonText(
//               text: "Removed from Favourites",
//               color: Colors.red,
//               size: 13,
//               weight: FontWeight.w500,
//               isCenter: true),
//       duration: Duration(seconds: 1),
//       behavior: SnackBarBehavior.floating,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(24),
//       ),
//       backgroundColor: Colors.white,
//       width: 250,
//     );
//     return ScaffoldMessenger.of(context).showSnackBar(snack);
//   }
// }
