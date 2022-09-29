import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../functions/APICalls.dart';
import '../models/OrderHistoryItemModel.dart';
import '../models/OrderHistoryModel.dart';
import '../screens/MainScreen.dart';
import '../utils/Constants.dart';
import '../utils/SharedPref.dart';

class OrderStatus extends StatefulWidget {

  OrderStatus();

  @override
  _OrderStatusState createState() => _OrderStatusState();
}

class _OrderStatusState extends State<OrderStatus> with SingleTickerProviderStateMixin {

  var currentIndex = 0;
  List<OrderHistoryItemModel>? orderHistoryItemList = [];
  late APiCalls aPiCalls;
  bool processing = false;

  getOrderHistory() async {
    setState(() => processing = true);
    await aPiCalls.getOwnedOrder()
        .then((value) async {
      if(value.statusCode == 200 && jsonDecode(value.body)['code'] == 200){
        var body = await jsonDecode(value.body)['data'];
        body.forEach((element) async => await getOrderItems(OrderHistoryModel.fromJson(element).id));
      }else {
        setState(() => processing = false);
      }
    });
  }

  getOrderItems(id) async {
    setState(() => processing = false);
    await aPiCalls.getOrderItems(id).then((value) async {
      if(value.statusCode == 200 && jsonDecode(value.body)['code'] == 200) {
        var list = await jsonDecode(value.body)['data'];
        list.forEach((element) async => orderHistoryItemList!.add(OrderHistoryItemModel.fromJson(element)));
      }else {
        setState(() => orderHistoryItemList!.length = 0);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    aPiCalls = APiCalls();
    getOrderHistory();
  }

  @override
  Widget build(BuildContext context) {
    return !processing ? SharedPref.contains("token") ? ListView.separated(
        separatorBuilder: (context, index) => Divider(
          endIndent: 16,
          indent: 16,
          thickness: 1,
          color: hexToColor(dividerGreyColor),
          height: 1,
        ),
        shrinkWrap: true,
        itemCount: orderHistoryItemList!.length,
        itemBuilder: (context, index) {
          var item = orderHistoryItemList![index];
          Uint8List _base64 = Base64Decoder().convert(item.image);
          return orderHistoryItemList!.isNotEmpty ? Container(
            margin: EdgeInsets.only(top: 20, left: 17, right: 17, bottom: 20),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(4.0)),
                  child: item.image.isEmpty ? const Image(
                    fit: BoxFit.cover,
                    height: 88,
                    width: 88,
                    image: AssetImage(
                        'images/placeholder.png'
                    ),
                  ) : Image.memory(
                    _base64,
                    fit: BoxFit.cover,
                    height: 88,
                    width: 88,
                  ),
                ),
                SizedBox(width: 15,),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 150,
                      child: Text(item.name,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: blackTextStyle.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w400
                        ),
                        softWrap: false,
                      ),
                    ),
                    SizedBox(height: 9,),
                    Text(item.quantity > 1
                        ? '${item.quantity} Packs N${formatter.format(item.price * item.quantity)}'
                        : '${item.quantity} Pack N${formatter.format(item.price * item.quantity)}',
                      style: blackTextStyle.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w500
                      ),
                    ),
                    SizedBox(height: 14,),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(4.0)),
                        color: hexToColor(dividerGreyColor),
                      ),
                      child: Text(item.orderStatus,
                        style: blackTextStyle.copyWith(
                            color: hexToColor(pendingDeliveryColor),
                            fontWeight: FontWeight.w300,
                            fontSize: 12
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ) : Container(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: SvgPicture.asset(
                      'images/takeway.svg',
                      height: 140,
                      width: 211,
                    ),
                  ),
                ],
              )
          );
        }
    ) : Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            Center(
              child: SvgPicture.asset(
                'images/takeway.svg',
                height: 140,
                width: 211,
              ),
            ),
            Spacer(),
            Container(
              margin: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 15),
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  color: Colors.black
              ),
              width: double.infinity,
              child: MaterialButton(
                child: Text('Login to view Order Status',
                    style: blackTextStyle.copyWith(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500
                    )
                ),
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(
                      builder: (BuildContext context) => MainScreen(destination: 2, fromCart: false)
                  ));
                },
              ),
            )
          ],
        )
    ) : Center(
      child: CircularProgressIndicator(
        color: hexToColor(blackColor),
      ),
    );
  }
}
