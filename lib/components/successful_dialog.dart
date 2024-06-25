import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:wallet/config/routes/routes.dart';
import 'package:wallet/config/themes/app_palette.dart';
import 'package:wallet/config/themes/media_src.dart';

Future<void> successfulDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          'Success',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 28.sp,
              fontWeight: FontWeight.w700,
              color: Colors.green),
        ),
        content: Text(
          "You have successfully transfered token",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
        actions: <Widget>[
          Center(
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppPalette.primary,
                ),
                child: const Text(
                  'Continue',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
              ),
            ),
          ),
        ],
      );
    },
  );
}
