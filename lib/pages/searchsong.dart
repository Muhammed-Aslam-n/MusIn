import 'package:flutter/material.dart';
import 'package:musin/materials/colors.dart';
import 'package:musin/pages/home.dart';
import 'package:musin/pages/songlist.dart';
import 'package:musin/pages/widgets/widgets.dart';

class SearchSong extends StatefulWidget {
  const SearchSong({Key? key}) : super(key: key);

  @override
  _SearchSongState createState() => _SearchSongState();
}

class _SearchSongState extends State<SearchSong> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=>FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: commonAppBar(context),
        body: ListView(
          shrinkWrap: true,
          children: [
            CommonHeaders(
              title: "Search",
              subtitle: "Find your songs",
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              padding: EdgeInsets.all(8),
              height: 40,
              width: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: HexColor("#E8EEF3"),
              ),
              child: Row(
                children: [
                  sizedw1,
                  Icon(
                    Icons.search,
                    size: 19,
                  ),
                  Expanded(
                    child: Form(
                      child: TextFormField(
                        decoration: InputDecoration.collapsed(
                            hintText: "\t\t\tSearch here ...",
                            hintStyle: TextStyle(fontSize: 12)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
