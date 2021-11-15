import 'package:flutter/material.dart';
import 'package:musin/materials/colors.dart';
import 'package:musin/pages/songlist.dart';
import 'package:musin/pages/widgets/widgets.dart';

class Favourites extends StatefulWidget {
  const Favourites({Key? key}) : super(key: key);

  @override
  _FavouritesState createState() => _FavouritesState();
}
bool isSelected = true;
class _FavouritesState extends State<Favourites> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppBar(context),
      body: Stack(
        children: [
          ListView(
            children: [
              CommonHeaders(
                title: "Favourites",
                subtitle: "Hear the Best",
              ),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: (){
                  isSelected = false;
                  setState(() {
                    isSelected = false;
                    print(isSelected);
                  });
                },
                child: FavouriteSongs(
                  image: "assets/images/sampleImage.jfif",
                  songName: "I'm not you man",
                  songDesc: "Me",
                ),
              ),
            ],
          ),
          CommonMiniPlayer(
              // isSelected: isSelected
          ),
        ],
      ),
    );
  }
}
