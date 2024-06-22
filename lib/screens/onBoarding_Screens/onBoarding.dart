import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wallet/config/routes/routes.dart';
import 'package:wallet/screens/onBoarding_Screens/onBoarding1.dart';
import 'package:wallet/screens/onBoarding_Screens/onBoarding2.dart';
import 'package:wallet/screens/onBoarding_Screens/onBoarding3.dart';

class OnBoarding extends StatelessWidget {
  final PageController _controller = PageController();

  OnBoarding({super.key});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            children: [
              OnBoarding1(
                onPressed: () {
                  _controller.animateToPage(1,
                      curve: Curves.decelerate,
                      duration: Duration(milliseconds: 300));
                },
              ),
              Onboarding2(
                onPressed: () {
                  _controller.animateToPage(2,
                      curve: Curves.decelerate,
                      duration: Duration(milliseconds: 300));
                },
              ),
              Onboarding3(
                onPressed: () {
                  context.pushReplacementNamed(Routes.accessWallet);
                },
              ),
            ],
          ),
          // Container(
          //   alignment: Alignment(0, 0.2),
          //   child: SmoothPageIndicator(
          //     controller: _controller,
          //     count: 3,
          //     effect: ExpandingDotsEffect(
          //       activeDotColor: Color(0xFFF1A852),
          //       dotColor: Color(0XFFE6E6F6),
          //       dotHeight: 9,
          //       dotWidth: 9,
          //       spacing: 10,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
