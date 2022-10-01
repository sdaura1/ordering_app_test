import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../functions/APICalls.dart';
import '../models/FoodModel.dart';
import '../utils/Constants.dart';
import '../screens/DetailedView.dart';
import 'SearchItem.dart';

class SearchView extends StatefulWidget {

  final String searchParam;

  const SearchView({
    Key? key,
    required this.searchParam,
  }) : super(key: key);

  @override
  SearchViewState createState() => SearchViewState();
}

class SearchViewState extends State<SearchView> {

  final TextEditingController _searchTextController = TextEditingController();
  late APiCalls aPiCalls;
  final List<FoodModel> _foodItems = [];
  String searchString = "";
  bool searching = false;
  var information = "";

  searchFood(searchText) async {
    aPiCalls = APiCalls();
    setState(() {
      _foodItems.clear();
      searching = true;
    });
    await aPiCalls.searchFood(searchText).then((value) async {
      if(value.statusCode == 200 && jsonDecode(value.body)['code'] == 200) {
        setState(() {
          searching = false;
        });
        var foodItems = await jsonDecode(value.body)['data'];
        for (var foodItem in foodItems) {
          setState(() {
            _foodItems.add(FoodModel.fromJson(foodItem));
            searching = false;
          });
        }
      }else if (value.statusCode == 200 && jsonDecode(value.body)['code'] == 400){
        setState(() {
          information = jsonDecode(value.body)['description'];
          searching = false;
          _foodItems.clear();
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _searchTextController.text = widget.searchParam;
    searchFood(widget.searchParam);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 16,),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: 272,
                      height: 48,
                      child: TextField(
                        textCapitalization: TextCapitalization.words,
                        controller: _searchTextController,
                        onSubmitted: (searchText) {
                          setState(() => searchString = searchText);
                          searchFood(searchString);
                        },
                        keyboardType: TextInputType.name,
                        obscureText: false,
                        textAlignVertical: TextAlignVertical.center,
                        textAlign: TextAlign.start,
                        cursorColor: hexToColor(orangeColor),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: hexToColor(dividerGreyColor),
                          hintText: FocusNode().hasFocus ? searchString : 'Search Meals',
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: hexToColor(dividerGreyColor),
                                width: 0.0
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: hexToColor(textGreyColor),
                                width: 0.0
                            ),
                          ),
                          border: const OutlineInputBorder(),
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
                    GestureDetector(
                      onTap: (){
                        Navigator.pop(context);
                      },
                      child: Text('Cancel',
                        style: blackTextStyle.copyWith(
                            color: hexToColor(orangeColor),
                            fontWeight: FontWeight.w400,
                            fontSize: 14
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                    margin: const EdgeInsets.only(top: 10, left: 0,),
                    child: !searching ? _foodItems.isNotEmpty ? ListView.separated(
                        separatorBuilder: (context, index) => Divider(
                          endIndent: 16,
                          indent: 16,
                          thickness: 1,
                          color: hexToColor(dividerGreyColor),
                          height: 1,
                        ),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _foodItems.length,
                        itemBuilder: (BuildContext context, int index) {
                          var foodModel = _foodItems[index];
                          return SearchItem(
                            item: foodModel,
                            onTap: () => Navigator.push(context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) => DetailedView(foodModel: foodModel),
                                  ),
                                ),
                          );
                        }) : Text(
                      information,
                      style: blackTextStyle.copyWith(
                          fontSize: 18,
                        fontWeight: FontWeight.w400
                      ),
                    ) : Center(
                        child: CircularProgressIndicator(
                          color: hexToColor(orangeColor),
                        )
                    )
                ),
              ],
            ),
          )
      ),
    );
  }
}
