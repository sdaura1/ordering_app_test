import 'package:flutter/material.dart';
import 'package:ordering_app/utils/Constants.dart';

class IntroScreenOne extends StatelessWidget {

  IntroScreenOne();

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
              SizedBox(height: 24,),
              Container(
                margin: EdgeInsets.only(left: 16),
                height: 52,
                width: 271,
                child: Text('Satisfy your cravings',
                  style: blackTextStyle.copyWith(
                      fontSize: 22,
                      fontWeight: FontWeight.w700
                  ),
                ),
              ),
              SizedBox(height: 13,),
              Container(
                margin: EdgeInsets.only(left: 16),
                height: 58,
                width: 328,
                child: Text('Get amazing meals to excite your taste buds.',
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
