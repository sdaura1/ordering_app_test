import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static SharedPreferences? _sharedPreferences;
  static const _keyToken = "token";
  static const _keyId = "id";
  static const _keyName = "name";
  static const _keyEmail = "email";
  static const _keyPassword = "password";
  static const _keyPhone = "phone";
  static const _keyReference = "reference";
  static const _keyFirstLaunch = "firstLaunch";

  static Future init() async => _sharedPreferences = await SharedPreferences.getInstance();

  static Future setToken(String token) async => _sharedPreferences!.setString(_keyToken, token);
  static Future setId(String id) async => _sharedPreferences!.setString(_keyId, id);
  static Future setName(String name) async => _sharedPreferences!.setString(_keyName, name);
  static Future setEmail(String email) async => _sharedPreferences!.setString(_keyEmail, email);
  static Future setPassword(String password) async => _sharedPreferences!.setString(_keyPassword, password);
  static Future setPhone(String phone) async => _sharedPreferences!.setString(_keyPhone, phone);
  static Future setReference(String reference) async => _sharedPreferences!.setString(_keyReference, reference);
  static Future setFirstLaunch(bool firstLaunch) async => _sharedPreferences!.setBool(_keyFirstLaunch, firstLaunch);
  static Future clear() async => _sharedPreferences!.clear();

  static bool contains(String key) => _sharedPreferences!.containsKey(key);
  static String getPassword() => _sharedPreferences!.getString(_keyPassword)!;
  static String getPhone() => _sharedPreferences!.getString(_keyPhone)!;
  static String getReference() => _sharedPreferences!.getString(_keyReference)!;
  static String getToken() => _sharedPreferences!.getString(_keyToken)!;
  static String getId() => _sharedPreferences!.getString(_keyId)!;
  static String getEmail() => "info@betastack.ng";
  static String getName() => _sharedPreferences!.getString(_keyName)!;
  static bool getFirstLaunch() => _sharedPreferences!.getBool(_keyFirstLaunch) ?? false;


  static Random _rnd = Random();
  static const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';

  static String getRandomString(int length) =>
      String.fromCharCodes(Iterable.generate(
          length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))
      ));

}