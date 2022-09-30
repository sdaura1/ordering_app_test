import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ordering_app/screens/SuccessScreen.dart';

import '../functions/APICalls.dart';
import '../functions/DatabaseHelper.dart';
import '../models/CartModel.dart';
import '../models/CategoryModel.dart';
import '../models/OrderItemModel.dart';
import '../screens/MainScreen.dart';
import '../utils/Constants.dart';
import '../utils/SharedPref.dart';

class PickupCheckOut extends StatefulWidget {

  final List<CartModel> items;
  final double total;

  PickupCheckOut({
    required this.items,
    required this.total
  });

  @override
  _PickupCheckOutState createState() => _PickupCheckOutState();
}

class _PickupCheckOutState extends State<PickupCheckOut> {

  double total = 0.0, deliveryFee = 0.0, takeAwayPackFee = 0.0,
      serviceFee = 0.0, vat = 0.075;
  int quantity = 0;
  bool isLoading = false;
  String? orderReference;
  late APiCalls aPiCalls;
  var orderItems = [];
  List<CartModel> items = [];
  List<CategoryModel> categoryList = [];
  final dbHelper = DatabaseHelper.instance;

  @override
  void initState() {
    super.initState();
    getInformation().whenComplete(() {
      setState((){});
    });
  }

  Future<void> getInformation() async {
    aPiCalls = APiCalls();
    await aPiCalls.getCategoryList().then((value) async {
      categoryList.clear();
      var categories = await jsonDecode(value.body)['data'];
      for (var category in categories) {
        setState(() {
          categoryList.add(CategoryModel.fromJson(category));
        });
      }
    });
    await _query();
  }

  makeOrder() async {
    setState(() => isLoading = true);
    await aPiCalls.makeOrder(total, "Pick-up",
        "Pick-up", "Bank Transfer", "none", "none", orderItems)
        .then((value) async {
      if(value.statusCode == 200 && jsonDecode(value.body)['code'] == 200) {
        setState(() => isLoading = false);
        orderReference = jsonDecode(value.body)['data']['reference'];
        SharedPref.setReference(orderReference!);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => const SuccessScreen()
          ),
        );
      }else {
        setState(() => isLoading = false);
        SharedPref.clear().then((value) => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => MainScreen(destination: 2, fromCart: true),
          ),
        ));
      }
    });
  }

  Future<void> _query() async {
    final allRows = await dbHelper.queryAllRows();
    items.clear();
    orderItems.clear();
    allRows.forEach((element) {
      var cartItem = CartModel.fromJson(element);
      quantity += cartItem.quantity;
      total += (cartItem.price * cartItem.quantity);
      serviceFee = cartItem.serviceFee;
      takeAwayPackFee += cartItem.quantity * cartItem.packageAmount;
      setState(() {
        items.add(cartItem);
        orderItems.add(
            OrderItemModel(
                foodId: cartItem.id.toString(),
                quantity: int.parse(cartItem.quantity.toString())
            ).toJson()
        );
      });
    });
    total += (total * 0.075) + takeAwayPackFee + serviceFee;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Restaurant Address',
            style: blackTextStyle.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 3,),
          Text('123 Lamido Crescent, Kano.',
            style: blackTextStyle.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: hexToColor(textGreyColor)
            ),
          ),
          SizedBox(height: 16,),
          Text('Opening Hours',
            style: blackTextStyle.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 3,),
          Text('Mon - Sat : 11:00am - 11:00pm',
            style: blackTextStyle.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: hexToColor(textGreyColor)
            ),
          ),
          SizedBox(height: 5,),
          Text('Sundays : 1:00pm - 11:00pm',
            style: blackTextStyle.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: hexToColor(textGreyColor)
            ),
          ),
          SizedBox(height: 19,),
          Text('Contact',
            style: blackTextStyle.copyWith(
              fontSize: 12,
              color: hexToColor(orangeColor),
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 2,),
          Text('0913 428 5000',
            style: blackTextStyle.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: hexToColor(textGreyColor)
            ),
          ),
          !isLoading ? Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
                color: Colors.black
            ),
            width: double.infinity,
            margin: EdgeInsets.only(top: 140,),
            child: MaterialButton(
              onPressed: () async {
                await makeOrder();
              },
              child: Text('Place Order',
                  style: blackTextStyle.copyWith(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500
                  )
              ),
            ),
          ) : Center(
            child: Container(
              margin: EdgeInsets.only(top: 150),
              child: CircularProgressIndicator(
                color: hexToColor(orangeColor),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
