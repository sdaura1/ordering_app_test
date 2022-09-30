import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:ordering_app/utils/Constants.dart';
import 'package:ordering_app/functions/DatabaseHelper.dart';
import 'package:ordering_app/models/FoodModel.dart';

import 'Basket.dart';

class DetailedView extends StatefulWidget {

  final FoodModel foodModel;

  const DetailedView({Key? key, required this.foodModel}) : super(key: key);

  @override
  DetailedViewState createState() => DetailedViewState();
}

class DetailedViewState extends State<DetailedView> {

  final dbHelper = DatabaseHelper.instance;
  var quantity = 1;

  _insertToCart(FoodModel foodModel) async {
    Map<String, dynamic> row = {
      DatabaseHelper.columnId : foodModel.id,
      DatabaseHelper.columnFoodName : foodModel.name,
      DatabaseHelper.columnFoodPrice : foodModel.price.toString(),
      DatabaseHelper.columnDeliveryFee : foodModel.deliveryFee.toString(),
      DatabaseHelper.columnPackageAmount : foodModel.packageAmount.toString(),
      DatabaseHelper.columnServiceFee : foodModel.serviceFee.toString(),
      DatabaseHelper.columnFoodDescription : "Description",
      DatabaseHelper.columnFoodImageUrl : foodModel.imageUrl,
      DatabaseHelper.columnFoodStatus : foodModel.status,
      DatabaseHelper.columnFoodCategory : foodModel.categoryId,
      DatabaseHelper.columnFoodCreatedAt : foodModel.createdAt,
      DatabaseHelper.columnWaitingTime : foodModel.waitingTime,
      DatabaseHelper.columnQty : quantity,
    };
    dbHelper.insert(row);
  }

  @override
  Widget build(BuildContext context) {
    Uint8List base64 = const Base64Decoder().convert(widget.foodModel.imageUrl);
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: Opacity(
            opacity: 0.5,
            child: Center(
              child: Container(
                  decoration: BoxDecoration(
                    color: hexToColor(dividerGreyColor),
                    shape: BoxShape.circle,
                  ),
                  margin: const EdgeInsets.only(bottom: 14, top: 10, right: 4, left: 4),
                  padding: const EdgeInsets.only(left: 4),
                  child: Center(
                    child: IconButton(
                      alignment: Alignment.center,
                      iconSize: 15,
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: hexToColor(orangeColor),
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  )
              ),
            ),
          ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 40),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            color: hexToColor(orangeColor)
        ),
        width: double.infinity,
        height: 60,
        child: MaterialButton(
          onPressed: () async {
            await _insertToCart(widget.foodModel);
            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Basket()));
          },
          child: quantity > 0 ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Add to Basket',
                  style: blackTextStyle.copyWith(
                    color: Colors.white,
                    fontSize: 14,
                  )
              ),
              Text('N${formatter.format(quantity * widget.foodModel.price)}',
                  style: blackTextStyle.copyWith(
                    color: Colors.white,
                    fontSize: 14,
                  )
              ),
            ],
          ) : Text('Add to Cart',
              style: blackTextStyle.copyWith(
                color: Colors.white,
                fontSize: 14,
              )
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 200,
              child: widget.foodModel.imageUrl.isEmpty ? const Hero(
                tag: 'foodImage',
                child: Image(
                  image: AssetImage(
                      "images/placeholder.png"
                  ),
                  fit: BoxFit.cover,
                  filterQuality: FilterQuality.high,
                ),
              ) : Hero(
                tag: 'foodImage',
                child: Image.memory(
                  base64,
                  fit: BoxFit.cover,
                  filterQuality: FilterQuality.high,
                ),
              ),
            ),
            Flexible(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(
                          top: 32,
                          bottom: 10,
                          right: 15,
                          left: 15
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SizedBox(
                            width: 200,
                            child: Text(
                              widget.foodModel.name,
                              maxLines: 2,
                              style: blackTextStyle,
                            ),
                          ),
                          Text("N${formatter.format(widget.foodModel.price.toInt())}",
                              style: blackTextStyle
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      endIndent: 16,
                      indent: 16,
                      thickness: 1,
                      color: hexToColor(dividerGreyColor),
                      height: 0.5,
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                          right: 15,
                          left: 15,
                          top: 13,
                          bottom: 23
                      ),
                      child: Text(widget.foodModel.description,
                          style: blackTextStyle.copyWith(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: hexToColor(textGreyColor)
                          )
                      ),
                    ),
                    Divider(
                      endIndent: 16,
                      indent: 16,
                      thickness: 1,
                      color: hexToColor(dividerGreyColor),
                      height: 1,
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                          left: 15,
                          right: 15,
                          top: 14,
                          bottom: 88
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                height: 32,
                                width: 32,
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(Radius.circular(4)),
                                    color: hexToColor(dividerGreyColor)
                                ),
                                child: MaterialButton(
                                    onPressed: (){
                                      setState(() {
                                        if(quantity > 1) {
                                          quantity -= 1;
                                        }
                                      });
                                    },
                                    child: Center(
                                      child: Text('-',
                                        textAlign: TextAlign.center,
                                        style: blackTextStyle.copyWith(
                                            fontSize: 12
                                        ),
                                      ),
                                    )
                                ),
                              ),
                              const SizedBox(width: 8,),
                              Text(quantity.toString(),
                                style: blackTextStyle.copyWith(
                                    fontSize: 12
                                ),
                              ),
                              const SizedBox(width: 8,),
                              Container(
                                height: 32,
                                width: 32,
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(Radius.circular(4)),
                                    color: hexToColor(dividerGreyColor)
                                ),
                                child: MaterialButton(
                                    onPressed: (){
                                      setState(() {
                                        quantity += 1;
                                      });
                                    },
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
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
