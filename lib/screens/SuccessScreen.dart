import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ordering_app/utils/SharedPref.dart';

import '../utils/Constants.dart';
import 'MainScreen.dart';

class SuccessScreen extends StatefulWidget {
  const SuccessScreen({Key? key}) : super(key: key);

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 100),
              Center(
                child: Container(
                  height: 88,
                  width: 88,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: hexToColor(orangeColor).withOpacity(.3),
                  ),
                  child: Container(
                    height: 50.29,
                    width: 50.29,
                    margin: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: hexToColor(orangeColor),
                    ),
                    child: SvgPicture.asset(
                        'images/single_check.svg',
                        height: 20,
                        width: 20,
                        fit: BoxFit.scaleDown
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 36,),
              const Image(
                fit: BoxFit.cover,
                height: 46,
                width: 184,
                image: AssetImage(
                    'images/patoosh.png'
                ),
              ),
              const SizedBox(height: 26,),
              Text(
                  'Order Placed Successfully',
                  textAlign: TextAlign.center,
                  style: blackTextStyle.copyWith(
                      fontFamily: paymentFontFamily,
                      color: hexToColor(orangeColor),
                      fontSize: 20,
                      fontWeight: FontWeight.w700
                  )
              ),
              const SizedBox(height: 26,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: RichText(
                  textAlign: TextAlign.center,
                    text: TextSpan(
                  text: 'Your order ID is',
                    style: blackTextStyle.copyWith(
                        fontFamily: paymentFontFamily,
                        color: hexToColor(textGreyColor),
                        fontSize: 16,
                        fontWeight: FontWeight.w400
                    ),
                  children: [
                    TextSpan(
                        text: ' ${SharedPref.getReference()}.\n',
                        style: blackTextStyle.copyWith(
                            fontFamily: paymentFontFamily,
                            color: hexToColor(orangeColor),
                            fontSize: 18,
                            fontWeight: FontWeight.w500
                        ),
                    ),
                    TextSpan(
                      text: 'Keep it safe for confirmation',
                      style: blackTextStyle.copyWith(
                          fontFamily: paymentFontFamily,
                          color: hexToColor(textGreyColor),
                          fontSize: 16,
                          fontWeight: FontWeight.w400
                      ),
                    )
                  ]
                )),
              ),
              const SizedBox(height: 25),
              Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(4)),
                      color: hexToColor(orangeColor)
                  ),
                  width: 328,
                  height: 48,
                  child: MaterialButton(
                    height: 48,
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                          builder: (BuildContext context) => const MainScreen(
                            fromCart: false,
                            destination: 0,
                          )),
                          (ModalRoute.withName(Navigator.defaultRouteName))
                      );
                    },
                    child: Text('Go to Dashboard',
                        style: blackTextStyle.copyWith(
                            fontFamily: paymentFontFamily,
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500
                        )
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              SizedBox(
                width: 200,
                child: Text(
                    'Call 0913-428-5000 for enquiry',
                    textAlign: TextAlign.center,
                    style: blackTextStyle.copyWith(
                        fontFamily: paymentFontFamily,
                        color: hexToColor(orangeColor).withOpacity(.7),
                        fontSize: 14,
                        fontWeight: FontWeight.w400
                    )
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
