import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../components/CartItem.dart';
import '../functions/DatabaseHelper.dart';
import '../models/CartModel.dart';
import '../utils/Constants.dart';
import '../utils/SharedPref.dart';
import 'Checkout.dart';
import 'MainScreen.dart';

class Cart extends StatefulWidget {

  const Cart({Key? key}) : super(key: key);

  @override
  CartState createState() => CartState();
}

class CartState extends State<Cart> with WidgetsBindingObserver {

  final dbHelper = DatabaseHelper.instance;
  List<CartModel> items = [];
  double total = 0.0;
  int cartCount = 0;

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    _query().whenComplete(() => setState((){}));
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state){
    if(state == AppLifecycleState.resumed){
      _query().whenComplete(() => setState((){}));
    }else {
      _query().whenComplete(() => setState((){}));
    }
  }

  void _update(CartModel cartModel) async {
    Map<String, dynamic> row = {
      DatabaseHelper.columnId : cartModel.id,
      DatabaseHelper.columnFoodName : cartModel.name,
      DatabaseHelper.columnFoodPrice : cartModel.price.toString(),
      DatabaseHelper.columnDeliveryFee : cartModel.deliveryFee.toString(),
      DatabaseHelper.columnPackageAmount : cartModel.packageAmount.toString(),
      DatabaseHelper.columnServiceFee : cartModel.serviceFee.toString(),
      DatabaseHelper.columnFoodDescription : cartModel.description,
      DatabaseHelper.columnFoodImageUrl : cartModel.imageUrl,
      DatabaseHelper.columnFoodStatus : cartModel.status,
      DatabaseHelper.columnFoodCategory : cartModel.category,
      DatabaseHelper.columnFoodCreatedAt : cartModel.createdAt,
      DatabaseHelper.columnWaitingTime : cartModel.waitingTime,
      DatabaseHelper.columnQty : cartModel.quantity,
    };
    final rowsAffected = await dbHelper.update(row);
    debugPrint('updated $rowsAffected row(s)');
  }

  Future<void> _query() async {
    cartCount = 0;
    total = 0.0;
    items.clear();
    final allRows = await dbHelper.queryAllRows();
    for (var element in allRows) {
      setState(() => items.add(CartModel.fromJson(element)));
    }
    cartCount = (await dbHelper.queryRowCount())!;
  }

  @override
  Widget build(BuildContext context) {
    bool token = SharedPref.contains("token");

    total = 0.0;

    for(CartModel cart in items){
      total += cart.quantity * cart.price;
    }

    return items.isNotEmpty ? Scaffold(
      appBar: AppBar(
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                  builder: (BuildContext context) => MainScreen(destination: 0, fromCart: false)
              ), (ModalRoute.withName(Navigator.defaultRouteName)));
            },
            iconSize: 20,
            icon: Icon(
              Icons.add,
              color: hexToColor(blackColor),
            ),
          ),
        ],
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          iconSize: 20,
          icon: Icon(
            Icons.arrow_back_ios,
            color: hexToColor(blackColor),
          ),
        ),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text('Cart',
          style: blackTextStyle.copyWith(
            fontSize: 16,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: items.length > 3 ? null : Container(
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(4)),
            color: Colors.black
        ),
        width: double.infinity,
        margin: const EdgeInsets.only(right: 13, left: 13, bottom: 0),
        child: MaterialButton(
          onPressed: () => SharedPref.contains("token") ?
          Navigator.push(context,
            MaterialPageRoute(
              builder: (BuildContext context) => CheckOut(
                // isSuccessFul: false,
                destination: 0,
                deliveryAddress: "",
                deliveryPhone: "",
                additionalInfo: "",),
            ),
          ) :
          Future.delayed(const Duration(milliseconds: 500),() {
            Navigator.push(context,
                MaterialPageRoute(
                  builder: (BuildContext context) =>
                      MainScreen(destination: 2, fromCart: true,),
                )
            ).then((value) {
              setState((){});
            });
          }),
          child: SharedPref.contains("token") ? Text('Checkout',
              style: blackTextStyle.copyWith(
                color: Colors.white,
                fontSize: 14,
              )
          ) : Text('Register or Login to continue',
              style: blackTextStyle.copyWith(
                color: Colors.white,
                fontSize: 14,
              )
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListView.separated(
                    separatorBuilder: (context, index) => Divider(
                      endIndent: 16,
                      indent: 16,
                      thickness: 1,
                      color: hexToColor(dividerGreyColor),
                      height: 1,
                    ),
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      var item = items[index];
                      return CartItem(
                        checkout: false,
                        item: item,
                        remove: () =>
                            dbHelper.delete(item.id).then((value) {
                              if (value > 0) {
                                setState(() => items.remove(item));
                              }
                            }),
                        subtractQty: () {
                          if(item.quantity > 1) {
                            setState(() {
                              item.quantity -= 1;
                              _update(item);
                            });
                          }else {
                            dbHelper.delete(item.id).then((value) {
                              if (value > 0) {
                                setState(() => items.remove(item));
                              }
                            });
                          }
                        },
                        changeQuantity: (String? value) {
                          if(value != null && value != "") {
                            setState(() {
                              item.quantity = int.parse(value);
                              _update(item);
                            });
                          }
                        },
                        addQty: () => setState(() {
                          item.quantity += 1;
                          _update(item);
                        }),
                      );
                    }
                ),
                Divider(
                  endIndent: 16,
                  indent: 16,
                  thickness: 1,
                  color: hexToColor(dividerGreyColor),
                  height: 1,
                ),
                const SizedBox(height: 30,),
                Container(
                  margin: const EdgeInsets.only(left: 17),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Total (Inc VAT)',
                        style: blackTextStyle.copyWith(
                            fontSize: 12,
                            color: hexToColor(textGreyColor)
                        ),
                      ),
                      const SizedBox(height: 10,),
                      Text('N${formatter.format(total.toInt())}',
                        style: blackTextStyle.copyWith(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 100,),
                items.length > 3 ? Container(
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      color: Colors.black
                  ),
                  width: double.infinity,
                  margin: const EdgeInsets.only(right: 13, left: 13, bottom: 24),
                  child: MaterialButton(
                    onPressed: () => token ?
                    Navigator.push(context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => CheckOut(
                          // isSuccessFul: false,
                          destination: 0,
                          deliveryAddress: "",
                          deliveryPhone: "",
                          additionalInfo: "",),
                      ),
                    ) : Navigator.push(context,
                      MaterialPageRoute(builder: (BuildContext context) =>
                          MainScreen(
                              destination: 2,
                              fromCart: true
                          ),
                      ),
                    ).then((value) {
                      setState((){});
                    }),
                    child: token ? Text('Checkout',
                        style: blackTextStyle.copyWith(
                          color: Colors.white,
                          fontSize: 14,
                        )
                    ) : Text('Register or Login to continue',
                        style: blackTextStyle.copyWith(
                          color: Colors.white,
                          fontSize: 14,
                        )
                    ),
                  ),
                ) : Container(),
              ],
            )
        ),
      ),
    ) : Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            iconSize: 20,
            icon: Icon(
              Icons.arrow_back_ios,
              color: hexToColor(blackColor),
            ),
          ),
          backgroundColor: Colors.transparent,
          centerTitle: true,
          title: Text('Cart',
            style: blackTextStyle.copyWith(
              fontSize: 16,
            ),
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: SvgPicture.asset(
                'images/clock.svg',
                height: 152.93,
                width: 162.34,
              ),
            ),
            const SizedBox(height: 30.66,),
            Text('We are waiting for your first order',
              style: blackTextStyle.copyWith(
                  color: hexToColor(textGreyColor),
                  fontSize: 14,
                  fontWeight: FontWeight.w400
              ),),
            const SizedBox(height: 31,),
            Container(
              margin: const EdgeInsets.only(left: 32, right: 32, top: 15, bottom: 15),
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  color: Colors.black
              ),
              width: double.infinity,
              child: MaterialButton(
                child: Text('Order Now',
                    style: blackTextStyle.copyWith(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500
                    )
                ),
                onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(
                    builder: (BuildContext context) => MainScreen(destination: 0, fromCart: false,)
                ),
                ),
              ),
            ),
          ],
        )
    );
  }
}