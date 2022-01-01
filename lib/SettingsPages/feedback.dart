import 'package:flutter/material.dart';
import 'package:musin/materials/colors.dart';
import 'package:musin/pages/widgets/widgets.dart';
import 'package:get/get.dart';

class UserFeedback extends StatelessWidget {
  const UserFeedback({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor("#A6B9FF"),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.chevron_left_outlined,
            size: 30,
          ),
        ),
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          const CommonHeaders(
            title: "Feedback",
            subtitle: "Let us know what you think...",
          ),
          const SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 30,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                commonText(text: "Email"),
                sizedh2,
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: "sample@mail.com",
                  ),
                ),
                sizedh2,
                commonText(text: "Tell us what you think "),
                sizedh2,
                Container(
                  height: 150,
                  // width: MediaQuery.of(context).size.height-50,
                  decoration: BoxDecoration(
                    color: HexColor("#A6B9FF"),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    child: TextFormField(
                      maxLines: 40,
                      decoration: const InputDecoration.collapsed(
                        hintText: "Enter your comments",
                      ),
                    ),
                  ),
                ),sizedh2,
                Center(
                  child: MaterialButton(
                    onPressed: () {
                      debugPrint("Feedback Sent Clicked");
                    },
                    color: HexColor("#A6B9FF"),
                    child: commonText(text: "Send", color: Colors.white),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
