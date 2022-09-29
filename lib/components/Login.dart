import 'dart:async';
import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../functions/APICalls.dart';
import '../functions/DatabaseHelper.dart';
import '../models/CartModel.dart';
import '../screens/MainScreen.dart';
import '../screens/PrivacyPolicy.dart';
import '../screens/TermsAndConditions.dart';
import '../utils/Constants.dart';
import '../utils/SharedPref.dart';

class Login extends StatefulWidget {

  final bool fromCart;

  Login({required this.fromCart});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  TextEditingController passwordController = TextEditingController();
  TextEditingController registerPasswordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController registerPhoneController = TextEditingController();
  bool _phoneNumberCheck = false;
  bool _checkBoxValue = false;
  bool _registerNameCheck = false;
  bool _registerPhoneCheck = false;
  bool _passwordCheck = false;
  bool _registerPasswordCheck = false;
  bool _passwordVisible = true;
  bool _register = false;
  late APiCalls aPiCalls;
  List<CartModel> items = [];
  final dbHelper = DatabaseHelper.instance;
  int cartCount = 0;
  bool isLoading = false;
  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
  );

  @override
  void initState() {
    super.initState();
    aPiCalls = APiCalls();
    _query();
  }

  void _query() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
    cartCount = 0;
    items.clear();
    final allRows = await dbHelper.queryAllRows();
    for (var element in allRows) {
      setState(() => items.add(CartModel.fromJson(element)));
    }
    cartCount = (await dbHelper.queryRowCount())!;
  }

  @override
  Widget build(BuildContext context) {
    return !_register ? Scaffold(
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
          title: Text('Login',
            style: blackTextStyle.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: hexToColor(blackColor)
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            margin: EdgeInsets.only(left: 15, right: 15, top: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  cursorColor: hexToColor(blackColor),
                  decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: hexToColor(textGreyColor),
                            width: 1.0
                        ),
                      ),
                      errorStyle: blackTextStyle.copyWith(
                          fontSize: 9,
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
                      hintText: 'Phone Number',
                      errorText: _phoneNumberCheck ? 'Phone Number is required' :  null,
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
                SizedBox(height: 16,),
                TextField(
                  obscureText: _passwordVisible,
                  controller: passwordController,
                  minLines: 1,
                  cursorColor: hexToColor(blackColor),
                  decoration: InputDecoration(
                      suffixIcon: IconButton(
                        iconSize: 10,
                        onPressed: () => setState(() => _passwordVisible = !_passwordVisible),
                        icon: Icon(
                          _passwordVisible ? FontAwesomeIcons.eye : FontAwesomeIcons.eyeSlash,
                          color: hexToColor(textGreyColor),
                        ),
                      ),
                      errorStyle: blackTextStyle.copyWith(
                          fontSize: 8,
                          height: .08,
                          color: hexToColor(redColor)
                      ),
                      errorMaxLines: 1,
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
                      errorText: _passwordCheck ? 'Password is required' :  null,
                      filled: true,
                      hintText: 'Password',
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
                SizedBox(height: 20,),
                !isLoading ? Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        color: Colors.black
                    ),
                    width: double.infinity,
                    child: MaterialButton(
                      onPressed: () async {
                        if(passwordController.text.isNotEmpty
                            && phoneController.text.isNotEmpty){
                          setState(() => isLoading = true);
                          aPiCalls.login(phoneController.text.toString(),
                              passwordController.text.toString()).then((value) async {
                            if(value.statusCode == 200){
                              setState(() => isLoading = false);
                              await SharedPref.setToken(jsonDecode(value.body)["access_token"]);
                              await SharedPref.setId(jsonDecode(value.body)["id"]);
                              await SharedPref.setName(jsonDecode(value.body)["fullName"]);
                              await SharedPref.setPassword(passwordController.text.toString());
                              await SharedPref.setPhone(phoneController.text.toString());

                              showNotification(
                                message: 'Login successful',
                                error: false,
                              );

                              phoneController.clear();
                              passwordController.clear();

                              Future.delayed(Duration(milliseconds: 500), () {
                                if (cartCount > 0) {
                                  if (widget.fromCart) {
                                    Navigator.pop(context);
                                  } else {
                                    showNotification(
                                      message: 'Note: Cart contains items',
                                      error: false,
                                    );
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              MainScreen(destination: 2,
                                                  fromCart: false),
                                        )
                                    );
                                  }
                                }else {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (BuildContext context) => MainScreen(destination: 2, fromCart: false),
                                      )
                                  );
                                }
                              });


                            }else {
                              setState(() => isLoading = false);
                              showNotification(
                                message: 'Invalid Login credentials',
                                error: true,
                              );
                            }
                          });
                        }else if(passwordController.text.isEmpty && phoneController.text.isEmpty){
                          setState(() {
                            _passwordCheck = true;
                            _phoneNumberCheck = true;
                          });
                        }else if(phoneController.text.isEmpty && passwordController.text.isNotEmpty){
                          setState(() {
                            _passwordCheck = true;
                            _phoneNumberCheck = false;
                          });
                        }else if(phoneController.text.isNotEmpty && passwordController.text.isEmpty){
                          setState(() {
                            _passwordCheck = false;
                            _phoneNumberCheck = true;
                          });
                        }
                      },
                      child: Text('Login',
                          style: blackTextStyle.copyWith(
                            color: Colors.white,
                            fontSize: 14,
                          )
                      ),
                    )
                ) : Center(
                  child: CircularProgressIndicator(
                    color: hexToColor(blackColor),
                  ),
                ),
                SizedBox(height: 24,),
                GestureDetector(
                  onTap: () => setState(() {
                    _registerPhoneCheck = false;
                    _registerNameCheck = false;
                    _registerPasswordCheck = false;
                    _register = true;
                  }),
                  child: Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Don’t have an account?',
                          style: blackTextStyle.copyWith(
                              color: hexToColor(textGreyColor),
                              fontWeight: FontWeight.w400,
                              fontSize: 14
                          ),
                        ),
                        SizedBox(width: 3,),
                        Text('Register',
                          style: blackTextStyle.copyWith(
                              color: hexToColor(blackColor),
                              fontWeight: FontWeight.w400,
                              fontSize: 14
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        )) : Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          centerTitle: true,
          title: Text('Register',
            style: blackTextStyle.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: hexToColor(blackColor)
            ),),
        ),
        body: SingleChildScrollView(
            child: Container(
                height: MediaQuery.of(context).size.height,
                margin: EdgeInsets.only(left: 15, right: 15, top: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      child: TextField(
                        controller: nameController,
                        keyboardType: TextInputType.name,
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
                            hintText: 'Name',
                            errorText: _registerNameCheck ? 'Name is required' :  null,
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
                        controller: registerPhoneController,
                        keyboardType: TextInputType.phone,
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
                            hintText: 'Phone Number',
                            errorText: _registerPhoneCheck ? 'Phone Number is required' :  null,
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
                        controller: registerPasswordController,
                        obscureText: _passwordVisible,
                        keyboardType: TextInputType.visiblePassword,
                        minLines: 1,
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                              iconSize: 10,
                              onPressed: () => setState(() => _passwordVisible = !_passwordVisible),
                              icon: Icon(
                                _passwordVisible ? FontAwesomeIcons.eye : FontAwesomeIcons.eyeSlash,
                                color: hexToColor(textGreyColor),
                              ),
                            ),
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
                            hintText: 'Password',
                            errorText: _registerPasswordCheck ? 'Password is required' : null,
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
                    SizedBox(height: 10,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Checkbox(
                          value: _checkBoxValue,
                          onChanged: (bool? value) => setState(() => _checkBoxValue = value!),
                          checkColor: Colors.white,
                          fillColor: MaterialStateColor.resolveWith((states) => hexToColor(blackColor)),
                          side: BorderSide(
                            width: 1,
                            color: hexToColor(blackColor),
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(3)
                          ),
                        ),
                        Flexible(
                          child: RichText(
                            text: TextSpan(
                                text: 'I have read and accepted the Patoosh ',
                                style: blackTextStyle.copyWith(
                                    fontFamily: fontFamily,
                                    color: hexToColor(textEmailColor),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400
                                ),
                                children: [
                                  TextSpan(text: 'Privacy Policy',
                                    style: blackTextStyle.copyWith(
                                        fontFamily: fontFamily,
                                        color: hexToColor(blackColor),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400
                                    ),
                                    recognizer: TapGestureRecognizer()..onTap = () => Navigator.push(context,
                                      MaterialPageRoute(
                                        builder: (BuildContext context) => PrivacyPolicy(),
                                      ),
                                    ),),
                                  TextSpan(text: ' and ',
                                      style: blackTextStyle.copyWith(
                                          fontFamily: fontFamily,
                                          color: hexToColor(textEmailColor),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400
                                      )),
                                  TextSpan(text: 'Terms and Conditions',
                                    style: blackTextStyle.copyWith(
                                        fontFamily: fontFamily,
                                        color: hexToColor(blackColor),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400
                                    ),
                                    recognizer: TapGestureRecognizer()..onTap = () => Navigator.push(context,
                                      MaterialPageRoute(
                                        builder: (BuildContext context) => TermsAndConditions(),
                                      ),
                                    ),),
                                ]),),
                        ),
                      ],
                    ),
                    SizedBox(height: 16,),
                    !isLoading ? Container(
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(4)),
                            color: registerPasswordController.text.isNotEmpty
                                && nameController.text.isNotEmpty
                                && registerPhoneController.text.isNotEmpty
                                && _checkBoxValue ? Colors.black : hexToColor(dividerGreyColor)
                        ),
                        width: double.infinity,
                        child: MaterialButton(
                          onPressed: () async {
                            if(registerPasswordController.text.isNotEmpty
                                && nameController.text.isNotEmpty
                                && registerPhoneController.text.isNotEmpty
                                && _checkBoxValue){
                              setState(() => isLoading = true);
                              aPiCalls.register(nameController.text.toString(),
                                  registerPhoneController.text.toString(),
                                  registerPasswordController.text.toString())
                                  .then((value) async {
                                if(value.statusCode == 200){
                                  setState(() => isLoading = false);
                                  showNotification(
                                      message: 'Account Created Successfully',
                                      error: false
                                  );
                                  Future.delayed(const Duration(milliseconds: 500),
                                          () => setState(() => _register = false));
                                }else {
                                  setState(() => isLoading = false);
                                  showNotification(
                                      message: 'Account Not Created',
                                      error: true
                                  );
                                }
                              });
                            }else if(registerPasswordController.text.isEmpty
                                && nameController.text.isEmpty
                                && registerPhoneController.text.isEmpty) {
                              setState(() {
                                _registerPasswordCheck = true;
                                _registerNameCheck = true;
                                _registerPhoneCheck = true;
                              });
                            }else if(registerPasswordController.text.isEmpty
                                || nameController.text.isEmpty
                                || registerPhoneController.text.isEmpty
                                || !_checkBoxValue) {
                              if(registerPasswordController.text.isEmpty){
                                setState(() => _registerPasswordCheck = true);
                              }else if(nameController.text.isEmpty){
                                setState(() => _registerNameCheck = true);
                              }else if(registerPhoneController.text.isEmpty){
                                setState(() => _registerPhoneCheck = true);
                              }
                            }
                          },

                          child: Text('Register',
                              style: blackTextStyle.copyWith(
                                color: Colors.white,
                                fontSize: 14,
                              )
                          ),
                        )
                    ) : Center(
                      child: CircularProgressIndicator(
                        color: hexToColor(blackColor),
                      ),
                    ),
                    SizedBox(height: 24),
                    GestureDetector(
                      onTap: (() {
                        setState(() {
                          _passwordCheck = false;
                          _phoneNumberCheck = false;
                          _register = false;
                        });
                      }),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Already have an account?',
                            style: blackTextStyle.copyWith(
                                color: hexToColor(textGreyColor),
                                fontWeight: FontWeight.w400,
                                fontSize: 14
                            ),
                          ),
                          SizedBox(width: 3),
                          Text('Login instead',
                            style: blackTextStyle.copyWith(
                                color: hexToColor(blackColor),
                                fontWeight: FontWeight.w400,
                                fontSize: 14
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                )
            )
        )
    );
  }
}
