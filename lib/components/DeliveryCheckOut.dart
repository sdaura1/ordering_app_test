import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ordering_app/screens/SuccessScreen.dart';

import '../functions/APICalls.dart';
import '../functions/DatabaseHelper.dart';
import '../models/CartModel.dart';
import '../models/OrderItemModel.dart';
import '../screens/MainScreen.dart';
import '../utils/Constants.dart';
import '../utils/SharedPref.dart';

class DeliveryCheckOut extends StatefulWidget {

  final String deliveryAddress;
  final String deliveryPhone;
  final String additionalInfo;
  final List<CartModel> items;
  final double total;
  final int destination;

  const DeliveryCheckOut({
    Key? key,
    required this.deliveryAddress,
    required this.deliveryPhone,
    required this.additionalInfo,
    required this.items,
    required this.total,
    required this.destination
  }) : super(key: key);

  @override
  _DeliveryCheckOutState createState() => _DeliveryCheckOutState();
}

class _DeliveryCheckOutState extends State<DeliveryCheckOut>{

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController deliveryAddressController = TextEditingController();
  TextEditingController additionalInformationController = TextEditingController();
  bool isLoading = false, selectedEditText = false, _phoneCheck = false, _deliveryAddressCheck = false;
  late APiCalls aPiCalls;
  var orderItems = [];
  double total = 0.0, deliveryFee = 0.0, takeAwayPackFee = 0.0, serviceFee = 0.0;
  List<CartModel> items = [];
  final dbHelper = DatabaseHelper.instance;

  @override
  void initState() {
    super.initState();
    getInformation().whenComplete(() =>
        setState(() {}));
  }

  makeOrder() async {
    setState(() => isLoading = true);
    await aPiCalls.makeOrder(total, "Delivery",
        deliveryAddressController.text.toString(), "Bank Transfer",
        additionalInformationController.text.toString(),
        phoneController.text.toString(), orderItems)
        .then((value) async {
      if(value.statusCode == 200 && jsonDecode(value.body)['code'] == 200) {
        setState(() => isLoading = false);
        var orderReference = jsonDecode(value.body)['data']['reference'];
        SharedPref.setReference(orderReference);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => const SuccessScreen(),
          ),
        );
      }else {
        setState(() => isLoading = false);
        SharedPref.clear().then((value) => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => const MainScreen(destination: 2, fromCart: true)
          ),
        ));
      }
    });
  }

  Future<void> getInformation() async {
    aPiCalls = APiCalls();
    await _query();
  }

  _query() async {
    final allRows = await dbHelper.queryAllRows();
    items.clear();
    orderItems.clear();
    total = 0.0;
    takeAwayPackFee = 0.0;
    for (var element in allRows) {
      var cartItem = CartModel.fromJson(element);
      deliveryFee = cartItem.deliveryFee;
      total += (cartItem.price * cartItem.quantity);
      takeAwayPackFee += (cartItem.quantity * cartItem.packageAmount);
      serviceFee = cartItem.serviceFee;
      setState(() {
        items.add(cartItem);
        orderItems.add(OrderItemModel(
            foodId: cartItem.id.toString(),
            quantity: int.parse(cartItem.quantity.toString())
        ).toJson());
      });
    }
    total += (total * 0.075) + serviceFee + deliveryFee + takeAwayPackFee;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Delivery Information',
            style: blackTextStyle.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 12,),
          TextField(
            controller: deliveryAddressController,
            keyboardType: TextInputType.multiline,
            maxLines: 3,
            minLines: 1,
            cursorColor: hexToColor(orangeColor),
            decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: hexToColor(textGreyColor),
                      width: 1.0
                  ),
                ),
                errorStyle: blackTextStyle.copyWith(
                    fontSize: 8,
                    height: .08,
                    color: hexToColor(redColor)
                ),
                errorMaxLines: 1,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: hexToColor(dividerGreyColor),
                      width: 3.0
                  ),
                ),
                filled: true,
                errorText: _deliveryAddressCheck ? 'Delivery Address is required' :  null,
                hintText: 'Delivery Address',
                border: OutlineInputBorder(
                    borderSide: BorderSide(
                        width: 0,
                        color: hexToColor(dividerGreyColor)
                    ),
                    borderRadius: BorderRadius.circular(4)
                ),
                fillColor: hexToColor(dividerGreyColor),
                hintStyle: blackTextStyle.copyWith(
                    color: hexToColor(textGreyColor),
                    fontSize: 14,
                    fontWeight: FontWeight.w400
                ),
                contentPadding: EdgeInsets.all(16)
            ),
            onChanged: (String value){

            },
          ),
          const SizedBox(height: 16,),
          TextField(
            controller: phoneController,
            keyboardType: TextInputType.phone,
            maxLines: 1,
            minLines: 1,
            cursorColor: hexToColor(orangeColor),
            decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: hexToColor(textGreyColor),
                      width: 1.0
                  ),
                ),
                errorStyle: blackTextStyle.copyWith(
                    fontSize: 8,
                    height: .08,
                    color: hexToColor(redColor)
                ),
                errorMaxLines: 1,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: hexToColor(dividerGreyColor),
                      width: 3.0
                  ),
                ),
                filled: true,
                errorText: _phoneCheck ? 'Phone Number is required' : null,
                hintText: 'Phone Number',
                border: OutlineInputBorder(
                    borderSide: BorderSide(
                        width: 0,
                        color: hexToColor(dividerGreyColor)
                    ),
                    borderRadius: BorderRadius.circular(4)
                ),
                fillColor: hexToColor(dividerGreyColor),
                hintStyle: blackTextStyle.copyWith(
                    color: hexToColor(textGreyColor),
                    fontSize: 14,
                    fontWeight: FontWeight.w400
                ),
                contentPadding: const EdgeInsets.all(16)
            ),
          ),
          const SizedBox(height: 16,),
          Container(
            height: 104.0,
            decoration: BoxDecoration(
              color: hexToColor(dividerGreyColor),
              border: selectedEditText ? Border.all(color: hexToColor(textGreyColor), width: 1.0)
                  : Border.all(color: hexToColor(dividerGreyColor), width: 3.0),
              borderRadius: BorderRadius.circular(4),
            ),
            child: TextField(
              controller: additionalInformationController,
              keyboardType: TextInputType.multiline,
              maxLines: 6,
              minLines: 1,
              cursorColor: hexToColor(orangeColor),
              onTap: () => setState(() => selectedEditText = true),
              decoration: InputDecoration(
                  focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide.none
                  ),
                  errorStyle: blackTextStyle.copyWith(
                      fontSize: 8,
                      height: .08,
                      color: hexToColor(redColor)
                  ),
                  errorMaxLines: 1,
                  enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide.none
                  ),
                  filled: true,
                  hintText: 'Additional Information',
                  border: InputBorder.none,
                  fillColor: hexToColor(dividerGreyColor),
                  hintStyle: blackTextStyle.copyWith(
                      color: hexToColor(textGreyColor),
                      fontSize: 14,
                      fontWeight: FontWeight.w400
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16)
              ),
            ),
          ),
          const SizedBox(height: 15,),
          !isLoading ? Container(
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(4)),
                color: hexToColor(orangeColor)
            ),
            width: double.infinity,
            child: MaterialButton(
              onPressed: () async {
                if(deliveryAddressController.text.isNotEmpty
                    && phoneController.text.isNotEmpty){
                  await makeOrder();
                }else if(deliveryAddressController.text.isEmpty
                    && phoneController.text.isEmpty){
                  setState(() {
                    _deliveryAddressCheck = true;
                    _phoneCheck = true;
                  });
                }else if(deliveryAddressController.text.isEmpty
                    || phoneController.text.isEmpty){
                  if(deliveryAddressController.text.isEmpty
                      && phoneController.text.isNotEmpty) {
                    setState(() {
                      _deliveryAddressCheck = true;
                      _phoneCheck = false;
                    });
                  }else if(phoneController.text.isEmpty
                      && deliveryAddressController.text.isNotEmpty){
                    setState(() {
                      _deliveryAddressCheck = false;
                      _phoneCheck = true;
                    });
                  }
                }
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
            child: CircularProgressIndicator(
              color: hexToColor(orangeColor),
            ),
          ),
        ],
      ),
    );
  }
}
