import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:helpout/widgets/widget.dart';
import 'package:helpout/style/app_theme.dart';
import 'package:helpout/style/colors.dart';
import 'package:helpout/login/sign_up.dart';
import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';

// Last page
class LastWTPage extends StatelessWidget {

  String activityID = "LastWTPage";
  LastPage(){}

  _markVisited() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboard', true);
  }

  @override
  Widget build(BuildContext context) {

    void goToSignUp() {
      log('$activityID: Moving to SignUp page');
      _markVisited();
      Navigator.of(context).pushReplacement(PageRouteBuilder(
        pageBuilder: (_, __, ___) => const SignUp(),
        transitionDuration: const Duration(seconds: 0),
      ));
  }

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double hpadding = 0.05 * width;
    double vpadding = 0.05 * height;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: hpadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Ready to Begin?",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 30, color: AppColors.colorPrimaryDark),
          ),
          SizedBox(height: vpadding),
          Container(
            width: width*0.5, 
            child: regularButton("Yes", AppTheme.colors.regularBackground, Colors.white, goToSignUp)
            )
        ],
      ),
    );


  }

}