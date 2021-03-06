import 'package:flutter/material.dart';
import 'package:musin/materials/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({Key? key}) : super(key: key);

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  textForAll(
      {text,
      family = "Poppins-Regular",
      double size = 32,
      weight = FontWeight.w700}) {
    return Text(text,
        style:
            TextStyle(fontSize: size, fontWeight: weight, fontFamily: family));
  }

  // bool? isLaunched;
  late SharedPreferences isLaunched;

  @override
  void initState() {
    initial();
    super.initState();
  }

  void initial() async {
    isLaunched = await SharedPreferences.getInstance();
    debugPrint("Launch Data inside OnBoard is ${isLaunched.get("launchSharedData")}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 20),
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: HexColor("#BBA5FF"),
                      borderRadius: BorderRadius.circular(12),
                      image: const DecorationImage(
                        image: ExactAssetImage(
                            'assets/images/MusInNoBackground.png'),
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Text(
                    "MusIn",
                    style: TextStyle(
                        color: HexColor("#B9C8FF"),
                        fontSize: 35,
                        fontWeight: FontWeight.w800),
                  )
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              textForAll(text: "\t\t\t\tLet the Beat"),
              textForAll(text: "\t\t\t\t\t\t\t\tCherish you..."),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: ExactAssetImage(
                        "assets/images/onBoardBgSplash.png",
                      ),
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                  child: GestureDetector(
                    onTap: () {

                      isLaunched.setBool('launchSharedData', true);
                      Navigator.pushReplacementNamed(context, '/home');
                      debugPrint("SharedPreference after login is ${isLaunched.get("launchSharedData")}");
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 4,
                          child: Container(
                            height: 350,
                            width: 300,
                            margin: const EdgeInsets.only(left: 30, top: 50),
                            child: Image.asset(
                              "assets/images/onBoardBgImage.png",
                            ),
                          ),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              textForAll(
                                  text: "MusIn",
                                  family: "Poppins-Light",
                                  size: 18),
                              const Icon(Icons.arrow_right),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
