import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ordering_app/components/FoodItem.dart';
import 'package:ordering_app/utils/Constants.dart';
import 'package:ordering_app/components/SearchView.dart';
import 'package:ordering_app/functions/APICalls.dart';
import 'package:ordering_app/functions/DatabaseHelper.dart';
import 'package:ordering_app/models/CategoryModel.dart';
import 'package:ordering_app/models/FoodModel.dart';
import 'package:ordering_app/components/CategoryView.dart';
import 'package:ordering_app/screens/DetailedView.dart';
import 'package:ordering_app/screens/Popular.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

import 'Cart.dart';

class Home extends StatefulWidget {

  Home();

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin, WidgetsBindingObserver{

  bool isLoading = false;
  var categoryId;
  var currentIndex = 0;
  int cartCount = 0;
  late TabController _controller;
  late APiCalls aPiCalls;
  List<FoodModel> _foodItems = [];
  List<FoodModel> _popularFoodItems = [];
  List<CategoryModel> categoryList = [];
  final dbHelper = DatabaseHelper.instance;
  final TextEditingController _searchController = TextEditingController();

  _query() async {
    cartCount = (await dbHelper.queryRowCount())!;
  }

  getFoodByCategory() async {
    await aPiCalls.getFoodByCategory(categoryList[0]).then((value) async {
      if (value.statusCode == 200 && jsonDecode(value.body)['code'] == 200) {
        setState(() => isLoading = false);
        var foodItems = await jsonDecode(value.body)['data'];
        for (var foodItem in foodItems) {
          if(FoodModel.fromJson(foodItem).isActive) {
            setState(() => _foodItems.add(FoodModel.fromJson(foodItem)));
          }
        }
      }else {
        setState(() => isLoading = false);
      }
    });
  }

  getCategoryList() async {
    await aPiCalls.getCategoryList().then((value) async {
      if(value.statusCode == 200 && jsonDecode(value.body)['code'] == 200) {
        categoryList.clear();
        var categories = await jsonDecode(value.body)['data'];
        for (var category in categories) {
          if(this.mounted) {
            setState(() => categoryList.add(CategoryModel.fromJson(category)));
          }
        }
        _controller = TabController(length: categoryList.length, vsync: this);
        _controller.addListener(() => setState(() => currentIndex = _controller.index));
      }else {
        if(this.mounted) {
          setState(() => isLoading = false);
        }
      }
    });
  }

  getPopularMeals() async {
    if(this.mounted) {
      setState(() => isLoading = true);
    }
    aPiCalls.getPopularMeals().then((value) async {
      if(value.statusCode == 200 && jsonDecode(value.body)['code'] == 200) {
        _popularFoodItems.clear();
        var foodItems = await jsonDecode(value.body)['data'];
        for (var foodItem in foodItems) {
          if(FoodModel.fromJson(foodItem).isActive) {
            if (this.mounted) {
              setState(() =>
                  _popularFoodItems.add(FoodModel.fromJson(foodItem)));
            }
          }
        }
      }else {
        if(this.mounted) {
          setState(() => isLoading = false);
        }
      }
      await getCategoryList();
      await getFoodByCategory();

      if(this.mounted) {
        setState(() => isLoading = false);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    isLoading = false;
    aPiCalls = APiCalls();
    getPopularMeals();
    _query();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state){
    if(state == AppLifecycleState.resumed){
      isLoading = false;
      aPiCalls = APiCalls();
      getPopularMeals();
      _query();
    }else{
      _query();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _query();
    return SafeArea(
      child: !isLoading ? SingleChildScrollView(
        child: Column(
            children: [
              Stack(
                clipBehavior: Clip.none,
                fit: StackFit.passthrough,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: hexToColor(blackColor),
                    ),
                    height: 215,
                    width: double.infinity,
                  ),
                  Positioned(
                    top: 10,
                    right: 15,
                    child: GestureDetector(
                      onTap: () => Navigator.push(context, MaterialPageRoute(
                          builder: (BuildContext context) => Cart()),
                      ),
                      child: Stack(
                          children: [
                            SvgPicture.asset(
                                'images/cart.svg',
                                height: 22,
                                width: 22,
                                color: Colors.white,
                                fit: BoxFit.scaleDown
                            ),
                            cartCount > 0 ? Positioned(
                                left: 16,
                                child: Icon(
                                  Icons.brightness_1,
                                  color: hexToColor(redColor),
                                  size: 8,
                                )
                            ) : Container(),
                          ]
                      ),
                    ),
                  ),
                  Positioned(
                    left: 18,
                    top: 73,
                    right: 94,
                    child: Text(
                      "What do you want to eat today?",
                      style: blackTextStyle.copyWith(
                          fontFamily: fontFamily,
                          fontWeight: FontWeight.w700,
                          fontSize: 28,
                          color: Colors.white
                      ),
                    ),
                  ),
                  Positioned(
                    top: 174,
                    right: 15,
                    left: 12,
                    child: Container(
                      width: 328,
                      height: 60,
                      child: Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0)
                        ),
                        child: TextField(
                          controller: _searchController,
                          textCapitalization: TextCapitalization.words,
                          onSubmitted: (searchText) => Navigator.push(context,
                            MaterialPageRoute(
                              builder: (BuildContext context) => SearchView(searchParam: searchText,),
                            ),
                          ),
                          keyboardType: TextInputType.name,
                          obscureText: false,
                          textAlignVertical: TextAlignVertical.center,
                          textAlign: TextAlign.start,
                          cursorColor: hexToColor(blackColor),
                          decoration: InputDecoration(
                            hintText: FocusNode().hasFocus ? '' : 'Search Meals',
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: hexToColor(dividerGreyColor),
                                  width: 0.0
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: hexToColor(dividerGreyColor),
                                  width: 0.0
                              ),
                            ),
                            border: OutlineInputBorder(),
                            labelStyle: blackTextStyle.copyWith(
                                color: FocusNode().hasFocus ? Colors.white : hexToColor(textGreyColor),
                                fontWeight: FontWeight.w400,
                                fontSize: 14
                            ),
                            prefixIcon: SvgPicture.asset(
                                'images/search.svg',
                                height: 20,
                                width: 20,
                                fit: BoxFit.scaleDown
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              _popularFoodItems.length > 0 ? Container(
                margin: EdgeInsets.only(
                    top: 30.0,
                    right: 19.0,
                    left: 17.0,
                    bottom: 15.0
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Popular Meals",
                      style: blackTextStyle.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w600
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (BuildContext context) => PopularFood()),
                      ),
                      child: Text("View All".toUpperCase(),
                        style: blackTextStyle.copyWith(
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                            color: hexToColor(textGreyColor)
                        ),
                      ),
                    ),
                  ],
                ),
              ) : Center(child: CircularProgressIndicator(color: hexToColor(blackColor),),),
              _popularFoodItems.length > 0 ? Container(
                margin: EdgeInsets.only(
                  top: 4,
                  left: 16,
                  // right: 16,
                ),
                height: 195,
                child: ListView.builder(
                  itemCount: _popularFoodItems.length,
                  itemBuilder: (context, index) {
                    var foodModel = _popularFoodItems[index];
                    foodModel.description = "";
                    return FoodItem(
                      foodModel: foodModel,
                      onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (BuildContext context) => DetailedView(foodModel: foodModel),
                        ),
                      ),
                    );
                  },
                  scrollDirection: Axis.horizontal,
                ),
              ): Center(child: CircularProgressIndicator(color: hexToColor(blackColor),),),
              categoryList.isNotEmpty ? Container(
                  margin: EdgeInsets.only(
                    left: 16.0,
                    right: 16.0,
                  ),
                  child: DefaultTabController(
                    initialIndex: 0,
                    length: categoryList.length,
                    child: TabBar(
                        isScrollable: true,
                        unselectedLabelStyle: blackTextStyle.copyWith(
                            color: hexToColor(textGreyColor),
                            fontWeight: FontWeight.w400,
                            fontSize: 12
                        ),
                        indicatorSize: TabBarIndicatorSize.tab,
                        unselectedLabelColor: hexToColor(textGreyColor),
                        labelColor: hexToColor(blackColor),
                        labelStyle: blackTextStyle.copyWith(
                            fontWeight: FontWeight.w400,
                            fontSize: 12
                        ),
                        indicatorColor: hexToColor(blackColor),
                        onTap: (index) =>
                            setState(() {
                              currentIndex = index;
                              categoryId = categoryList[index].id;
                            }),
                        controller: _controller,
                        indicator: MaterialIndicator(
                            color: hexToColor(blackColor),
                            height: 4,
                            topLeftRadius: 10,
                            topRightRadius: 10,
                            horizontalPadding: 0,
                            tabPosition: TabPosition.bottom,
                            strokeWidth: 6
                        ),
                        tabs: categoryList.map((e) =>
                            Container(
                              height: 40.0,
                              child: Tab(
                                child: Text(
                                  e.name,
                                  softWrap: false,
                                ),
                              ),
                            )).toList()
                    ),
                  )
              ) : Center(child: CircularProgressIndicator(color: hexToColor(blackColor),),),
              categoryList.isNotEmpty ? Container(
                margin: EdgeInsets.only(
                    top: 30.0,
                    right: 19.0,
                    left: 17.0,
                    bottom: 15.0
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      categoryList[currentIndex].name,
                      style: blackTextStyle.copyWith(
                          fontSize: 14
                      ),
                    ),
                    GestureDetector(
                      onTap: () =>
                          Navigator.push(context,
                            MaterialPageRoute(
                              builder: (context) => CategoryView(
                                isPage: true,
                                categoryId: categoryList[currentIndex].id,
                                categoryName: categoryList[currentIndex].name,
                              ),
                            ),
                          ),
                      child: Text("View All".toUpperCase(),
                        style: blackTextStyle.copyWith(
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                            color: hexToColor(textGreyColor)
                        ),
                      ),
                    ),
                  ],
                ),
              ) : Container(
                height: 10,
                margin: EdgeInsets.only(
                    left: 16.0,
                    top: 24.0,
                    right: 13.0,
                    bottom: 8.0
                ),),
              SizedBox(height: 14,),
              Container(
                height: 1250,
                margin: EdgeInsets.only(
                  left: 17.0,
                ),
                padding: EdgeInsets.only(bottom: 16),
                child: TabBarView(
                    controller: _controller,
                    children: categoryList.map((e) =>
                        CategoryView(
                            categoryId: e.id,
                            categoryName: e.name,
                            isPage: false
                        )
                    ).toList()
                ),
              ),
            ]
        ),
      ) : Center(
        child: CircularProgressIndicator(
          color: hexToColor(blackColor),
        ),
      ),
    );
  }
}