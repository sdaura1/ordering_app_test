import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/Constants.dart';

class LegalItem extends StatelessWidget {

  LegalItem({
    required this.heading,
    required this.content
  });

  final String heading;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(left: 16, right: 16, bottom: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 240,
              child: Text(heading,
                style: blackTextStyle.copyWith(
                    color: hexToColor(blackColor),
                    fontSize: 18,
                    fontWeight: FontWeight.w700
                ),
                maxLines: 2,
                softWrap: true,
              ),
            ),
            SizedBox(height: 24,),
            Container(
              child: Text(content,
                textAlign: TextAlign.justify,
                style: blackTextStyle.copyWith(
                  color: hexToColor(textEmailColor),
                    fontSize: 14,
                    fontWeight: FontWeight.w400
                ),
                softWrap: true,
              ),
            ),
          ],
        )
    );
  }
}