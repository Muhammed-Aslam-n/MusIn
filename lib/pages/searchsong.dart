import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:musin/controller/musincontroller.dart';
import 'package:musin/database/database.dart';
import 'package:musin/materials/colors.dart';
import 'package:musin/pages/widgets/widgets.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:get/get.dart';

class SearchSong extends StatefulWidget {
  const SearchSong({Key? key}) : super(key: key);

  @override
  _SearchSongState createState() => _SearchSongState();
}

class _SearchSongState extends State<SearchSong> {
  final musinController = Get.find<MusinController>();

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          appBar: const CommonAppBar(),
          body: ListView(
            shrinkWrap: true,
            children: [
              const CommonHeaders(
                title: "Search",
                subtitle: "Find your songs",
              ),
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                padding: const EdgeInsets.all(8),
                height: 40,
                width: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: HexColor("#E8EEF3"),
                ),
                child: Row(
                  children: [
                    sizedw1,
                    const Icon(
                      Icons.search,
                      size: 19,
                    ),
                    Expanded(
                      child: Form(
                        child: TextFormField(
                          onChanged: (k) {
                            musinController.onSearchChanged(musinController.searchController);
                          },
                          controller: musinController.searchController,
                          decoration: const InputDecoration.collapsed(
                              hintText: "\t\t\tSearch here ...",
                              hintStyle: TextStyle(fontSize: 12)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SearchSongResults(),
            ],
          ),
        ));
  }
}

class SearchSongResults extends StatelessWidget {
  const SearchSongResults({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MusinController>(
      id: 'searchBuilder',
      init: MusinController(),
      builder: (musinController) => ValueListenableBuilder(
          valueListenable: musinController.userSongsInstance!.listenable(),
          builder: (context, Box<UserSongs> songFetcher, _) {
            var results = musinController.searchController.text.isEmpty
                ? songFetcher.values.toList() // whole list
                : songFetcher.values
                    .where((c) => c.songName!
                        .toLowerCase()
                        .contains(musinController.searchSongName ?? ''))
                    .toList();

            debugPrint(
                "Value of Provider inside ValueListenableBuilder is ${musinController.searchSongName}");

            return results.isEmpty
                ? const Center(
                    child: Text(
                      'No Songs found !',
                      style: TextStyle(color: Colors.redAccent),
                    ),
                  )
                : ListView.builder(
                    itemCount: results.length,
                    shrinkWrap: true,
                    physics: const ScrollPhysics(),
                    itemBuilder: (context, index) {
                      final UserSongs contactListItem = results[index];
                      return ListTile(
                        leading: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: QueryArtworkWidget(
                              id: contactListItem.imageId!,
                              type: ArtworkType.AUDIO,
                              nullArtworkWidget: ClipRRect(
                                  child: Image.asset(
                                    "assets/images/defaultImage.png",
                                    height: 50,
                                    width: 50,
                                    fit: BoxFit.fill,
                                  ),
                                  borderRadius: BorderRadius.circular(10)),
                              artworkHeight: 50,
                              artworkWidth: 50,
                              artworkFit: BoxFit.fill,
                              artworkBorder: BorderRadius.circular(10)),
                        ),
                        title: commonText(
                            text: contactListItem.songName,
                            size: 15,
                            weight: FontWeight.w600),
                        subtitle: commonText(
                            text: contactListItem.artistName,
                            size: 12,
                            color: HexColor("#ACB8C2"),
                            weight: FontWeight.w600),
                      );
                    });
          }),
    );
  }
}
