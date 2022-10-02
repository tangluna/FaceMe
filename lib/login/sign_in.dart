import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:helpout/style/app_theme.dart';
import 'package:helpout/login/reset_password.dart';
import 'package:helpout/login/sign_up.dart';
import 'package:helpout/widgets/widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:helpout/home/home.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final formKey = GlobalKey<FormState>();
  final FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

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
                        Text("FaceMe",
                            style: TextStyle(
                              color: AppTheme.colors.regularBackground,
                              fontSize: 35,
                              fontWeight: FontWeight.bold,
                            )),

                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          child: Text(
                            "Sign into your account here.",
                            style: TextStyle(
                              color: AppTheme.colors.paleText,
                              fontSize: 15,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),

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
                            passValidator,
                            "Password",
                            Icons.lock,
                            true),

                        // SIGN IN BUTTON
                        regularButton(
                            "Sign In",
                            AppTheme.colors.regularBackground,
                            Colors.white,
                            emailSignIn),

                        // FORGOT PASSWORD
                        Container(
                          alignment: Alignment.centerRight,
                          child: Container(
                            margin: const EdgeInsets.only(top: 20),
                            child: InkWell(
                              onTap: () {
                                forgotPassword();
                              },
                              child: Text("Forgot Password?",
                                  style: TextStyle(
                                      color: AppTheme.colors.paleText,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ),

                        // OR
                        Container(
                          width: MediaQuery.of(context).size.width * 0.50,
                          margin: const EdgeInsets.only(top: 30),
                          child: Row(children: <Widget>[
                            Expanded(
                                child: Divider(
                              color: AppTheme.colors.paleText,
                            )),
                            Text("\t\tor\t\t",
                                style: TextStyle(
                                  color: AppTheme.colors.paleText,
                                  fontSize: 15,
                                )),
                            Expanded(
                                child: Divider(
                              color: AppTheme.colors.paleText,
                            )),
                          ]),
                        ),

                        // SIGN IN GOOGLE BUTTON
                        regularButtonImage(
                            "Continue with Google",
                            "assets/images/google.png",
                            Colors.white,
                            AppTheme.colors.paleText,
                            googleSignIn),

                        Container(
                          margin: const EdgeInsets.only(top: 30),
                          child: Row(
                              // SIGN UP
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Don't have an account? ",
                                    style: TextStyle(
                                        color: AppTheme.colors.regularText,
                                        fontSize: 15)),
                                InkWell(
                                  onTap: () {
                                    openSignUp();
                                  },
                                  child: Text("Sign Up.",
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

  String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      showMessage(context, "Please enter your email address!");
    }
    return null;
  }

  String? passValidator(String? value) {
    if (value == null || value.isEmpty) {
      showMessage(context, "Please enter your password!");
    }
    return null;
  }

  void emailSignIn() async {
    FocusManager.instance.primaryFocus?.unfocus();
    final isValid = formKey.currentState?.validate();

    if (!isValid!) {
      return;
    }

    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: emailController.text, password: passController.text);

      Navigator.of(context).pushReplacement(PageRouteBuilder(
        pageBuilder: (_, __, ___) => const Home(),
        transitionDuration: const Duration(seconds: 0),
      ));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showMessage(context, "There is no account for this email.");
      } else if (e.code == 'wrong-password') {
        showMessage(context, "The password is incorrect.");
      } else {
        showMessage(context, "Some error occurred.");
      }
    }
  }

  void googleSignIn() async {
    print("AHHH poop");

    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser!.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    await auth.signInWithCredential(credential);
  }

  void openSignUp() {
    Navigator.of(context).pushReplacement(PageRouteBuilder(
      pageBuilder: (_, __, ___) => const SignUp(),
      transitionDuration: const Duration(seconds: 0),
    ));
  }

  void forgotPassword() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const ResetPassword()));
  }
}
