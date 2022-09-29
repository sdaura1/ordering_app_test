import 'package:flutter/material.dart';
import 'package:ordering_app/components/Login.dart';
import 'package:ordering_app/components/UserProfile.dart';

import '../utils/SharedPref.dart';

class Profile extends StatefulWidget {

  final bool fromCart;

  Profile({required this.fromCart});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SharedPref.contains("token")
          ? UserProfile(fromCart: widget.fromCart,)
          : Login(fromCart: widget.fromCart)
    );
  }
}
