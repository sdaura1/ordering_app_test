import 'dart:async';

import 'package:flutter/material.dart';
import 'package:new_version/new_version.dart';
import 'package:ordering_app/screens/Cart.dart';
import 'package:ordering_app/screens/MainScreen.dart';
import 'package:ordering_app/screens/SplashScreen.dart';
import 'package:ordering_app/utils/Constants.dart';
import 'package:ordering_app/utils/SharedPref.dart';
import 'package:overlay_support/overlay_support.dart';

import 'functions/DatabaseHelper.dart';
import 'models/CartModel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPref.init();
  runApp(
      const MaterialApp(
          debugShowCheckedModeBanner: false,
          home: MyApp()
      )
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  Timer? _timer;
  final _navigatorKey = GlobalKey<NavigatorState>();
  List<String> ids = [];
  final dbHelper = DatabaseHelper.instance;

  @override
  void initState() {
    super.initState();

    final newVersion = NewVersion(
      iOSId: "com.brandage.ordering_app",
      androidId: "com.brandage.ordering_app",
    );

    const simpleBehavior = true;

    if(simpleBehavior){
      debugPrint("Basic");
      basicStatusCheck(newVersion);
    }

    _initializeTimer();
  }

  basicStatusCheck(NewVersion newVersion) {
    newVersion.showAlertIfNecessary(context: context);
  }

  advancedStatusCheck(NewVersion newVersion) async {
    final status = await newVersion.getVersionStatus();
    if (status != null) {
      newVersion.showUpdateDialog(
        context: context,
        versionStatus: status,
        dialogTitle: 'Patoosh Update',
        dialogText: 'Please update your app for a better experience',
      );
    }
  }

  void _initializeTimer() {
    if (_timer != null) {
      _timer!.cancel();
    }

    _timer = Timer(const Duration(minutes: 10), _route);
  }

  Future<void> _query() async {
    final allRows = await dbHelper.queryAllRows();
    for (var element in allRows) {
      var cartItem = CartModel.fromJson(element);
      ids.add(cartItem.id);
    }
  }

  void _handleUserInteraction([_]) {
    _initializeTimer();
  }

  void _route() async {
    _timer?.cancel();
    _timer = null;

    await _query();

    for (var id in ids) {
      dbHelper.delete(id);
    }
    SharedPref.clear().then((value) {
      _navigatorKey.currentState?.pop(context);
      _navigatorKey.currentState?.pushReplacement(
          MaterialPageRoute(
              builder: (context) => MainScreen(destination: 0, fromCart: false))
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(
        child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: _handleUserInteraction,
            onPanDown: _handleUserInteraction,
            child: MaterialApp(
              initialRoute: '/',
              routes: {
                '/cart': (context) => const Cart(),
                '/mainscreen': (context) => MainScreen(destination: 0, fromCart: false)
              },
              title: 'Ordering App',
              theme: ThemeData(
                  primarySwatch: Colors.blue,
                  fontFamily: fontFamily
              ),
              debugShowCheckedModeBanner: false,
              home: Navigator(
                initialRoute: '/',
                key: _navigatorKey,
                onGenerateRoute: (settings) => MaterialPageRoute(builder: (context) => SplashScreen()),
              ),
            )
        )
    );
  }
}