import 'dart:io';
import 'package:flutter/material.dart';
import 'package:helpout/onboarding/slide.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:helpout/onboarding/slide_page.dart';
import 'package:helpout/onboarding/last_wt_page.dart';
import 'package:helpout/style/colors.dart';

class WT extends StatefulWidget {
  const WT({Key? key}) : super(key: key);

  @override
  _WTState createState() => _WTState();
}

class _WTState extends State<WT> {

  @override
  void initState() {
    super.initState();
    slides = getSlides();
  }

  List<WTSlide> slides = <WTSlide>[];
  int currentIdx = 0;
  PageController pageController = PageController(initialPage: 0);

  // Create list of Slides
  List<WTSlide> getSlides() {
    List<WTSlide> slides = <WTSlide>[];

    Future<void> getData() async {
      final String response =
          await rootBundle.loadString('assets/files/slides.json');
      final jsonData = await json.decode(response);

      setState(() {
        jsonData.forEach((item) {
          String title = item['title'] ?? '';
          String imgPath = item['img_path'] ?? '';
          String desc = item['desc'] ?? '';
          slides.add(WTSlide(title: title, imagePath: imgPath, desc: desc));
        });
      });
    }

    getData();
    return slides;
  }

  // for page/dot indicator at bottom center of screen
  Widget dotIndicator(bool isCurrentPage) {

    double large = 10.0;
    double small = 6.0;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2.0),
      height: isCurrentPage ? large : small,
      width: isCurrentPage ? large : small,
      decoration: BoxDecoration(
        color: isCurrentPage ? Colors.grey : Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double hpadding = 0.05 * width;
    double vpadding = 0.05 * height;

    Duration animTime = const Duration(milliseconds: 400);
    int finalIdx = slides.length - 1;

    return Scaffold(

        // content
        body: PageView.builder(
          controller: pageController,
          itemCount: slides.length,
          onPageChanged: (val) {
            setState(() {
              currentIdx = val;
            });
          },
          itemBuilder: (context, index) {
            if (currentIdx >= 0 && currentIdx < finalIdx) {
              return SlidePage(
              imagePath: slides[index].getImagePath(),
              title: slides[index].getTitle(),
              desc: slides[index].getDesc(),
            );
            }
            else {
              return LastWTPage();
            }
            
          },
        ),

        // top bar
        appBar: AppBar(
          backgroundColor: AppColors().colorCard,
          bottomOpacity: 0.0,
          elevation: 0.0,
          toolbarHeight: height*0.07, // Set this height
          flexibleSpace: Container(
            height: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: hpadding),
            child: SafeArea(child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                // NEXT BUTTON
                GestureDetector(
                    onTap: () {
                      if (currentIdx >= 0 && currentIdx < finalIdx) {
                        pageController.animateToPage(finalIdx,
                          duration: animTime,
                          curve: Curves.linear);
                      }
                      else {}
                    },
                    child: (currentIdx >= 0 && currentIdx < finalIdx) ?
                            const Text("SKIP") : Text("SKIP", style: TextStyle(color: Colors.black.withOpacity(0.0)))
                ),
              ],
            )
            ),
          ),
        ),
        bottomSheet:
          Container(
            color: AppColors().colorCard,
            height: height*0.10,
            padding: EdgeInsets.symmetric(horizontal: hpadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                // PREV BUTTON
                GestureDetector(
                    onTap: () {
                      if (currentIdx >= 1 && currentIdx <= finalIdx) {
                        pageController.animateToPage(currentIdx - 1,
                          duration: animTime,
                          curve: Curves.linear);
                      }
                      else {}
                    },
                    child: (currentIdx >= 1 && currentIdx <= finalIdx) ?
                            const Text("PREV") : Text("PREV", style: TextStyle(color: Colors.black.withOpacity(0.0)))
                ),
                // DOTS
                Row(
                  children: <Widget>[
                    for (int i = 0; i < slides.length; i++)
                      currentIdx == i
                          ? dotIndicator(true)
                          : dotIndicator(false)
                  ],
                ),
                // NEXT BUTTON
                GestureDetector(
                    onTap: () {
                      if (currentIdx >= 0 && currentIdx < finalIdx) {
                        pageController.animateToPage(currentIdx + 1,
                          duration: animTime,
                          curve: Curves.linear);
                      }
                      else {}
                    },
                    child: (currentIdx >= 0 && currentIdx < finalIdx) ?
                            const Text("NEXT") : Text("NEXT", style: TextStyle(color: Colors.black.withOpacity(0.0)))
                ),
              ],
            ),
          )       
      );
  }
  
}