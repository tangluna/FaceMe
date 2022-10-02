import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:helpout/onboarding/walkthrough.dart';
import 'package:helpout/style/app_theme.dart';
import 'package:helpout/login/sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:helpout/home/home.dart';
import 'package:flutter/services.dart';

bool? onboard;
bool? signedIn;

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  onboard = prefs.getBool('onboard') ?? false;
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseAuth.instance.authStateChanges().listen((user) {
    if (user == null) {
      signedIn = false;
    } else {
      signedIn = true;
    }
  });
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(HelpOut());
}

class HelpOut extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    String activityID = "HelpOut";
    log('$activityID: onboard:$onboard');
    log('$activityID: signedIn:$signedIn');

    var activity = null;

    if (onboard == true) {
      if (signedIn == true) {
        activity = Home();
        }
      else {
        activity = SignIn();
        }
    }
    else {
      activity = WT();
    }
  
    FlutterNativeSplash.remove();

    return MaterialApp(
      title: 'HelpOut',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.define(context),
      home: activity,
    );
  }

}