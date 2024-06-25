import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wallet/config/themes/app_palette.dart';
import 'package:wallet/config/themes/media_src.dart';

Future<void> chainDialog(
    BuildContext context, Function(String, String)? onTap) {
  List<Map<String, String>> networks = [
    {
      "name": "Ethereum Mainnet",
      "chain": 'eth',
      "logo": MediaResource.ethereumIC,
    },
    {
      "name": "Sepolia",
      "chain": 'sepolia',
      "logo": MediaResource.sepoliaIC,
    },
    {
      "name": "BSC Mainnet",
      "chain": 'bsc',
      "logo": MediaResource.binanceIC,
    },
    {
      "name": "BSC Testnet",
      "chain": 'bsc testnet',
      "logo": MediaResource.binanceIC,
    },
    {
      "name": "Polygon Mainnet",
      "chain": 'polygon',
      "logo": MediaResource.polygonIC,
    },
    {
      "name": "Polygon Amoy",
      "chain": 'polygon amoy',
      "logo": MediaResource.polygonIC,
    },
  ];

  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text(
          'Select a network',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var nw in networks)
              GestureDetector(
                onTap: () {
                  onTap!(nw["name"]!, nw["chain"]!);
                  Navigator.of(context).pop();
                },
                child: Card(
                  margin: EdgeInsets.all(8.0),
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SvgPicture.asset(
                          nw["logo"]!,
                        ),
                        SizedBox(width: 10.w),
                        Text(
                          nw['name']!,
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
          ],
        ),
        // actions: <Widget>[
        //   Center(
        //     child: SizedBox(
        //       width: double.infinity,
        //       child: ElevatedButton(
        //         style: ElevatedButton.styleFrom(
        //           backgroundColor: AppPalette.primary,
        //         ),
        //         child: const Text(
        //           'Try again',
        //           style: TextStyle(color: Colors.white),
        //         ),
        //         onPressed: () {
        //           Navigator.of(context).pop();
        //         },
        //       ),
        //     ),
        //   ),
        // ],
      );
    },
  );
}
