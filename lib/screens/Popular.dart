import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ordering_app/components/FoodItem.dart';
import 'package:ordering_app/functions/APICalls.dart';
import 'package:ordering_app/models/FoodModel.dart';

import '../utils/Constants.dart';
import 'DetailedView.dart';

class PopularFood extends StatefulWidget {

  PopularFood();

  @override
  _PopularFoodState createState() => _PopularFoodState();
}

class _PopularFoodState extends State<PopularFood> {

  late APiCalls aPiCalls;
  List<FoodModel> _foodItems = [];
  var categoryId;

  getInformation() async {
    aPiCalls.getPopularMeals().then((value) async {
      var foodItems = await jsonDecode(value.body)["data"];
      for(var foodItem in foodItems){
        setState(() {
          _foodItems.add(FoodModel.fromJson(foodItem));
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    aPiCalls = APiCalls();
    getInformation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          iconSize: 20,
          icon: Icon(
            Icons.arrow_back_ios,
            color: hexToColor(orangeColor),
          ),
        ),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text('Popular Meals',
          style: blackTextStyle.copyWith(
            fontSize: 16,
          ),),
      ),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.only(left: 16, top: 16, bottom: 16),
          child: _foodItems.length > 0 ? GridView.builder(
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: MediaQuery.of(context).size.width > 600 ? 200 : 250,
                childAspectRatio: MediaQuery.of(context).size.width > 600 ? .8 : .8,
                mainAxisSpacing: 0.3,
                crossAxisSpacing: MediaQuery.of(context).size.width > 600 ? 1 : 10,
              ),
              shrinkWrap: true,
              itemCount: _foodItems.length,
              itemBuilder: (BuildContext context, int index) {
                var foodModel = _foodItems[index];
                return FoodItem(
                  foodModel: foodModel,
                  onTap: () =>
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => DetailedView(foodModel: foodModel),
                      ),
                    )
                );
              }) : Center(
            child: CircularProgressIndicator(
              color: hexToColor(orangeColor),
            ),
          ),
        ),
      ),
    );
  }
}
