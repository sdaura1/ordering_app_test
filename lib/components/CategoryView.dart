import 'dart:convert';

import 'package:flutter/material.dart';
import '../functions/APICalls.dart';
import '../models/FoodModel.dart';
import '../utils/Constants.dart';
import '../screens/DetailedView.dart';
import 'FoodItem.dart';

class CategoryView extends StatefulWidget {

  final String categoryId;
  final String categoryName;
  final bool isPage;

  const CategoryView({
    Key? key,
    required this.categoryId,
    required this.categoryName,
    required this.isPage
  }): super(key: key);

  @override
  CategoryViewState createState() => CategoryViewState();
}

class CategoryViewState extends State<CategoryView> {

  late APiCalls aPiCalls;
  final List<FoodModel> _foodItems = [];
  String description = "";
  bool isLoading = false;

  getFoodByCategory() async {
    aPiCalls = APiCalls();
    await aPiCalls.getFoodByCategory(widget.categoryId).then((value) async {
      if(value.statusCode == 200) {
        var foodItems = await jsonDecode(value.body)['data'];
        for (var foodItem in foodItems) {
          setState(() => _foodItems.add(FoodModel.fromJson(foodItem)));
        }
      }else {
        setState((){
          description = jsonDecode(value.body)['data'].toString();
          _foodItems.length = -1;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getFoodByCategory();
  }

  @override
  Widget build(BuildContext context) {
    return !widget.isPage ? Flexible(
      child: Container(
        padding: const EdgeInsets.only(right: 16),
        child: !isLoading ? _foodItems.isNotEmpty ? ListView.builder(
            physics: const ClampingScrollPhysics(),
            shrinkWrap: false,
            itemCount: _foodItems.length,
            itemBuilder: (BuildContext context, int index) {
              var foodModel = _foodItems[index];
              return FoodItem(
                  foodModel: foodModel,
                  onTap: () =>
                      Navigator.push(context,
                        MaterialPageRoute(builder: (BuildContext context) =>
                            DetailedView(foodModel: foodModel),
                        ),
                      )
              );
            }
        ) : Center(
          child: Text(
            "Content not available",
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: blackTextStyle.copyWith(
                fontSize: 14,
                color: hexToColor(textGreyColor),
                fontWeight: FontWeight.w300
            ),
          ),
        ) : Stack(
            children: [
              Positioned(
                left: 120,
                top: 20,
                child: CircularProgressIndicator(
                  strokeWidth: .5,
                  color: hexToColor(orangeColor),
                ),),
            ]
        ),
      ),
    ) : Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          iconSize: 20,
          icon: Icon(
            Icons.arrow_back_ios,
            color: hexToColor(orangeColor),
          ),
        ),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(widget.categoryName,
          style: blackTextStyle.copyWith(
            fontSize: 16,
          ),),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.only(left: 16, right:16),
              child: !isLoading ? _foodItems.isNotEmpty ? ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
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
                  }
              ): Center(
                child: Text(
                  "Content not available",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: blackTextStyle.copyWith(
                      fontSize: 14,
                      color: hexToColor(textGreyColor),
                      fontWeight: FontWeight.w300
                  ),
                ),
              ) : Center(
                child: CircularProgressIndicator(
                  color: hexToColor(orangeColor),
                ),
              ),
            ),
          )
      ),
    );
  }
}
