import 'package:fluttericon/typicons_icons.dart';
import 'package:marquee/marquee.dart';
import 'package:musin/SettingsPages/feedback.dart';
import 'package:musin/SettingsPages/privacypolicy.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/entypo_icons.dart';
import 'package:musin/constants/constants.dart';
import 'package:musin/controller/musincontroller.dart';
import 'package:musin/materials/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share/share.dart';

class CommonAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CommonAppBar({Key? key}) : super(key: key);

  @override
  _CommonAppBarState createState() => _CommonAppBarState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(80);
}

class _CommonAppBarState extends State<CommonAppBar> {
  late SharedPreferences changeNotificationSettings;
  bool turnNotificationOn = true;

  @override
  void initState() {
    initializeNotificationShared();
    getSharedPreference();
    super.initState();
  }

  initializeNotificationShared() async {
    changeNotificationSettings = await SharedPreferences.getInstance();
  }
  Future<void> getSharedPreference() async {
    final musinController = Get.find<MusinController>();
    final sharedPref = await SharedPreferences.getInstance();
    turnNotificationOn = sharedPref.getBool('changeNotificationMode') ?? true;
    turnNotificationOn
        ? musinController.disableNotification()
        : musinController.enableNotification;
    musinController.turnNotificationOn = turnNotificationOn;
  }
  void _launchURL(url) async {
    var urllaunchable = await canLaunch(url);
    if(urllaunchable){
      await launch(url); //launch is from url_launcher package to launch URL
    }else{
      debugPrint("URL can't be launched.");
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Padding(
          padding: const EdgeInsets.only(top: 18),
          child: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leadingWidth: 55,
            leading: Container(
              margin: const EdgeInsets.only(left: 15),
              child: Image.asset("assets/images/MusInNoBackground.png"),
            ),
            title: commonText(text: "MusIn", color: HexColor("#A6adFF")),
            centerTitle: true,
            actions: [
              PopupMenuButton(
                tooltip: "Settings",
                color: Colors.white.withOpacity(0.8),
                icon: const Icon(
                  CupertinoIcons.settings,
                  color: Colors.black87,
                ),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Notification"),
                        Transform.scale(
                          scale: 0.8,
                          child: CupertinoSwitch(
                            value: turnNotificationOn,
                            onChanged: (value) {
                              turnNotificationOn = value;
                              final musinController = Get.find<MusinController>();
                              turnNotificationOn
                                  ? musinController.enableNotification()
                                  : musinController.disableNotification();
                              musinController.turnNotificationOn = turnNotificationOn;
                              changeNotificationSettings.setBool(
                                  'changeNotificationMode', turnNotificationOn);
                              setState(() {});
                              Navigator.of(context).pop();
                            },
                          ),
                        )
                      ],
                    ),
                    value: 1,
                  ),
                  PopupMenuItem(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const UserFeedback()));
                      },
                      child: Row(
                        children: const [
                          Icon(
                            Icons.feedback,
                            color: Colors.black45,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text("Feedback"),
                        ],
                      ),
                    ),
                    value: 2,
                  ),
                  PopupMenuItem(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const PrivacyPolicy()));
                      },
                      child: Row(
                        children: const [
                          Icon(
                            Icons.lock,
                            color: Colors.black45,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text("Privacy Policy"),
                        ],
                      ),
                    ),
                    value: 3,
                  ),
                  PopupMenuItem(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                        _launchURL(termsAndConditonsUrl);
                      },
                      child: Row(
                        children: const [
                          Icon(
                            Typicons.clipboard,
                            color: Colors.black45,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text("Terms and Conditions"),
                        ],
                      ),
                    ),
                    value: 4,
                  ),
                  PopupMenuItem(
                    child: GestureDetector(
                      onTap: () {
                        _launchURL(appUrl);
                        Navigator.of(context).pop();
                      },
                      child: Row(
                        children: const [
                          Icon(
                            Entypo.star,
                            color: Colors.black45,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text("Rate App"),
                        ],
                      ),
                    ),
                    value: 5,
                  ),
                  PopupMenuItem(
                    child: GestureDetector(
                      onTap: () {
                        Share.share(appUrl);
                        Navigator.of(context).pop();
                        // Share.share('text')
                      },
                      child: Row(
                        children: const [
                          Icon(
                            Entypo.share,
                            color: Colors.black45,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text("Share"),
                        ],
                      ),
                    ),
                    value: 6,
                  ),
                  PopupMenuItem(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                        showAbout(context);
                      },
                      child: Row(
                        children: const [
                          Icon(
                            Entypo.info,
                            color: Colors.black45,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text("About"),
                        ],
                      ),
                    ),
                    value: 7,
                  ),
                ],
              ),
              sizedw2,
            ],
          ),
        ),
      ),
    );
  }



  showAbout(BuildContext context) {
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
                  "This Application is Developed by CrossRoads Development Company\n"
                  "All Rights Reserved to CrossRoads Pvt.Limited",
              size: 12,
              weight: FontWeight.w400)
        ]);
  }
}

commonText(
    {text,
    color = Colors.black,
    double size = 18,
    family = "Poppins-Regular",
    weight = FontWeight.w700,
    isCenter = false}) {
  return Text(
    text.toString(),
    textAlign: isCenter ? TextAlign.center : TextAlign.left,
    style: style(weight: weight, size: size, family: family, color: color),
  );
}

style({color, size, family, weight}) {
  return TextStyle(
    color: color,
    fontSize: size,
    fontFamily: family,
    fontWeight: weight,
  );
}

class CommonHeaders extends StatelessWidget {
  final String? title,subtitle;
  final double? pLeft,pTop;

  const CommonHeaders({Key? key, this.title, this.subtitle, this.pLeft, this.pTop}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.13,
      decoration: BoxDecoration(
          color: HexColor("#fff"),
          borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(24),
              bottomRight: Radius.circular(24))),
      child: Padding(
        padding:  EdgeInsets.only(left: pLeft??32, top: pTop??25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            commonText(
              text: title,
            ),
            const SizedBox(
              height: 5,
            ),
            commonText(
              text: subtitle,
              size: 14,
              color: HexColor("#656F77"),
            ),
          ],
        ),
      ),
    );
  }
}

commonMarquees(
    {height,
    width,
    hPadding,
    vPadding,
    text = "",
    velocity,
    blankSpace,
    color,
    weight,
    size,
    family,
    duration}) {
  return SizedBox(
    height: height ?? 50,
    width: width ?? double.infinity,
    child: Padding(
      padding: EdgeInsets.symmetric(
        horizontal: hPadding ?? 40.0,
        vertical: vPadding ?? 0.0,
      ),
      child: Marquee(
        text: text ?? "Not Found",
        blankSpace: blankSpace ?? 300,
        numberOfRounds: 1,
        velocity: velocity ?? 30,
        pauseAfterRound: Duration(seconds: duration ?? 3),
        style: style(
            color: color ?? Colors.black,
            weight: weight ?? FontWeight.w700,
            size: size,
            family: family ?? "Poppins-Regular"),
      ),
    ),
  );
}


var sizedh1 = const SizedBox(
  height: 10,
);
var sizedh2 = const SizedBox(
  height: 20,
);
var sizedw1 = const SizedBox(
  width: 10,
);
var sizedw2 = const SizedBox(
  width: 10,
);
