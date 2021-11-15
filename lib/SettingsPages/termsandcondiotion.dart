import 'package:flutter/material.dart';
import 'package:musin/materials/colors.dart';
import 'package:musin/pages/home.dart';
import 'package:musin/pages/songlist.dart';
import 'package:musin/pages/widgets/widgets.dart';

class TermsandCondition extends StatelessWidget {
  const TermsandCondition({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor("#A6B9FF"),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.chevron_left_outlined,
            size: 30,
          ),
        ),
      ),
      body: ListView(shrinkWrap: true, children: [
        CommonHeaders(
          title: "Terms and Conditions",
          subtitle: "Heres how you can use this app ",
        ),
        SizedBox(
          height: 30,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: Container(
            // height: 2,
            // width: MediaQuery.of(context).size.height-50,
            decoration: BoxDecoration(
              color: HexColor("#A6B9FF"),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: commonText(
                    text:
                        "Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat. Ut wisi enim ad")),
          ),
        )
      ]),
    );
  }
}
