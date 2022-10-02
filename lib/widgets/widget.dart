import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:helpout/style/app_theme.dart';

void showMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(message),
    behavior: SnackBarBehavior.floating,
  ));
}

Container customTextForm(
    TextInputAction action,
    TextEditingController controller,
    TextInputType textType,
    Function val,
    String labelText,
    IconData startIcon,
    bool obscureText) {
  return Container(
    alignment: Alignment.center,
    margin: const EdgeInsets.only(top: 30),
    padding: const EdgeInsets.only(left: 30, right: 30),
    height: 60,
    child: TextFormField(
      textInputAction: action,
      autofocus: false,
      controller: controller,
      keyboardType: textType,
      validator: (value) => val(value),
      onSaved: (value) {
        controller.text = value!;
      },
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        icon: Icon(startIcon),
        errorStyle: const TextStyle(height: 0),
        border: InputBorder.none,
      ),
      style: TextStyle(color: AppTheme.colors.regularText, fontSize: 15),
    ),
    decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: AppTheme.colors.paleText.withOpacity(0.3),
            spreadRadius: 4,
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ]),
  );
}

Container regularButton(
    String text, Color bgColor, Color textColor, Function onTap) {
  return Container(
    margin: const EdgeInsets.only(top: 30),
    child: InkWell(
      borderRadius: BorderRadius.circular(30),
      child: Ink(
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Text(
            text,
            style: TextStyle(
                color: textColor, fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ),
        decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: AppTheme.colors.paleText.withOpacity(0.3),
                spreadRadius: 4,
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
            ]),
      ),
      onTap: () {
        onTap();
      },
    ),
  );
}

Container regularButtonImage(String text, String imPath, Color bgColor,
    Color textColor, Function onTap) {
  return Container(
    margin: const EdgeInsets.only(top: 30),
    child: InkWell(
      borderRadius: BorderRadius.circular(30),
      child: Ink(
        child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Row(
              children: [
                Image.asset(
                  imPath,
                  width: 18,
                  height: 18,
                ),
                const SizedBox(width: 24),
                Text(
                  text,
                  style: TextStyle(
                      color: textColor,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
              ],
              // mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
            )),
        decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: AppTheme.colors.paleText.withOpacity(0.3),
                spreadRadius: 4,
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
            ]),
      ),
      onTap: () {
        onTap();
      },
    ),
  );
}

Container circleButton(String imPath, Color bgColor, Function onTap) {
  return Container(
    margin: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
    child: InkWell(
      borderRadius: BorderRadius.circular(30),
      child: Ink(
        child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 10),
            height: 50,
            width: 50,
            child: 
              SvgPicture.asset(imPath, fit: BoxFit.contain, color: Colors.white)
            ),
        decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: AppTheme.colors.paleText.withOpacity(0.3),
                spreadRadius: 4,
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
            ]),
      ),
      onTap: () {
        onTap();
      },
    ),
  );
}