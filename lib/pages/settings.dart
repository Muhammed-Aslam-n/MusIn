import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:musin/SettingsPages/feedback.dart';
import 'package:musin/SettingsPages/privacypolicy.dart';
import 'package:musin/SettingsPages/termsandcondiotion.dart';
import 'package:musin/materials/colors.dart';
import 'package:musin/pages/home.dart';
import 'package:musin/pages/songlist.dart';
import 'package:cupertino_icons/cupertino_icons.dart';
import 'package:musin/pages/widgets/widgets.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool _switchValue = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppBar(context),
      body: SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            CommonHeaders(
              title: "Settings",
              subtitle: "Change App Settings",
            ),
            const SizedBox(
              height: 100,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 50),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      commonText(text: "Notification", size: 17),
                      Transform.scale(
                        scale: 0.8,
                        child: CupertinoSwitch(
                            value: _switchValue,
                            onChanged: (value) {
                              setState(() {
                                _switchValue = value;
                              });
                            }),
                      )
                    ],
                  ),
                  sizedh2,
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => UserFeedback()));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        commonText(text: "Feedback", size: 17),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 15,
                        ),
                      ],
                    ),
                  ),
                  sizedh2,
                  GestureDetector(
                    onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context) => PrivacyPolicy()));},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        commonText(text: "Privacy Policy", size: 17),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 15,
                        ),
                      ],
                    ),
                  ),
                  sizedh2,
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => TermsandCondition()));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        commonText(text: "Terms and Conditions", size: 17),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 15,
                        ),
                      ],
                    ),
                  ),
                  sizedh2,
                  GestureDetector(
                    onTap: () {
                      showAbout();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        commonText(text: "About", size: 17),
                      ],
                    ),
                  ),
                  sizedh2,
                  commonText(
                      text: "1.0.00.1", size: 12, weight: FontWeight.w400)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  showAbout() {
    return showAboutDialog(
        context: (context),
        applicationIcon: Image.asset(
          "assets/images/MusInNoBackground.png",
          height: 45,
          width: 55,
          fit: BoxFit.cover,
        ),
        applicationName: "MusIn",
        applicationVersion: "1.0.00.1",
        children: [
          commonText(
              text:
                  "This Application is Developed by CrossRoads Ddevelopment Company\n"
                  "All Rights Reserved to CrossRoads Pvt.Limited",
              size: 12,
              weight: FontWeight.w400)
        ]);
  }
}
