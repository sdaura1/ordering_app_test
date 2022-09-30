import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../models/FoodModel.dart';
import '../utils/Constants.dart';

class SearchItem extends StatefulWidget {
  const SearchItem({
    required this.item,
    required this.onTap
  });

  final FoodModel item;
  final onTap;

  @override
  _SearchItemState createState() => _SearchItemState();

}

class _SearchItemState extends State<SearchItem> {
  @override
  Widget build(BuildContext context) {
    Uint8List _base64 = Base64Decoder().convert(widget.item.imageUrl);
    return Container(
      margin: EdgeInsets.only(top: 20, left: 17, right: 17, bottom: 20),
      child: Row(
        children: [
          GestureDetector(
            onTap: widget.onTap,
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(4.0)),
              child: widget.item.imageUrl.isEmpty ? const Image(
                fit: BoxFit.cover,
                height: 48,
                width: 48,
                filterQuality: FilterQuality.high,
                image: AssetImage(
                    'images/placeholder.png'
                ),
              ) : Image.memory(
                _base64,
                fit: BoxFit.cover,
                height: 48,
                width: 48,
                filterQuality: FilterQuality.high,
              ),
            ),
          ),
          SizedBox(width: 14,),
          GestureDetector(
            onTap: widget.onTap,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 200,
                  child: Text(widget.item.name,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: blackTextStyle.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w400
                    ),
                    softWrap: false,
                  ),
                ),
                SizedBox(height: 9,),
                Text('N${formatter.format(widget.item.price.toInt())}',
                  style: blackTextStyle.copyWith(
                      color: hexToColor(orangeColor),
                      fontWeight: FontWeight.w700,
                      fontSize: 14
                  ),
                ),
              ],
            ),
          ),
          Spacer(),
          GestureDetector(
            onTap: widget.onTap,
            child: Container(
              margin: EdgeInsets.only(right: 0),
                child: SvgPicture.asset('images/vector.svg')
            ),
          )
        ],
      ),
    );
  }
}
