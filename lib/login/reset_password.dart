import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:helpout/style/app_theme.dart';
import 'package:helpout/widgets/widget.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword ({Key? key}) : super(key: key);

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {

  final formKey = GlobalKey<FormState>();
  final FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(
            color: AppTheme.colors.regularText,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: (){Navigator.pop(context,true);}
        ),
      ),

      body: Form(
        key: formKey,
        child: Center(child: SizedBox(
          width: MediaQuery.of(context).size.width*0.90,

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Text(
                  "Reset Password",
                  style: TextStyle(
                    color: AppTheme.colors.regularBackground,
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                  )
              ),

              Container(
                margin: const EdgeInsets.only(top: 10),
                child: Text(
                  "Please enter your email address. You will receive a link to create a new password via email.",
                  style: TextStyle(
                    color: AppTheme.colors.paleText,
                    fontSize: 15,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              // EMAIL TEXT FIELD
              customTextForm(
                TextInputAction.go,
                emailController, 
                TextInputType.emailAddress, 
                emailValidator,
                "Email Address",
                Icons.email, 
                false
              ),

              // SEND BUTTON
              regularButton(
                "Send", 
                AppTheme.colors.regularBackground,
                Colors.white, 
                sendResetEmail
              ),

            ],
          )
      ) )

    ));
  }

  void sendResetEmail() async {

    FocusManager.instance.primaryFocus?.unfocus();
    final isValid = formKey.currentState?.validate();

    if (!isValid!) { return; }

    try {
     await auth.sendPasswordResetEmail(email: emailController.text);
     showMessage(context, "Reset password email sent!");

    } on FirebaseAuthException catch (e) {
      showMessage(context, "Some error occured.");
    } 
  }

  String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      showMessage(context, "Please enter your email address!");
    }
    return null;
  }

}