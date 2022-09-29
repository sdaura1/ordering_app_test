import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../models/FoodModel.dart';
import '../utils/Constants.dart';

class FoodItem extends StatelessWidget {

  FoodItem({
    required this.foodModel,
    required this.onTap
  });

  final FoodModel foodModel;
  final onTap;

  @override
  Widget build(BuildContext context) {
    Uint8List base64 = const Base64Decoder().convert(foodModel.imageUrl);
    return Container(
      height: 260,
      padding: const EdgeInsets.only(right: 16.0, left: 0.0, top: 0.0, bottom: 0.0),
      child: GestureDetector(
        onTap: onTap,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.all(const Radius.circular(4.0)),
                child: Stack(
                    children: [
                      foodModel.imageUrl.isEmpty ? const SizedBox(
                        height: 128,
                        width: 152,
                      ) : Image.memory(
                        base64,
                        fit: BoxFit.cover,
                        height: 128,
                        width: 152,
                        filterQuality: FilterQuality.high,
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 12, top: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 12.67, vertical: 7.08),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(14.0)),
                          color: Colors.white,
                        ),
                        child: Text(
                          "N${formatter.format(foodModel.price.toInt())}",
                          style: blackTextStyle.copyWith(
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Positioned(
                          top: 74,
                          child: Container(
                              height: 80,
                              width: 152,
                              child: Container(
                                // color: Colors.black.withOpacity(.3),
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                        begin: FractionalOffset.topCenter,
                                        end: FractionalOffset.bottomCenter,
                                        colors: [
                                          Colors.transparent.withOpacity(.03),
                                          Colors.transparent.withOpacity(.5),
                                          Colors.black.withOpacity(.5)
                                        ]
                                    )
                                ),
                              )
                          )
                      ),
                    ]
                ),
              ),
              SizedBox(height: 4,),
              Container(
                width: 138,
                child: Text(
                  foodModel.name, style: blackTextStyle.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w400
                ),
                  maxLines: 2,
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
                    maxLines: 2,
                    style: blackTextStyle.copyWith(
                        fontSize: 10,
                        color: hexToColor(textGreyColor),
                        fontWeight: FontWeight.w400
                    ),
                  )
              ) : const Text(""),
            ]
        ),
      ),
    );
  }
}
