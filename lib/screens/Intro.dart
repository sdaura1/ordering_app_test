import 'package:flutter/material.dart';
import 'package:ordering_app/components/CustomDotIndicator.dart';
import 'package:ordering_app/screens/IntroScreenOne.dart';
import 'package:ordering_app/screens/IntroScreenTwo.dart';
import 'package:ordering_app/screens/MainScreen.dart';
import 'package:ordering_app/utils/SharedPref.dart';

import '../utils/Constants.dart';

class Intro extends StatefulWidget {

  Intro();

  @override
  _IntroState createState() => _IntroState();
}

class _IntroState extends State<Intro> with SingleTickerProviderStateMixin {

  var _handler;
  var currentIndex = 0;
  var token;
  late TabController _controller;
  List<Widget> tabs = [
    IntroScreenOne(),
    IntroScreenTwo(),
  ];

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: tabs.length, vsync: this);
    _handler = tabs[0];
    _controller.addListener(_handleSelected);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleSelected() {
    setState(() {
      _handler = tabs[_controller.index];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        height: 50,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(4)),
            color: Colors.black
        ),
        width: double.infinity,
        margin: EdgeInsets.only(right: 16, left: 16, bottom: 0),
        child:  MaterialButton(
            onPressed: () {
              SharedPref.setFirstLaunch(true);
              _controller.index == 0 ?
              setState(() => _controller.animateTo(_controller.index + 1)) :
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => MainScreen(destination: 0, fromCart: false),
                ),
              );
            },
            child: Text(_controller.index == 0 ? 'Next': 'Get Started',
                style: blackTextStyle.copyWith(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w400
                )
            )
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 376,
                child: TabBarView(
                    controller: _controller,
                    children: const [
                      Image(
                        fit: BoxFit.cover,
                        height: 376,
                        width: double.infinity,
                        image: AssetImage(
                            'images/1.png'
                        ),
                      ),
                      Image(
                        fit: BoxFit.cover,
                        height: 376,
                        width: double.infinity,
                        image: AssetImage(
                            'images/2.png'
                        ),
                      ),
                    ]
                ),
              ),
              SizedBox(height: 24,),
              CustomDotIndicator(isOne: _controller.index == 0 ? true : false),
              Container(
                height: 220,
                child: TabBarView(
                    controller: _controller,
                    children: tabs
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
