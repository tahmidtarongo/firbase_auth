import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_pos/GlobalComponents/button_global.dart';
import 'package:mobile_pos/Screens/Authentication/phone.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../constant.dart';

class OnBoard extends StatefulWidget {
  const OnBoard({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _OnBoardState createState() => _OnBoardState();
}

class _OnBoardState extends State<OnBoard> {
  PageController pageController = PageController(initialPage: 0);
  int currentIndexPage = 0;
  String buttonText = 'Next';

  List<Map<String, dynamic>> sliderList = [
    {
      "icon": 'images/onboard1.png',
      "title": 'Easy to use mobile pos',
      "description": 'Maan POS app is free, easy to use. In fact, it\'s one of the best  POS systems around the world.',
    },
    {
      "icon": 'images/onboard2.png',
      "title": 'Choose your features',
      "description": 'Features are the important part which makes Maan  POS different from traditional solutions.',
    },
    {
      "icon": 'images/onboard3.png',
      "title": 'All business solutions',
      "description": 'Maan POS is a complete business solution with stock, account, sales, expense & loss/profit.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: TextButton(
              onPressed: () {
                const PhoneAuth().launch(context);
              },
              child: Text(
                'Skip',
                style: GoogleFonts.jost(
                  fontSize: 20.0,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 20, bottom: 20),
            height: 550,
            width: context.width(),
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                PageView.builder(
                  itemCount: sliderList.length,
                  controller: pageController,
                  onPageChanged: (int index) => setState(() => currentIndexPage = index),
                  itemBuilder: (_, index) {
                    return Column(
                      children: [
                        const SizedBox(height: 30),
                        Image.asset(sliderList[index]['icon'], fit: BoxFit.fill, width: context.width() - 100, height: context.width() - 100),
                        const SizedBox(height: 30),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            sliderList[index]['title'].toString(),
                            style: GoogleFonts.jost(
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        // ignore: sized_box_for_whitespace
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                          // ignore: sized_box_for_whitespace
                          child: Container(
                            width: context.width(),
                            child: Text(
                              sliderList[index]['description'].toString(),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 5,
                              style: GoogleFonts.jost(
                                fontSize: 15.0,
                                color: kGreyTextColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
          DotIndicator(
            currentDotSize: 25,
            dotSize: 6,
            pageController: pageController,
            pages: sliderList,
            indicatorColor: kMainColor,
            unselectedIndicatorColor: Colors.grey,
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(right: 10.0, left: 10),
            child: ButtonGlobal(
              iconWidget: null,
              buttontext: currentIndexPage == 2 ? "Use Maan POS" : buttonText,
              iconColor: Colors.white,
              buttonDecoration: kButtonDecoration.copyWith(color: kMainColor, borderRadius: const BorderRadius.all(Radius.circular(30))),
              onPressed: () {
                setState(
                  () {
                    currentIndexPage < 2
                        ? pageController.nextPage(duration: const Duration(microseconds: 1000), curve: Curves.bounceInOut)
                        : const PhoneAuth().launch(context);
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
