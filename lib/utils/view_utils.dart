import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../utils/Constants.dart';

class ZainpayViewUtils {

  /// Displays a modal to confirm payment
  static Future<void> showConfirmPaymentModal(
      final BuildContext context,
      final Function onContinuePressed
      ) async => showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        content: Container(
          margin: const EdgeInsets.fromLTRB(20, 5, 20, 5),
          child: Text(
            "Your account will be deleted and all transaction history will be lost, do you wish to continue?",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: hexToColor(orangeColor),
              fontSize: 14,
              letterSpacing: 1.2,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith((states) => hexToColor(redColor))
            ),
            child: Text(
              "Cancel",
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                letterSpacing: 1,
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              await onContinuePressed();
              Navigator.pop(context);
            },
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith((states) => hexToColor(orangeColor))
            ),
            child: Text(
              "Yes, Continue",
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                letterSpacing: 1,
              ),
            ),
          ),
        ],
      );
    },
  );

  /// Shows progress dialog
  Future<void> showProgressDialog(
      final String message,
      final BuildContext context,
      final bool dismissible,
      final Widget? progressIndicator,
      final TextStyle? textStyle,
      final Color? dialogBackgroundColor) {
    final Widget indicator = progressIndicator
        ?? const CircularProgressIndicator(
            backgroundColor: Colors.orangeAccent);

    final style = textStyle
        ?? const TextStyle(color: Colors.black);

    return showDialog(
        context: context,
        barrierDismissible: dismissible,
        builder: (BuildContext context) =>
            AlertDialog(
              backgroundColor: dialogBackgroundColor,
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  indicator,
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: style,
                  )
                ],
              ),
            )
    );
  }

  static void _goBackToPaymentScreen(final BuildContext context) =>
      Navigator.of(context).pop();

  /// Creates a customised Appbar
  static AppBar appBar(
      final BuildContext context,
      final String title,
      final TextStyle appBarTitleTextStyle,
      final Icon appBarIcon,
      final Color appBarColor,
      [final Function? handleBackPress]) => AppBar(
    backgroundColor: appBarColor,
    titleTextStyle: appBarTitleTextStyle,
    leading: IconButton(
      icon: appBarIcon,
      onPressed: () => handleBackPress == null
          ? _goBackToPaymentScreen(context)
          : handleBackPress(),
    ),
    title: Text(title, style: appBarTitleTextStyle),
  );

  /// Displays a Snack bar
  static showSnackBar(BuildContext context, String text) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));


  /// Displays a toast notification
  static void showToast(BuildContext context, String text) =>
      Fluttertoast.showToast(
        msg: text,
        timeInSecForIosWeb: 5,
        backgroundColor: const Color(0xAA383737),
        textColor: Colors.white,
      );
}