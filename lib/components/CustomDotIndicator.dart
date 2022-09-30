import 'package:flutter/material.dart';

import '../utils/Constants.dart';

class CustomDotIndicator extends StatelessWidget {
  
  final isOne;
  CustomDotIndicator({
    Key? key,
    required this.isOne
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isOne ? Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
              color: hexToColor(orangeColor),
              borderRadius: BorderRadius.all(Radius.circular(4))
          ),
          height: 8.0,
          width: 32.0,
        ),
        SizedBox(width: 8),
        Container(
          decoration: BoxDecoration(
              color: hexToColor(dividerGreyColor),
              borderRadius: BorderRadius.all(Radius.circular(4))
          ),
          height: 8.0,
          width: 8.0,
        ),
      ],
    ) : Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
              color: hexToColor(dividerGreyColor),
              borderRadius: BorderRadius.all(Radius.circular(4))
          ),
          height: 8.0,
          width: 8.0,
        ),
        SizedBox(width: 8,),
        Container(
          decoration: BoxDecoration(
              color: hexToColor(orangeColor),
              borderRadius: BorderRadius.all(Radius.circular(4))
          ),
          height: 8.0,
          width: 32.0,
        ),
      ],
    );
  }
}
