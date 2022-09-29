import 'package:flutter/material.dart';

import '../utils/Constants.dart';

class IntroScreenTwo extends StatelessWidget {

  IntroScreenTwo();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(height: 24),
              Container(
                margin: EdgeInsets.only(left: 16),
                height: 52,
                width: 271,
                child: Text('Lets make your next meal incredible',
                  style: blackTextStyle.copyWith(
                      fontSize: 22,
                      fontWeight: FontWeight.w700
                  ),
                ),
              ),
              SizedBox(height: 12,),
              Container(
                margin: EdgeInsets.only(left: 16),
                height: 58,
                width: 328,
                child: Text('Great local and continental dishes available by the click of a button',
                  style: blackTextStyle.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: hexToColor(textGreyColor)
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
