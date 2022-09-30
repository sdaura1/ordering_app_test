import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ordering_app/functions/DatabaseHelper.dart';
import 'package:ordering_app/models/CartModel.dart';

import '../utils/Constants.dart';
import 'Home.dart';
import 'Orders.dart';
import 'Profile.dart';

class MainScreen extends StatefulWidget {

  const MainScreen({
    Key? key,
    required this.destination,
    required this.fromCart
  }) : super(key: key);

  final int destination;
  final bool fromCart;

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {

  int _selectedItemIndex = 0;
  List<CartModel> items = [];
  final dbHelper = DatabaseHelper.instance;
  bool isExpired = false;

  _onItemTapped(int index) => setState(() => _selectedItemIndex = index);

  @override
  void initState() {
    super.initState();
    getInformation().whenComplete(() async => await _query());
  }

  Future<void> getInformation() async {
    if(widget.destination == 2){
      setState(() => _selectedItemIndex = 2);
    }else if(widget.destination == 1) {
      setState(() => _selectedItemIndex = 1);
    }else if(widget.destination == 0){
      setState(() => _selectedItemIndex = 0);
    }
  }

  Future _query() async {
    final allRows = await dbHelper.queryAllRows();
    for (var element in allRows) {
      items.add(CartModel.fromJson(element));
    }
  }

  @override
  Widget build(BuildContext context) {

    final list = [
      const Home(),
      Orders(),
      Profile(fromCart: widget.fromCart)
    ];

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: true,
        showUnselectedLabels: true,
        backgroundColor: Colors.white,
        selectedIconTheme: IconThemeData(
            color: hexToColor(orangeColor),
            size: 26
        ),
        selectedItemColor: hexToColor(orangeColor),
        unselectedIconTheme: IconThemeData(
            color: hexToColor(dividerGreyColor),
            size: 26
        ),
        unselectedFontSize: 10,
        selectedFontSize: 10,
        iconSize: 26,
        unselectedItemColor: hexToColor(textGreyColor),
        unselectedLabelStyle: blackTextStyle.copyWith(
            color: hexToColor(dividerGreyColor),
            fontWeight: FontWeight.w400,
            fontSize: 10
        ),
        selectedLabelStyle: blackTextStyle.copyWith(
            fontSize: 10,
            fontWeight: FontWeight.w400,
            color: hexToColor(orangeColor)
        ),
        elevation: 5,
        items: [
          BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(bottom: 3.0),
                child: Icon(
                  FontAwesomeIcons.bowlFood,
                  size: 20,
                  color: _selectedItemIndex == 0 ? hexToColor(orangeColor) : hexToColor(dividerGreyColor),
                ),
              ),
              label: 'Menu'
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.only(bottom: 3.0),
              child: Icon(
                FontAwesomeIcons.utensils,
                size: 20,
                color: _selectedItemIndex == 1 ? hexToColor(orangeColor) : hexToColor(dividerGreyColor),
              ),
            ),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(bottom: 3.0),
                child: Icon(
                  FontAwesomeIcons.solidUser,
                  size: 20,
                  color: _selectedItemIndex == 2 ? hexToColor(orangeColor) : hexToColor(dividerGreyColor),
                ),
              ),
              label: 'Profile',
          ),
        ],
        currentIndex: _selectedItemIndex,
        onTap: _onItemTapped,
      ),
      body: list[_selectedItemIndex],
    );
  }
}