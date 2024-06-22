import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:wallet/config/routes/routes.dart';
import 'package:wallet/config/themes/app_palette.dart';
import 'package:wallet/config/themes/media_src.dart';

class OnBoarding1 extends StatelessWidget {
  final VoidCallback onPressed;

  const OnBoarding1({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [
        GestureDetector(
          onTap: () {
            context.pushReplacementNamed(Routes.accessWallet);
          },
          child: Padding(
            padding: EdgeInsets.only(right: 20.w),
            child: Text(
              "Skip >>",
              style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w400),
            ),
          ),
        ),
      ]),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 36.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              // color: Colors.amber,
              child: Center(
                child: SvgPicture.asset(
                  MediaResource.onBoarding1IC,
                  width: 450.w,
                  height: 300.h,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 3.w),
                  child: Container(
                    width: 30.w,
                    height: 10.h,
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: AppPalette.primary,
                        borderRadius: BorderRadius.circular(10.r)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 3.w),
                  child: Container(
                    width: 10.w,
                    height: 10.h,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.grey[300]),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 3.w),
                  child: Container(
                    width: 10.w,
                    height: 10.h,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.grey[300]),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Text(
                  "Welcome to SE334Wallet",
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 10.h,
                ),
                Text(
                  "Trust by millions, SE334Wallet is a secure wallet making the works of web3 accessible to all",
                  style:
                      TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w400),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            SizedBox(
              width: double.infinity,
              height: 48.h,
              child: ElevatedButton(
                  onPressed: onPressed,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppPalette.primary),
                  child: Text(
                    "Get Started",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16.sp,
                        color: AppPalette.background),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
