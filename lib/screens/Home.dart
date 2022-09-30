import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ordering_app/utils/Constants.dart';
import 'package:ordering_app/components/SearchView.dart';
import 'package:ordering_app/functions/APICalls.dart';
import 'package:ordering_app/functions/DatabaseHelper.dart';
import 'package:ordering_app/models/CategoryModel.dart';
import 'package:ordering_app/models/FoodModel.dart';
import 'package:ordering_app/components/CategoryView.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

import 'Basket.dart';

class Home extends StatefulWidget {

  const Home({Key? key}) : super(key: key);

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> with SingleTickerProviderStateMixin,
    WidgetsBindingObserver{

  bool isLoading = false;
  String categoryId = "";
  var currentIndex = 0;
  int cartCount = 0;
  late TabController _controller;
  late APiCalls aPiCalls;
  final List<FoodModel> _foodItems = [];
  final List<FoodModel> _popularFoodItems = [];
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
          if(mounted) {
            setState(() => categoryList.add(CategoryModel.fromJson(category)));
          }
        }
        _controller = TabController(length: categoryList.length, vsync: this);
        _controller.addListener(() => setState(() => currentIndex = _controller.index));
      }else {
        if(mounted) {
          setState(() => isLoading = false);
        }
      }

      await getFoodByCategory();
    });
  }

  getPopularMeals() async {
      setState(() => isLoading = true);
    aPiCalls.getPopularMeals().then((value) async {
      if(value.statusCode == 200 && jsonDecode(value.body)['code'] == 200) {
        _popularFoodItems.clear();
        var foodItems = await jsonDecode(value.body)['data'];
        for (var foodItem in foodItems) {
          if(FoodModel.fromJson(foodItem).isActive) {
            if (mounted) {
              setState(() =>
                  _popularFoodItems.add(FoodModel.fromJson(foodItem)));
            }
          }
        }
      }else {
        if(mounted) {
          setState(() => isLoading = false);
        }
      }
      await getCategoryList();
      await getFoodByCategory();

      if(mounted) {
        setState(() => isLoading = false);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    isLoading = false;
    aPiCalls = APiCalls();
    getCategoryList();
    _query();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state){
    if(state == AppLifecycleState.resumed){
      isLoading = false;
      aPiCalls = APiCalls();
      getCategoryList();
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
      child: !isLoading ? Container(
        color: Colors.grey[200],
        child: Column(
            children: [
              Stack(
                clipBehavior: Clip.none,
                fit: StackFit.passthrough,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: hexToColor(orangeColor),
                    ),
                    height: 100,
                    width: double.infinity,
                  ),
                  Positioned(
                    top: 25,
                    right: 15,
                    child: GestureDetector(
                      onTap: () => Navigator.push(context, MaterialPageRoute(
                          builder: (BuildContext context) => const Basket()),
                      ),
                      child: Stack(
                          children: [
                            const Icon(
                                FontAwesomeIcons.basketShopping,
                                size: 20,
                                color: Colors.white
                            ),
                            cartCount > 0 ? const Positioned(
                                left: 0,
                                top: 5,
                                child: Icon(
                                  Icons.brightness_1,
                                  color: Colors.black,
                                  size: 8,
                                )
                            ) : Container(),
                          ]
                      ),
                    ),
                  ),
                  Positioned(
                    left: 10,
                    top: 30,
                    right: 94,
                    child: Text(
                      "Food Ordering and Delivery",
                      style: blackTextStyle.copyWith(
                          fontFamily: fontFamily,
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                          color: Colors.white
                      ),
                    ),
                  ),
                  Positioned(
                    top: 70,
                    right: 15,
                    left: 12,
                    child: SizedBox(
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
                          cursorColor: hexToColor(orangeColor),
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
                            border: const OutlineInputBorder(),
                            labelStyle: blackTextStyle.copyWith(
                                color: FocusNode().hasFocus ? Colors.white : hexToColor(textGreyColor),
                                fontWeight: FontWeight.w400,
                                fontSize: 14
                            ),
                            prefixIcon: const Icon(
                                FontAwesomeIcons.magnifyingGlass,
                                size: 20,
                              color: Colors.black
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 45),
              categoryList.isNotEmpty ? Container(
                  margin: const EdgeInsets.only(
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
                        labelColor: hexToColor(orangeColor),
                        labelStyle: blackTextStyle.copyWith(
                            fontWeight: FontWeight.w400,
                            fontSize: 12
                        ),
                        indicatorColor: hexToColor(orangeColor),
                        onTap: (index) =>
                            setState(() {
                              currentIndex = index;
                              categoryId = categoryList[index].id;
                            }),
                        controller: _controller,
                        indicator: MaterialIndicator(
                            color: hexToColor(orangeColor),
                            height: 2,
                            topLeftRadius: 10,
                            topRightRadius: 10,
                            horizontalPadding: 0,
                            tabPosition: TabPosition.bottom,
                            strokeWidth: 0,
                        ),
                        tabs: categoryList.map((e) =>
                            SizedBox(
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
              ) : Center(child: CircularProgressIndicator(color: hexToColor(orangeColor),),),
              categoryList.isNotEmpty ? Container(
                margin: const EdgeInsets.only(
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
                          fontSize: 14,
                        color: hexToColor(orangeColor)
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
                margin: const EdgeInsets.only(
                    left: 16.0,
                    top: 24.0,
                    right: 13.0,
                    bottom: 8.0
                ),),
              Flexible(
                child: Container(
                  margin: const EdgeInsets.only(left: 17.0,),
                  padding: const EdgeInsets.only(bottom: 8),
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
              ),
            ]
        ),
      ) : Center(
        child: CircularProgressIndicator(
          color: hexToColor(orangeColor),
        ),
      ),
    );
  }
}