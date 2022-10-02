import 'dart:convert';
import "package:http/http.dart" as http;
import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:helpout/style/app_theme.dart';
import 'package:helpout/widgets/widget.dart';
import 'package:helpout/login/sign_in.dart';
import 'package:helpout/login/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');
  final FirebaseAuth auth = FirebaseAuth.instance;
  UserModel userModel = UserModel(firstName: "", lastName: "", email: "");

  List<CameraDescription> cameras = [];
  CameraController? cameraController;
  int direction = 0;
  String final_response = "Not Initialized";

  @override
  void initState() {
    startCamera(direction);

    User? user = auth.currentUser;
    String uid = user!.uid;

    final userRef = userCollection.doc(uid);
    userRef.get().then(
      (doc) {
        userModel = UserModel.fromFirestore(doc.data());
        setState(() {});
      },
      onError: (e) => print("Error getting document: $e"),
    );

    super.initState();
  }

  // CAMERA STUFF
  void startCamera(int direction) async {
    cameras = await availableCameras();
    cameraController = CameraController(
      cameras[direction],
      ResolutionPreset.high,
      imageFormatGroup: ImageFormatGroup.jpeg,
      enableAudio: false,
    );

    await cameraController?.initialize().then((value) {
      if (!mounted) {
        return;
      }
      setState(() {}); // to refresh widget
    }).catchError((e) {
      print(e);
    });
  }

  @override
  void dispose() {
    cameraController!.dispose();
    super.dispose();
  }

  Container displayCameraPreview() {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double hpadding = 0.05 * width;
    double vpadding = 0.05 * height;

    if (cameraController != null) {
      return Container(
        alignment: Alignment.center,
        margin: EdgeInsets.symmetric(horizontal: hpadding, vertical: vpadding),
        width: width * 0.5,
        child: AspectRatio(
          aspectRatio: cameraController!.value.aspectRatio,
          child: CameraPreview(cameraController!),
        ),
      );
    } else {
      return Container(
        alignment: Alignment.center,
        margin: EdgeInsets.symmetric(horizontal: hpadding, vertical: vpadding),
        width: width * 0.5,
        decoration: BoxDecoration(
          border: Border.all(),
        ),
        child: const Text("Image here"),
      );
    }
  }

  void flip_camera() {
    print("in flip camera");
    setState(() {
      direction = direction == 0 ? 1 : 0;
      startCamera(direction);
    });
  }

  Future<XFile?> takePicture() async {
    if (cameraController!.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }
    try {
      XFile file = await cameraController!.takePicture();
      return file;
    } on CameraException catch (e) {
      print('Error occured while taking picture: $e');
      return null;
    }
  }

  void capture_camera() async {
    print("capture camera");
    if (cameraController == null) return;
    XFile? rawImage = await takePicture();
    final bytes = await rawImage!.readAsBytes();
    String base64Encode(List<int> bytes) => base64.encode(bytes);
    var url = Uri.http('127.0.0.1:5000', "/");
    String json_ = jsonEncode(base64Encode(bytes));
    final response = await http.post(url, body: json_);
    // print("Response" + response.body);
    final new_response = await http.get(url);
    final decoded = json.decode(new_response.body) as Map<String, dynamic>;

    setState(() {
      final_response = decoded["label"];
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    return Scaffold(
        resizeToAvoidBottomInset: false, // screen doesn't shift up on keyboard

        // BODY
        body: Center(
            child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.90,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Welcome, " + userModel.firstName.toString(),
                        style: TextStyle(
                          color: AppTheme.colors.regularBackground,
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                        )),
                    displayCameraPreview(),
                    Text(
                      "Identified Person: " + final_response,
                      style: TextStyle(
                          color: AppTheme.colors.regularBackground,
                          fontSize: 15,
                          fontWeight: FontWeight.normal,),
                    ),
                    Row(
                      children: [
                        circleButton('assets/vectors/ic_flip_camera.svg',
                            AppTheme.colors.regularBackground, flip_camera),
                        circleButton('assets/vectors/ic_capture.svg',
                            AppTheme.colors.regularBackground, capture_camera),
                      ],
                      mainAxisAlignment: MainAxisAlignment.center,
                    ),
                    regularButton("Sign Out", AppTheme.colors.regularBackground,
                        Colors.white, signOut),
                  ],
                ))));
  }

  void signOut() async {
    await auth.signOut();
    Navigator.of(context).pushReplacement(PageRouteBuilder(
      pageBuilder: (_, __, ___) => const SignIn(),
      transitionDuration: const Duration(seconds: 0),
    ));
  }
}
