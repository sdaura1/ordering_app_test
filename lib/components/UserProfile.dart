import 'dart:convert';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:ordering_app/utils/Constants.dart';
import 'package:ordering_app/components/Login.dart';
import 'package:ordering_app/functions/APICalls.dart';
import 'package:ordering_app/functions/DatabaseHelper.dart';
import 'package:ordering_app/models/CartModel.dart';
import 'package:ordering_app/screens/MainScreen.dart';

import '../utils/SharedPref.dart';
import '../utils/view_utils.dart';

class UserProfile extends StatefulWidget {

  final bool fromCart;

  UserProfile({
    required this.fromCart
  });

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {

  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmNewPasswordController = TextEditingController();
  final dbHelper = DatabaseHelper.instance;
  bool _checkCurrentPassword = false;
  bool _checkNewPassword = false;
  bool _checkConfirmNewPassword = false;
  bool _checkPasswordMatching = false;
  bool _currentPasswordVisible = true;
  bool _newPasswordVisible = true;
  bool _confirmNewPasswordVisible = true;
  bool isChangingPassword = false;
  bool _isLoading = false;
  String passwordInformation = "is required";
  late APiCalls aPiCalls;
  List<CartModel> items = [];
  double total = 0.0;
  int cartCount = 0;
  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
  );

  void _query() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
    aPiCalls = APiCalls();
    final allRows = await dbHelper.queryAllRows();
    allRows.forEach((element) {
      setState(() => items.add(CartModel.fromJson(element)));
    });
    cartCount = (await dbHelper.queryRowCount())!;
  }

  @override
  void initState() {
    super.initState();
    _query();
  }

  @override
  Widget build(BuildContext context) {
    var firstLetter = SharedPref.contains("name") ?
    SharedPref.getName().toString().split(" ").first.characters.first.toUpperCase() : "";
    var secondLetter = SharedPref.contains("name") ?
    SharedPref.getName().toString().split(" ").last.characters.first.toUpperCase() : "";
    var shortHand = firstLetter + secondLetter;
    return !isChangingPassword && SharedPref.contains("token") ? Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (BuildContext context) => MainScreen(destination: 0, fromCart: false),
            )),
            iconSize: 20,
            icon: Icon(
              Icons.arrow_back_ios,
              color: hexToColor(blackColor),
            ),
          ),
          actions: [
            Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Text(
                  "v${_packageInfo.version}",
                  style: blackTextStyle.copyWith(
                      fontFamily: fontFamily,
                      fontWeight: FontWeight.w200,
                      fontSize: 14,
                      color: Colors.black
                  ),
                ),
              ),
            ),
          ],
          elevation: 0,
          backgroundColor: Colors.transparent,
          centerTitle: true,
          title: Text('Profile',
            style: blackTextStyle.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: hexToColor(blackColor)
            ),
          ),
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          margin: EdgeInsets.only(left: 15, right: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 350,
                child:
                Column(
                  children: [
                    Center(
                      child: Container(
                        height: 48,
                        width: 48,
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(29)),
                            color: Colors.black
                        ),
                        child: Center(
                          child: Text(shortHand,
                            textAlign: TextAlign.center,
                            style: blackTextStyle.copyWith(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w400
                            ),),
                        ),
                      ),
                    ),
                    SizedBox(height: 16,),
                    Text(SharedPref.getName(),
                      textAlign: TextAlign.center,
                      style: blackTextStyle.copyWith(
                          color: hexToColor(blackColor),
                          fontSize: 16,
                          fontWeight: FontWeight.w400
                      ),
                    ),
                    SizedBox(height: 8,),
                    Text(SharedPref.getPhone(),
                      textAlign: TextAlign.center,
                      style: blackTextStyle.copyWith(
                          color: hexToColor(textEmailColor),
                          fontSize: 14,
                          fontWeight: FontWeight.w400
                      ),),
                    SizedBox(height: 32,),
                    Divider(
                      color: hexToColor(dividerGreyColor),
                      height: 1,
                      thickness: 1,
                      indent: 16,
                      endIndent: 16,
                    ),
                    SizedBox(height: 16,),
                    Container(
                      height: 25,
                      margin: EdgeInsets.only(right: 16, left: 16),
                      child: GestureDetector(
                        onTap: () => setState(() => isChangingPassword = true),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () => setState(() => isChangingPassword = true),
                              child: SvgPicture.asset(
                                'images/password.svg',
                                color: hexToColor(blackColor),
                                height: 15,
                                width: 13.5,),
                            ),
                            SizedBox(width: 22.5,),
                            GestureDetector(
                              onTap: () => setState(() => isChangingPassword = true),
                              child: Text('Change Password',
                                textAlign: TextAlign.center,
                                style: blackTextStyle.copyWith(
                                    color: hexToColor(blackColor),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400
                                ),),
                            ),
                            Spacer(),
                            GestureDetector(
                              onTap: () => setState(() => isChangingPassword = true),
                              child: SvgPicture.asset(
                                'images/vector.svg',
                                color: hexToColor(blackColor),
                                height: 9.63,
                                width: 4.81,),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16,),
                    Divider(
                      color: hexToColor(dividerGreyColor),
                      height: 1,
                      thickness: 1,
                      indent: 16,
                      endIndent: 16,
                    ),
                    SizedBox(height: 16,),
                    Container(
                      height: 25,
                      margin: EdgeInsets.only(right: 16, left: 16),
                      child: GestureDetector(
                        onTap: () {
                          ZainpayViewUtils.showConfirmPaymentModal(context, () =>
                              aPiCalls.deleteCustomer(SharedPref.getId()).then((value) {
                                if(value.statusCode == 200){
                                  showNotification(
                                      message: 'Deleted User Account',
                                      error: true
                                  );
                                  Future.delayed(const Duration(milliseconds: 500), (){
                                    for (var element in items) {
                                      dbHelper.delete(element.id);
                                    }
                                  }).whenComplete(() {
                                    SharedPref.clear();
                                    setState(() {});
                                  });
                                }
                              }));
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                                onTap: () {
                                  ZainpayViewUtils.showConfirmPaymentModal(context, () async =>
                                      await aPiCalls.deleteCustomer(SharedPref.getId()).then((value) {
                                        if(value.statusCode == 200){
                                          showNotification(
                                              message: 'Deleted User Account',
                                              error: true
                                          );
                                          Future.delayed(Duration(milliseconds: 500), (){
                                            items.forEach((element) => dbHelper.delete(element.id));
                                          }).whenComplete(() {
                                            SharedPref.clear();
                                            setState(() {});
                                          });
                                        }
                                      }));
                                },
                                child: SvgPicture.asset(
                                    'images/password.svg',
                                    color: hexToColor(redColor),
                                    height: 15,
                                    width: 13.5)
                            ),
                            SizedBox(width: 22.5),
                            GestureDetector(
                              onTap: () {
                                ZainpayViewUtils.showConfirmPaymentModal(context, () async =>
                                await aPiCalls.deleteCustomer(SharedPref.getId()).then((value) {
                                      if(value.statusCode == 200){
                                        showNotification(
                                            message: 'Deleted User Account',
                                            error: true
                                        );
                                        Future.delayed(Duration(milliseconds: 500), (){
                                          items.forEach((element) => dbHelper.delete(element.id));
                                        }).whenComplete(() {
                                          SharedPref.clear();
                                          setState(() {});
                                        });
                                      }
                                    }));
                              },
                              child: Text('Delete Account',
                                textAlign: TextAlign.center,
                                style: blackTextStyle.copyWith(
                                    color: hexToColor(redColor),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400
                                ),),
                            ),
                            Spacer(),
                            GestureDetector(
                                onTap: () {
                                  ZainpayViewUtils.showConfirmPaymentModal(context, () async =>
                                  await aPiCalls.deleteCustomer(SharedPref.getId()).then((value) {
                                    if(value.statusCode == 200){
                                      showNotification(
                                          message: 'Deleted User Account',
                                          error: true
                                      );
                                      Future.delayed(Duration(milliseconds: 500), (){
                                        items.forEach((element) => dbHelper.delete(element.id));
                                      }).whenComplete(() {
                                        SharedPref.clear();
                                        setState(() {});
                                      });
                                    }
                                  }));
                                },
                                child: SvgPicture.asset(
                                    'images/vector.svg',
                                    color: hexToColor(redColor),
                                    height: 9.63,
                                    width: 4.81)
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16,),
                    Divider(
                      color: hexToColor(dividerGreyColor),
                      height: 1,
                      endIndent: 16,
                      indent: 16,
                      thickness: 1,
                    ),
                    SizedBox(height: 16),
                    Container(
                      height: 25,
                      margin: EdgeInsets.only(right: 16, left: 16),
                      child: GestureDetector(
                        onTap: () async {
                          showNotification(
                            message: 'Logout Successful',
                            error: true,
                          );
                          Future.delayed(Duration(milliseconds: 500), (){
                            items.forEach((element) => dbHelper.delete(element.id));
                          }).whenComplete(() {
                            SharedPref.clear();
                            setState(() {});
                          });
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              child: SvgPicture.asset(
                                  'images/logout.svg',
                                  color: hexToColor(blackColor),
                                  height: 15,
                                  width: 13.5),
                            ),
                            SizedBox(width: 22.5,),
                            GestureDetector(
                              child: Text('Logout',
                                textAlign: TextAlign.center,
                                style: blackTextStyle.copyWith(
                                    color: hexToColor(blackColor),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400
                                ),),
                            ),
                            Spacer(),
                            GestureDetector(
                              child: SvgPicture.asset(
                                'images/vector.svg',
                                color: hexToColor(blackColor),
                                height: 9.63,
                                width: 4.81,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16,),
                    Divider(
                      color: hexToColor(dividerGreyColor),
                      height: 1,
                      endIndent: 16,
                      indent: 16,
                      thickness: 1,
                    ),
                  ],
                ),
              )
            ],
          ),
        )) : isChangingPassword && SharedPref.contains("token") ? Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => setState(() {
              isChangingPassword = false;
              _isLoading = false;
              _checkCurrentPassword = false;
              _checkNewPassword = false;
              _checkConfirmNewPassword = false;
              _checkPasswordMatching = false;
              newPasswordController.clear();
              currentPasswordController.clear();
              confirmNewPasswordController.clear();
            }),
            iconSize: 20,
            icon: Icon(
                Icons.arrow_back_ios,
                color: hexToColor(blackColor)
            ),
          ),
          actions: [
            Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Text(
                  "v${_packageInfo.version}",
                  style: blackTextStyle.copyWith(
                      fontFamily: fontFamily,
                      fontWeight: FontWeight.w200,
                      fontSize: 14,
                      color: Colors.black
                  ),
                ),
              ),
            ),
          ],
          elevation: 0,
          backgroundColor: Colors.transparent,
          centerTitle: true,
          title: Text('Change Password',
            style: blackTextStyle.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: hexToColor(blackColor)
            ),
          ),
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          margin: EdgeInsets.only(left: 15, right: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 300,
                child:
                Column(
                  children: [
                    Container(
                      child: TextField(
                        controller: currentPasswordController,
                        obscureText: _currentPasswordVisible,
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                              iconSize: 10,
                              onPressed: () => setState(() => _currentPasswordVisible = !_currentPasswordVisible),
                              icon: Icon(
                                _currentPasswordVisible ? FontAwesomeIcons.eye : FontAwesomeIcons.eyeSlash,
                                color: hexToColor(textGreyColor),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: hexToColor(textGreyColor),
                                  width: 1.0
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: hexToColor(dividerGreyColor),
                                  width: 3.0
                              ),
                            ),
                            errorStyle: blackTextStyle.copyWith(
                                fontSize: 9,
                                height: .08,
                                color: hexToColor(redColor)
                            ),
                            errorMaxLines: 1,
                            filled: true,
                            hintText: 'Current Password',
                            errorText: _checkCurrentPassword ? 'Current Password is required' :  null,
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
                      ),
                    ),
                    SizedBox(height: 16,),
                    Container(
                      child: TextField(
                        controller: newPasswordController,
                        obscureText: _newPasswordVisible,
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                              iconSize: 10,
                              onPressed: () => setState(() => _newPasswordVisible = !_newPasswordVisible),
                              icon: Icon(
                                _newPasswordVisible ? FontAwesomeIcons.eye : FontAwesomeIcons.eyeSlash,
                                color: hexToColor(textGreyColor),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: hexToColor(textGreyColor),
                                  width: 1.0
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: hexToColor(dividerGreyColor),
                                  width: 3.0
                              ),
                            ),
                            errorStyle: blackTextStyle.copyWith(
                                fontSize: 9,
                                height: .08,
                                color: hexToColor(redColor)
                            ),
                            errorMaxLines: 1,
                            filled: true,
                            hintText: 'New Password',
                            errorText: _checkNewPassword ? 'New Password is required'
                                : _checkPasswordMatching ? passwordInformation : null,
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
                      ),
                    ),
                    SizedBox(height: 16,),
                    Container(
                      child: TextField(
                        controller: confirmNewPasswordController,
                        obscureText: _confirmNewPasswordVisible,
                        cursorColor: hexToColor(blackColor),
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                              iconSize: 10,
                              onPressed: () => setState(() => _confirmNewPasswordVisible = !_confirmNewPasswordVisible),
                              icon: Icon(
                                _confirmNewPasswordVisible ? FontAwesomeIcons.eye : FontAwesomeIcons.eyeSlash,
                                color: hexToColor(textGreyColor),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: hexToColor(textGreyColor),
                                  width: 1.0
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: hexToColor(dividerGreyColor),
                                  width: 3.0
                              ),
                            ),
                            errorStyle: blackTextStyle.copyWith(
                                fontSize: 9,
                                height: .08,
                                color: hexToColor(redColor)
                            ),
                            errorMaxLines: 1,
                            filled: true,
                            hintText: 'Retype New Password',
                            errorText: _checkConfirmNewPassword ? 'Confirm Password is required'
                                : _checkPasswordMatching ? passwordInformation : null,
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
                      ),
                    ),
                    SizedBox(height: 16,),
                    !_isLoading ? Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          color: Colors.black
                      ),
                      width: double.infinity,
                      child: MaterialButton(
                        onPressed: () async {
                          if(newPasswordController.text.isNotEmpty && currentPasswordController.text.isNotEmpty
                              && confirmNewPasswordController.text.isNotEmpty){
                            if(confirmNewPasswordController.text.toString() == newPasswordController.text.toString()){
                              setState(() {
                                _checkPasswordMatching = false;
                                _isLoading = true;
                              });
                              aPiCalls.changePassword(
                                  currentPasswordController.text.toString(),
                                  newPasswordController.text.toString()).then((value) {
                                print(value.body.toString());
                                if(value.statusCode == 200 && jsonDecode(value.body)['code'] == 200){
                                  showNotification(
                                      message: jsonDecode(value.body)['description'],
                                      error: false
                                  );

                                  Future.delayed(Duration(milliseconds: 500), () =>
                                      setState(() {
                                        newPasswordController.clear();
                                        confirmNewPasswordController.clear();
                                        currentPasswordController.clear();
                                        _isLoading = false;
                                        isChangingPassword = false;
                                      })
                                  );
                                }else {
                                  setState(() => _isLoading = false);
                                  showNotification(
                                      message: jsonDecode(value.body)['description'],
                                      error: true
                                  );
                                }
                              });
                            }else {
                              setState(() {
                                passwordInformation = "New Passwords did not match";
                                _checkPasswordMatching = true;
                              });
                            }
                          }else if(newPasswordController.text.isEmpty && currentPasswordController.text.isEmpty
                              && confirmNewPasswordController.text.isEmpty) {
                            setState(() {
                              _checkCurrentPassword = true;
                              _checkNewPassword = true;
                              _checkConfirmNewPassword = true;
                            });
                          }else if (newPasswordController.text.isEmpty || currentPasswordController.text.isEmpty
                              || confirmNewPasswordController.text.isEmpty){
                            if(newPasswordController.text.isEmpty){
                              setState(() => _checkNewPassword = true);
                            }else if(currentPasswordController.text.isEmpty){
                              setState(() => _checkCurrentPassword = true);
                            }else if(confirmNewPasswordController.text.isEmpty){
                              setState(() => _checkConfirmNewPassword = true);
                            }
                          }
                        },
                        child: Text('Change Password',
                            style: blackTextStyle.copyWith(
                              color: Colors.white,
                              fontSize: 14,
                            )
                        ),
                      ),
                    ) : Center(
                      child: CircularProgressIndicator(
                        color: hexToColor(blackColor),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        )) : Login(fromCart: widget.fromCart);
  }
}
