import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wallet/config/themes/app_palette.dart';
import 'package:wallet/config/themes/media_src.dart';

class Onboarding2 extends StatelessWidget {
  final VoidCallback onPressed;

  const Onboarding2({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          GestureDetector(
            onTap: () {
              print("Tap");
            },
            child: Padding(
              padding: EdgeInsets.only(right: 20.w),
              child: Text(
                "Skip >>",
                style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w400),
              ),
            ),
          ),
        ],
        leading: GestureDetector(
          onTap: () {
            print("Tap");
          },
          child: Padding(
              padding: EdgeInsets.only(left: 20.w),
              child: Icon(Icons.arrow_back)),
        ),
      ),
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
                  MediaResource.onBoarding2,
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
                    width: 10.w,
                    height: 10.h,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.grey[300]),
                  ),
                ),
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
              ],
            ),
            Column(
              children: [
                SizedBox(
                  width: 250.w,
                  child: Text(
                    "Keep your crypto in one place",
                    style:
                        TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w700),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                SizedBox(
                  width: 300.w,
                  child: Text(
                    "We provide encrypted and save wallet to keep youor cryptocurrency assets in one place",
                    style:
                        TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w400),
                    textAlign: TextAlign.center,
                  ),
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
                    "Continue",
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
