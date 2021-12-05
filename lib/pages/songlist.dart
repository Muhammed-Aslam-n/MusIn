// import 'package:flutter/material.dart';
// import 'package:musin/materials/colors.dart';
// import 'package:musin/pages/home.dart';
// import 'package:miniplayer/miniplayer.dart';
// import 'package:musin/pages/songplayingpage.dart';
// import 'package:fluttericon/font_awesome_icons.dart';
// import 'package:musin/pages/widgets/widgets.dart';
//
// class SongList extends StatefulWidget {
//   const SongList({Key? key}) : super(key: key);
//
//   @override
//   _SongListState createState() => _SongListState();
// }
//
// bool isSelected = true;
//
// class _SongListState extends State<SongList> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: const CommonAppBar(),
//       body: Stack(
//         children: [
//           ListView(
//             shrinkWrap: true,
//             children: [
//               CommonHeaders(
//                 title: "Songs",
//                 subtitle: "100+ Songs found",
//               ),
//               SizedBox(
//                 height: 20,
//               ),
//               songLists(),
//               songLists(),
//               songLists(),
//               songLists(),
//               songLists(),
//               songLists(),
//               songLists(),
//               songLists(),
//             ],
//           ),
//           CommonMiniPlayer(
//           ),
//         ],
//       ),
//     );
//   }
//
//   songLists() {
//     return GestureDetector(
//       onTap: () {
//         isSelected = false;
//         setState(() {
//           isSelected = false;
//           print(isSelected);
//         });
//       },
//       child: Padding(
//         padding: EdgeInsets.all(10),
//         child: ListTile(
//           leading: ClipRRect(
//             child: Image.asset(
//               "assets/images/sampleImage.jfif",
//               height: 60,
//               width: 60,
//               fit: BoxFit.cover,
//             ),
//             borderRadius: BorderRadius.circular(12),
//           ),
//           title: commonText(text: "Bohemian Rapsody", size: 16),
//           subtitle: commonText(
//               text: "Queen",
//               color: HexColor(
//                 "#ACB8C2",
//               ),
//               size: 14),
//           trailing: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: const [
//               Icon(
//                 Icons.arrow_right,
//                 size: 44,
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
