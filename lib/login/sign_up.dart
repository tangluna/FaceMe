import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:helpout/style/app_theme.dart';
import 'package:helpout/login/sign_in.dart';
import 'package:helpout/widgets/widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final formKey = GlobalKey<FormState>();
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');
  final FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController fNameController = TextEditingController();
  TextEditingController lNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    fNameController.dispose();
    lNameController.dispose();
    emailController.dispose();
    passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    return Scaffold(
        resizeToAvoidBottomInset: false, // screen doesn't shift up on keyboard
        body: Form(
            key: formKey,
            child: Center(
                child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.90,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Create an account",
                            style: TextStyle(
                              color: AppTheme.colors.regularBackground,
                              fontSize: 35,
                              fontWeight: FontWeight.bold,
                            )),

                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          child: Text(
                            "To get all the features of FaceMe",
                            style: TextStyle(
                              color: AppTheme.colors.paleText,
                              fontSize: 15,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),

                        // FIRST NAME TEXT FIELD
                        customTextForm(
                            TextInputAction.next,
                            fNameController,
                            TextInputType.text,
                            fNameValidator,
                            "First Name",
                            Icons.person,
                            false),

                        // LAST NAME TEXT FIELD
                        customTextForm(
                            TextInputAction.next,
                            lNameController,
                            TextInputType.text,
                            emailValidator,
                            "Last Name",
                            Icons.person,
                            false),

                        // EMAIL TEXT FIELD
                        customTextForm(
                            TextInputAction.next,
                            emailController,
                            TextInputType.emailAddress,
                            emailValidator,
                            "Email Address",
                            Icons.email,
                            false),

                        // PASSWORD TEXT FIELD
                        customTextForm(
                            TextInputAction.go,
                            passController,
                            TextInputType.text,
                            emailValidator,
                            "Password",
                            Icons.lock,
                            true),

                        // SIGN UP BUTTON
                        regularButton(
                            "Sign Up",
                            AppTheme.colors.regularBackground,
                            Colors.white,
                            emailSignUp),

                        Container(
                          margin: const EdgeInsets.only(top: 30),
                          child: Row(
                              // SIGN UP
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Already have an account? ",
                                    style: TextStyle(
                                        color: AppTheme.colors.regularText,
                                        fontSize: 15)),
                                InkWell(
                                  onTap: () {
                                    openSignIn();
                                  },
                                  child: Text("Sign In.",
                                      style: TextStyle(
                                        color: AppTheme.colors.regularText,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      )),
                                )
                              ]),
                        )
                      ],
                    )))));
  }

  String? fNameValidator(String? value) {
    if (value == null || value.isEmpty) {
      showMessage(context, "Please enter your first name!");
    }
    return null;
  }

  String? lNameValidator(String? value) {
    if (value == null || value.isEmpty) {
      showMessage(context, "Please enter your last name!");
    }
    return null;
  }

  String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      showMessage(context, "Please enter your email address!");
    }
    return null;
  }

  String? passValidator(String? value) {
    if (value == null || value.isEmpty) {
      showMessage(context, "Please enter your passsword!");
    }
    return null;
  }

  void openSignIn() {
    Navigator.of(context).pushReplacement(PageRouteBuilder(
      pageBuilder: (_, __, ___) => const SignIn(),
      transitionDuration: const Duration(seconds: 0),
    ));
  }

  void emailSignUp() async {
    FocusManager.instance.primaryFocus?.unfocus();
    final isValid = formKey.currentState?.validate();

    if (!isValid!) {
      return;
    }

    try {

      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: emailController.text, password: passController.text);

      uploadUserData();

      User? user = auth.currentUser;

      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        showMessage(context, "Please check your email for verification");
      }

      Navigator.of(context).pushReplacement(PageRouteBuilder(
        pageBuilder: (_, __, ___) => const SignIn(),
        transitionDuration: const Duration(seconds: 0),
      ));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showMessage(context, "The password provided is too weak.");
      } else if (e.code == 'email-already-in-use') {
        showMessage(context, "Account with this email already exists.");
      }
    } catch (e) {
      showMessage(context, "Some error occurred.");
    }
  }

  void uploadUserData() async {

    User? user = auth.currentUser;
    String uid = user!.uid;

    await userCollection.doc(uid).set({
      'First Name': fNameController.text,
      'Last Name': lNameController.text,
      'Email': emailController.text,
    });

    showMessage(context, "Created account successfully!");
  }
}