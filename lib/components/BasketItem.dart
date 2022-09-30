import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ordering_app/functions/DatabaseHelper.dart';
import 'package:ordering_app/models/CartModel.dart';

import '../utils/Constants.dart';

class CartItem extends StatefulWidget {
  const CartItem({
    Key? key,
    required this.item,
    required this.addQty,
    required this.subtractQty,
    required this.changeQuantity,
    required this.remove,
    required this.checkout
  }) : super(key: key);

  final bool checkout;
  final remove;
  final addQty;
  final subtractQty;
  final changeQuantity;
  final CartModel item;

  @override
  CartItemState createState() => CartItemState();

}

class CartItemState extends State<CartItem> {

  final dbHelper = DatabaseHelper.instance;
  TextEditingController quantityController = TextEditingController();
  bool textFieldError = false;

  @override
  Widget build(BuildContext context) {
    Uint8List base64 = const Base64Decoder().convert(widget.item.imageUrl);
    quantityController.text = widget.item.quantity.toString();
    quantityController.selection = TextSelection.fromPosition(TextPosition(offset: quantityController.text.length));
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: Flex(
        direction: Axis.horizontal,
        children: [
          Expanded(
          flex: 1,
          child: Row(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                child: widget.item.imageUrl.isEmpty ? const Icon(
                  FontAwesomeIcons.utensils,
                  size: 88,
                  color: Colors.grey
                ) : Image.memory(
                  base64,
                  // fit: BoxFit.cover,
                  height: 88,
                  width: 88,
                  filterQuality: FilterQuality.high,
                ),
              ),
              const SizedBox(width: 10),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 80,
                    child: Text(widget.item.name,
                      overflow: TextOverflow.ellipsis,
                      style: blackTextStyle.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w400
                      ),
                      maxLines: 2,
                      softWrap: true,
                    ),
                  ),
                  const SizedBox(height: 9,),
                  Text('N${formatter.format(widget.item.price)}',
                    style: blackTextStyle.copyWith(
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 15,),
                  !widget.checkout ? GestureDetector(
                    onTap: widget.remove,
                    child: Icon(
                      FontAwesomeIcons.trashCan,
                      size: 18,
                      color: hexToColor(redColor),
                    ),
                  ) : Text('x ${widget.item.quantity.toString()}',
                    style: blackTextStyle.copyWith(
                        fontSize: 12
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          color: hexToColor(dividerGreyColor)
                      ),
                      child: MaterialButton(
                          onPressed: widget.subtractQty,
                          child: Center(
                            child: Text('-',
                              textAlign: TextAlign.center,
                              style: blackTextStyle.copyWith(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500
                              ),
                            ),
                          )
                      ),
                    ),
                    SizedBox(width: 6,),
                    Container(
                      height: 32,
                      width: 60,
                      child: Center(
                        child: TextField(
                          controller: quantityController,
                          keyboardType: TextInputType.number,
                          textAlignVertical: TextAlignVertical.center,
                          obscureText: false,
                          textAlign: TextAlign.center,
                          autofocus: false,
                          cursorColor: hexToColor(orangeColor),
                          cursorWidth: 1.0,
                          decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: hexToColor(dividerGreyColor),
                                    width: 1.0
                                ),
                              ),
                              errorStyle: blackTextStyle.copyWith(
                                  fontSize: 8,
                                  height: .08,
                                  color: hexToColor(redColor)
                              ),
                              errorMaxLines: 1,
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: hexToColor(dividerGreyColor),
                                    width: 1.0
                                ),
                              ),
                              filled: true,
                              hintText: 'QTY',
                              errorText: quantityController.text.toString() == "QTY" ? "Quantity cannot be null" : null,
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 0,
                                      color: hexToColor(dividerGreyColor)
                                  ),
                                  borderRadius: BorderRadius.circular(4)
                              ),
                              fillColor: hexToColor(dividerGreyColor),
                              hintStyle: blackTextStyle.copyWith(
                                  color: hexToColor(textGreyColor),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400
                              ),
                              contentPadding: EdgeInsets.all(4)
                          ),
                          onChanged: widget.changeQuantity,
                        ),
                      ),
                    ),
                    SizedBox(width: 6,),
                    Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          color: hexToColor(dividerGreyColor)
                      ),
                      child: MaterialButton(
                          onPressed: widget.addQty,
                          child: Center(
                            child: Text('+',
                              textAlign: TextAlign.center,
                              style: blackTextStyle.copyWith(
                                  fontSize: 12
                              ),
                            ),
                          )
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ]
      ),
    );
  }
}
