import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:helpout/style/colors.dart';

// Code to display each slide in the WT
class SlidePage extends StatelessWidget {
  String imagePath, title, desc;
  SlidePage(
      {required this.imagePath, required this.title, required this.desc});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double hpadding = 0.05 * width;
    double vpadding = 0.05 * height;

    return Container(
      color: AppColors().colorCard,
      padding: EdgeInsets.symmetric(horizontal: hpadding),
      child: Column(
        children: <Widget>[
          SvgPicture.asset(imagePath, fit: BoxFit.contain, height: height * 0.5),
          SizedBox(height: vpadding),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          SizedBox(height: vpadding),
          Text(desc,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16))
        ],
      ),
    );
  }
}