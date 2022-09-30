import 'package:flutter/material.dart';
import 'package:ordering_app/components/DeliveryCheckOut.dart';
import 'package:ordering_app/components/PickupCheckOut.dart';
import 'package:ordering_app/functions/DatabaseHelper.dart';
import 'package:ordering_app/models/CartModel.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

import '../utils/Constants.dart';

class CheckOut extends StatefulWidget {

  final String deliveryAddress, deliveryPhone, additionalInfo;
  final int destination;

  CheckOut({
    required this.deliveryAddress,
    required this.deliveryPhone,
    required this.additionalInfo,
    required this.destination
  });

  @override
  _CheckOutState createState() => _CheckOutState();
}

class _CheckOutState extends State<CheckOut> with SingleTickerProviderStateMixin {

  final dbHelper = DatabaseHelper.instance;
  List<CartModel> items = [];
  double total = 0.0, deliveryFee = 0.0, takeAwayPackFee = 0.0,
      serviceFee = 0.0, vat = 0.0;
  int cartCount = 0, currentIndex = 0, quantity = 0;
  late TabController _controller;
  List<Widget> tabs = [];

  void _query() async {
    final allRows = await dbHelper.queryAllRows();
    cartCount = (await dbHelper.queryRowCount())!;
    allRows.forEach((element) {
      var cartItem = CartModel.fromJson(element);
      quantity += cartItem.quantity;
      deliveryFee = cartItem.deliveryFee;
      serviceFee = cartItem.serviceFee;
      takeAwayPackFee += (cartItem.packageAmount * cartItem.quantity);
      setState(() => items.add(cartItem));
    });
  }

  @override
  void initState() {
    super.initState();
    total = 0.0;
    cartCount = 0;
    quantity = 0;
    currentIndex = widget.destination;
    _query();
    tabs = [
      DeliveryCheckOut(
          items: items,
          total: total + takeAwayPackFee + deliveryFee,
          destination: widget.destination,
          deliveryAddress: widget.deliveryAddress,
          deliveryPhone: widget.deliveryPhone,
          additionalInfo: widget.additionalInfo
      ),
      PickupCheckOut(
          items: items,
          total: total + takeAwayPackFee
      )
    ];
    _controller = TabController(length: tabs.length, vsync: this);
    _controller.addListener(_handleSelected);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleSelected() {

  }

  @override
  Widget build(BuildContext context) {

    total = 0.0;
    quantity = 0;
    deliveryFee = 0.0;
    takeAwayPackFee = 0.0;
    serviceFee = 0.0;
    vat = 0.0;

    for(CartModel cart in items){
      total += cart.quantity * cart.price;
      quantity += cart.quantity;
      deliveryFee = cart.deliveryFee;
      serviceFee = cart.serviceFee;
      takeAwayPackFee += (cart.packageAmount * cart.quantity);
    }

    vat = total * 0.075;

    return Scaffold(
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
        title: Text('Checkout',
          style: blackTextStyle.copyWith(
            fontSize: 16,
          ),),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(right: 16, left: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Column(
                    children: [
                      SizedBox(height: 15),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(items.length > 1 ? 'Items price' : 'Item price',
                            style: blackTextStyle.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: hexToColor(textEmailColor)
                            ),
                          ),
                          Text('N${formatter.format(total.toInt())}',
                            style: blackTextStyle.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: hexToColor(orangeColor)
                            ),
                          ),
                        ],
                      ),
                      takeAwayPackFee > 0 ? SizedBox(height: 15) : Container(),
                      takeAwayPackFee > 0 ? Divider(
                        height: 1,
                        thickness: 1,
                        color: hexToColor(dividerGreyColor),
                      ) : Container(),
                      takeAwayPackFee > 0 ? SizedBox(height: 15,) : Container(),
                      takeAwayPackFee > 0 ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Packaging',
                            style: blackTextStyle.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: hexToColor(textEmailColor)
                            ),
                          ),
                          Text('N${formatter.format(takeAwayPackFee)}',
                            style: blackTextStyle.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: hexToColor(orangeColor)
                            ),
                          ),
                        ],
                      ) : Container(),
                      SizedBox(height: 15),
                      Divider(
                        height: 1,
                        thickness: 1,
                        color: hexToColor(dividerGreyColor),
                      ),
                      SizedBox(height: 15),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Subtotal',
                            style: blackTextStyle.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: hexToColor(textEmailColor)
                            ),
                          ),
                          Text('N${formatter.format(total + takeAwayPackFee)}',
                            style: blackTextStyle.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: hexToColor(orangeColor)
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                      Divider(
                        height: 1,
                        thickness: 1,
                        color: hexToColor(orangeColor),
                      ),
                      SizedBox(height: 5),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Other charges',
                            style: blackTextStyle.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: hexToColor(orangeColor)
                            ),
                          ),
                        ],
                      ),
                      currentIndex == 0 ? SizedBox(height: 5) : Container(),
                      currentIndex == 0 ? Divider(
                        height: 1,
                        thickness: 1,
                        color: hexToColor(orangeColor),
                      ) : Container(),
                      currentIndex == 0 ? SizedBox(height: 15) : Container(),
                      currentIndex == 0 ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Delivery',
                            style: blackTextStyle.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: hexToColor(textEmailColor)
                            ),
                          ),
                          Text('N${formatter.format(deliveryFee)}',
                            style: blackTextStyle.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: hexToColor(orangeColor)
                            ),
                          ),
                        ],
                      ) : Container(),
                      currentIndex == 0 ? SizedBox(height: 15) : SizedBox(height: 5),
                      Divider(
                        height: 1,
                        thickness: 1,
                        color: hexToColor(currentIndex == 0 ? dividerGreyColor : orangeColor),
                      ),
                      SizedBox(height: 15),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Payment Processing fee',
                            style: blackTextStyle.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: hexToColor(textEmailColor)
                            ),
                          ),
                          Text('N${formatter.format(serviceFee)}',
                            style: blackTextStyle.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: hexToColor(orangeColor)
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                      Divider(
                        height: 1,
                        thickness: 1,
                        color: hexToColor(dividerGreyColor),
                      ),
                      SizedBox(height: 15),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('VAT',
                            style: blackTextStyle.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: hexToColor(textEmailColor)
                            ),
                          ),
                          Text('N${formatter.format(vat)}',
                            style: blackTextStyle.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: hexToColor(orangeColor)
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                      Divider(
                        height: 1,
                        thickness: 1,
                        color: hexToColor(dividerGreyColor),
                      ),
                      SizedBox(height: 15),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Total',
                            style: blackTextStyle.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: hexToColor(textEmailColor)
                            ),
                          ),
                          Text(currentIndex == 0 ? 'N${formatter.format(total.toInt() + takeAwayPackFee + deliveryFee + serviceFee + vat)}' :
                          'N${formatter.format(total.toInt() + takeAwayPackFee + serviceFee + vat)}',
                            style: blackTextStyle.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: hexToColor(orangeColor)
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                      Divider(
                        height: 1,
                        thickness: 1,
                        color: hexToColor(dividerGreyColor),
                      ),
                      SizedBox(height: 15),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: TabBar(
                      controller: _controller,
                      isScrollable: false,
                      unselectedLabelStyle: blackTextStyle.copyWith(
                          color: hexToColor(textGreyColor),
                          fontWeight: FontWeight.w400,
                          fontSize: 12
                      ),
                      indicatorSize: TabBarIndicatorSize.tab,
                      unselectedLabelColor: hexToColor(dividerGreyColor),
                      labelColor: hexToColor(orangeColor),
                      labelStyle: blackTextStyle.copyWith(
                          fontWeight: FontWeight.w400,
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
                      tabs: [
                        Tab(
                          child: Text('Delivery',
                            style: blackTextStyle.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.w400
                            ),),
                        ),
                        Tab(
                          child: Text('Pickup',
                            style: blackTextStyle.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.w400
                            ),),
                        ),
                      ]
                  ),
                ),
                Container(
                  height: 350,
                  child: TabBarView(
                      controller: _controller,
                      children: tabs
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
