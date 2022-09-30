import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ordering_app/functions/DatabaseHelper.dart';
import 'package:ordering_app/models/CartModel.dart';
import 'package:ordering_app/screens/MainScreen.dart';
import 'package:ordering_app/utils/Constants.dart';
import 'package:ordering_app/utils/SharedPref.dart';
import 'Intro.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {

  final dbHelper = DatabaseHelper.instance;
  late AnimationController controller;
  double percent = 0;
  late Timer timer;
  bool isExpired = false;
  List<CartModel> items = [];

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 1), (Timer timer) =>
      setState(() {
        if(percent >= 1){
          timer.cancel();
          if(SharedPref.getFirstLaunch()){
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => const MainScreen(destination: 0, fromCart: false)
              ),
            );
          }else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (BuildContext context) => Intro()),
            );
          }
        } else {
          percent += 0.45;
        }
      }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: hexToColor(orangeColor),
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              const Image(
                fit: BoxFit.cover,
                height: 46,
                width: 184,
                image: AssetImage(
                    'images/patoosh.png'
                ),
              ),
              const Spacer(),
              SizedBox(
                height: 4,
                width: 184,
                child: LinearProgressIndicator(
                  value: percent,
                  semanticsLabel: 'Linear progress indicator',
                  backgroundColor: Colors.black,
                  valueColor: const AlwaysStoppedAnimation(Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
