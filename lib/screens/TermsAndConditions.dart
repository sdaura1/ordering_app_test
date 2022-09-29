import 'package:flutter/material.dart';
import 'package:ordering_app/components/LegalItem.dart';

import '../utils/Constants.dart';

class TermsAndConditions extends StatelessWidget {

  TermsAndConditions();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        centerTitle: false,
        title: Text('Terms of Service',
          style: blackTextStyle.copyWith(
            fontSize: 16,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 32,
                child: Divider(
                  endIndent: 16,
                  indent: 16,
                  thickness: 1,
                  color: hexToColor(dividerGreyColor),
                  height: 1,
                ),
              ),
              LegalItem(
                  heading: 'Patoosh Cafe Limited Terms of Service',
                  content: termsAndConditionsIntro),
              LegalItem(
                  heading: 'Information We Collect',
                  content: informationWeCollect),
              LegalItem(
                  heading: 'Log Data',
                  content: logData),
              LegalItem(
                  heading: 'Personal Information',
                  content: personalInformation),
              LegalItem(
                  heading: 'Collection and Use of Information',
                  content: personalInformation)
            ],
          ),
        ),
      ),
    );
  }
}
