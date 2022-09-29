import 'dart:convert';

import 'package:http/http.dart' as http;

import '../utils/SharedPref.dart';
import 'Urls.dart';

class APiCalls {

  APiCalls();

  Future<http.Response> getFoodList() async {
    var response = await http.get(Uri.parse(food_list_url))
        .timeout(Duration(seconds: 20));
    return response;
  }

  Future<http.Response> getCategoryList() async {
    var response = await http.get(Uri.parse(food_category_list_url))
        .timeout(Duration(seconds: 20));
    return response;
  }

  Future<http.Response> getPopularMeals() async {
    var response = await http.get(Uri.parse(popular_meals_url))
        .timeout(Duration(seconds: 20));
    return response;
  }

  Future<http.Response> getFoodById(id) async {
    var response = await http.get(Uri.parse("$food_by_id_url$id"))
        .timeout(Duration(seconds: 20));
    return response;
  }

  Future<http.Response> getOrderItems(orderId) async {
    var response = await http.get(Uri.parse("$get_order_items_url$orderId"),
        headers: {
          "Authorization": "Bearer ${SharedPref.getToken()}",
          "Accept": "application/json",
          "Content-Type": "application/json"
        })
        .timeout(Duration(seconds: 20));
    return response;
  }

  Future<http.Response> getOrderById(id) async {
    var response = await http.get(Uri.parse("$get_order_by_id_url$id"),
        headers: {
          "Authorization": "Bearer ${SharedPref.getToken()}",
          "Accept": "application/json",
          "Content-Type": "application/json"
        })
        .timeout(Duration(seconds: 20));
    return response;
  }

  Future<http.Response> login(username, password) async {
    var response = await http.post(Uri.parse(login_url),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json"
        },
        body: jsonEncode({
          "mobileNumber": username.toString(),
          "password": password.toString()
        })).timeout(Duration(seconds: 20));
    return response;
  }

  Future<http.Response> changePassword(oldPassword, newPassword) async {
    var response = await http.post(Uri.parse(change_password_url),
        headers: {
          "Authorization": "Bearer ${SharedPref.getToken()}",
          "Content-Type": "application/json"
        },
        body: jsonEncode({
          "oldPassword": oldPassword.toString(),
          "newPassword": newPassword.toString()
        })).timeout(Duration(seconds: 20));
    return response;
  }

  Future<http.Response> register(username, phone, password) async {
    var response = await http.post(Uri.parse(register_url),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json"
        },
        body: jsonEncode({
          "fullname": username.toString(),
          "mobileNumber": phone.toString(),
          "password": password.toString()
        })).timeout(Duration(seconds: 20));
    return response;
  }

  Future<http.Response> getFoodByCategory(category) async {
    var response = await http.get(Uri.parse("$food_by_category_url$category"))
        .timeout(Duration(seconds: 20));
    return response;
  }

  Future<http.Response> getCustomerAccountDetails() async {
    var response = await http.get(Uri.parse("$customer_virtual_account/${SharedPref.getId()}"),
        headers: {
          "Authorization": "Bearer ${SharedPref.getToken()}",
          "Accept": "application/json",
          "Content-Type": "application/json"
        })
        .timeout(Duration(seconds: 30));
    return response;
  }

  Future<http.Response> getCustomerAccountBalance(accountNumber) async {
    var response = await http.get(Uri.parse("$customer_virtual_account_balance/$accountNumber"),
        headers: {
          "Authorization": "Bearer ${SharedPref.getToken()}",
          "Accept": "application/json",
          "Content-Type": "application/json"
        })
        .timeout(Duration(seconds: 30));
    return response;
  }

  Future<http.Response> makeOrderPayment(orderReference) async {
    var response = await http.get(Uri.parse("$customer_order_make_payment/$orderReference"),
        headers: {
          "Authorization": "Bearer ${SharedPref.getToken()}",
          "Accept": "application/json",
          "Content-Type": "application/json"
        })
        .timeout(Duration(seconds: 30));
    return response;
  }

  Future<http.Response> getPaymentStatus() async {
    var response = await http.get(Uri.parse(customer_payment_status),
        headers: {
          "Authorization": "Bearer ${SharedPref.getToken()}",
          "Accept": "application/json",
          "Content-Type": "application/json"
        })
        .timeout(Duration(seconds: 20));
    return response;
  }

  Future<http.Response> deleteCustomer(id) async {
    var response = await http.patch(Uri.parse(delete_customer_url),
        headers: {
          "Authorization": "Bearer ${SharedPref.getToken()}",
          "Accept": "application/json",
          "Content-Type": "application/json"
        },
        body: jsonEncode({
          "userId": id.toString()
        })
    ).timeout(Duration(seconds: 20));
    return response;
  }

  Future<http.Response> searchFood(string) async {
    var response = await http.get(Uri.parse("$search_food_url$string"))
        .timeout(Duration(seconds: 20));
    return response;
  }

  Future<http.Response> getOwnedOrder() async {
    var response = await http.get(Uri.parse(get_order_owned_url),
        headers: {
          "Authorization": "Bearer ${SharedPref.getToken()}",
          "Accept": "application/json",
          "Content-Type": "application/json"
        })
        .timeout(Duration(seconds: 20));
    return response;
  }

  Future<http.Response> cardPaymentVerification(txnRef) async {
    var response = await http.get(Uri.parse("$card_payment_verification/$txnRef"),
        headers: {
          "Authorization": "Bearer ${SharedPref.getToken()}",
          "Accept": "application/json",
          "Content-Type": "application/json"
        })
        .timeout(Duration(seconds: 20));
    return response;
  }

  Future<http.Response> makeOrder(amount, deliveryType,
      deliveryAddress, paymentMethod, additionalInfo, deliveryPhone, orderItems) async {
    var response = await http.post(Uri.parse(make_order_url),
        headers: {
          "Authorization": "Bearer ${SharedPref.getToken()}",
          "Accept": "application/json",
          "Content-Type": "application/json"
        }, body: jsonEncode({
          "customerId": SharedPref.getId(),
          "amount": double.parse(amount.toString()),
          "deliveryType": deliveryType.toString(),
          "deliveryAddress": deliveryAddress.toString(),
          "paymentMethod": paymentMethod.toString(),
          "additionalInfo": additionalInfo.toString(),
          "deliveryPhone": deliveryPhone.toString(),
          "orderItems": orderItems
        })).timeout(Duration(seconds: 20));
    return response;
  }

}