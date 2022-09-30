import 'package:flutter/material.dart';
import 'package:ordering_app/components/OrderStatus.dart';
import 'package:ordering_app/components/OrderHistory.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

import '../utils/Constants.dart';
import 'MainScreen.dart';

class Orders extends StatefulWidget {

  Orders();

  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> with SingleTickerProviderStateMixin {

  var _handler;
  var currentIndex = 0;
  late TabController _controller;
  List<Widget> tabs = [];

  @override
  void initState() {
    super.initState();
    tabs.add(OrderStatus());
    tabs.add(OrderHistory());
    _controller = TabController(length: tabs.length, initialIndex: 0, vsync: this);
    _handler = tabs[0];
    _controller.addListener(_handleSelected);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleSelected() {
    setState(() {
      _handler = tabs[_controller.index];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (BuildContext context) => const MainScreen(destination: 0, fromCart: false),
          )),
          iconSize: 20,
          icon: Icon(
            Icons.arrow_back_ios,
            color: hexToColor(orangeColor),
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text('Orders',
          style: blackTextStyle.copyWith(
            fontSize: 16,
          ),),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(right: 16, left: 16),
              child: DefaultTabController(
                initialIndex: 0,
                length: tabs.length,
                child: TabBar(
                    isScrollable: false,
                    unselectedLabelStyle: blackTextStyle.copyWith(
                        color: hexToColor(textGreyColor),
                        fontWeight: FontWeight.w400,
                        fontSize: 12
                    ),
                    indicatorSize: TabBarIndicatorSize.tab,
                    unselectedLabelColor: hexToColor(textGreyColor),
                    labelColor: Colors.black,
                    labelStyle: blackTextStyle.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 12
                    ),
                    indicatorColor: hexToColor(orangeColor),
                    onTap: (index) => setState(() => currentIndex = index),
                    indicator: MaterialIndicator(
                        color: hexToColor(orangeColor),
                        height: 4,
                        topLeftRadius: 10,
                        topRightRadius: 10,
                        horizontalPadding: 0,
                        tabPosition: TabPosition.bottom,
                        strokeWidth: 6
                    ),
                    controller: _controller,
                    tabs: const [
                      Tab(
                        child: Text('Order Status',),
                      ),
                      Tab(
                        child: Text('Order History',),
                      ),
                    ]
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: TabBarView(
                  controller: _controller,
                  children: tabs
              ),
            ),
          ],
        ),
      ),
    );
  }
}
