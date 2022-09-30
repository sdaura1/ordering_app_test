import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../models/FoodModel.dart';
import '../utils/Constants.dart';

class FoodItem extends StatelessWidget {

  const FoodItem({
    Key? key,
    required this.foodModel,
    required this.onTap
  }) : super(key: key);

  final FoodModel foodModel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    Uint8List base64 = const Base64Decoder().convert(foodModel.imageUrl);
    return SizedBox(
      height: 100,
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(
              color: hexToColor(orangeColor).withOpacity(.2),
              width: 0.3
            )
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                    child: Stack(
                        children: [
                          foodModel.imageUrl.isEmpty ? const SizedBox(
                            height: 88,
                            width: 88,
                            child: Icon(FontAwesomeIcons.utensils, size: 50, color: Colors.grey)
                          ) : Image.memory(
                            base64,
                            fit: BoxFit.cover,
                            height: 100,
                            width: 100,
                            filterQuality: FilterQuality.high
                          ),
                        ]
                    ),
                  ),
                  const SizedBox(height: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Text(
                          foodModel.name, style: blackTextStyle.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          color: Colors.black
                        ),
                          maxLines: 2
                        ),
                      ),
                      const SizedBox(height: 2),
                      foodModel.description.isNotEmpty ?
                      Container(
                          width: 152,
                          margin: const EdgeInsets.only(bottom: 15),
                          child: Text(
                            foodModel.description,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                            style: blackTextStyle.copyWith(
                                fontSize: 12,
                                color: hexToColor(textGreyColor),
                                fontWeight: FontWeight.w400
                            ),
                          )
                      ) : const Text(""),
                      Container(
                        margin: const EdgeInsets.only(top: 10),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(14.0)),
                          color: Colors.white,
                        ),
                        child: Text(
                            Platform.isAndroid ? "₦${formatter.format(foodModel.price.toInt())}" : "N${formatter.format(foodModel.price.toInt())}",
                          style: blackTextStyle.copyWith(
                            fontSize: 14,
                            color: hexToColor(orangeColor)
                          ),
                        ),
                      ),
                    ],
                  )
                ]
            ),
          ),
        ),
      ),
    );
  }
}
