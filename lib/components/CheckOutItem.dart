import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';

import '../models/CartModel.dart';
import '../utils/Constants.dart';

class CheckOutItem extends StatefulWidget {

  CheckOutItem({
    Key? key,
    required this.item,
  }) : super(key: key);

  final CartModel item;

  @override
  _CheckOutItemState createState() => _CheckOutItemState();

}

class _CheckOutItemState extends State<CheckOutItem> {

  @override
  Widget build(BuildContext context) {

    Uint8List _base64 = Base64Decoder().convert(widget.item.imageUrl);

    return Container(
      margin: EdgeInsets.only(top: 20, left: 10, right: 8, bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(4.0)),
            child: widget.item.imageUrl.isEmpty ? const Image(
              fit: BoxFit.cover,
              height: 88,
              width: 88,
              filterQuality: FilterQuality.high,
              image: AssetImage(
                  'images/placeholder.png'
              ),
            ) : Image.memory(
              _base64,
              fit: BoxFit.cover,
              height: 88,
              width: 88,
              filterQuality: FilterQuality.high,
            ),
          ),
          SizedBox(width: 10,),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 100,
                child: Text(widget.item.name,
                  style: blackTextStyle.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w400
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  softWrap: true,
                ),
              ),
              SizedBox(height: 9,),
              Text('x ${widget.item.quantity.toString()}',
                style: blackTextStyle.copyWith(
                    fontSize: 12,
                  color: hexToColor(blackColor),
                  fontWeight: FontWeight.w500
                ),
              )
            ],
          ),
          Spacer(),
          Text('N${formatter.format(widget.item.price)}',
            style: blackTextStyle.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w500
            ),
          ),
        ],
      ),
    );
  }
}
