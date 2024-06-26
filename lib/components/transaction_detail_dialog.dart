import 'dart:convert';
import 'dart:ffi';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wallet/config/routes/routes.dart';
import 'package:wallet/config/themes/app_palette.dart';
import 'package:wallet/config/themes/media_src.dart';
import 'package:wallet/core/utils/get_activities.dart';
import 'package:wallet/core/utils/get_ether_value.dart';
import 'package:web3dart/web3dart.dart';

Future<void> TransactionDialog(
    BuildContext context, Map transaction, String walletAddress) async {
  print("Map $transaction");

  // EtherAmount value =
  //     EtherAmount.fromBigInt(EtherUnit.wei, BigInt.parse(transaction["value"]));
  String valueStr = GetEtherValue(transaction["value"]);

  List detailLabel = [
    "Nonce",
    "Amount",
    "Gas Price",
    "Transaction Fee",
    "Total"
  ];

  List detailValue = [];
  String urlTransaction =
      'https://sepolia.etherscan.io/tx/${transaction["hash"] ?? transaction["transaction_hash"]}';

  _launchURL(urlStr) async {
    final Uri url = Uri.parse(urlStr);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  void copyToClipboard() {
    Clipboard.setData(ClipboardData(text: transaction["hash"]));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Transaction ID Copied to Clipboard')),
    );
  }

  var response = await getDecodedTransaction(walletAddress, 'sepolia');
  List decodedData = json.decode(response)["result"];
  print("arrayDdecodedDataata $decodedData");

  if (transaction["nonce"] != null) {
    detailValue = [
      transaction["nonce"],
      valueStr,
      GetEtherValue(transaction["gas_price"]),
      transaction["transaction_fee"].toString().substring(0, 12),
      (double.parse(valueStr) +
              double.parse(GetEtherValue(transaction["gas_price"])))
          .toStringAsFixed(12)
    ];
  } else {
    var finding = decodedData
        .where((e) => e["hash"] == transaction["transaction_hash"])
        .toList();

    if (finding.isEmpty) {
      detailLabel = [
        "Amount",
        "Token Name",
        "Token Symbol",
        "Transaction Index"
      ];
      detailValue = [
        transaction["value_decimal"],
        transaction["token_name"],
        transaction["token_symbol"],
        transaction["transaction_index"],
      ];
    } else {
      print("finding $finding");

      // print("mapValue ${mapValue["0"]}");
      // print("mapValue ${mapValue["gas_price"]}");
      Map finalValue = finding[0];

      detailValue = [
        finalValue["nonce"],
        transaction["value_decimal"],
        GetEtherValue(finalValue["gas_price"]),
        finalValue["transaction_fee"].toString().substring(0, 12),
        (double.parse(transaction["value_decimal"]) +
                double.parse(GetEtherValue(finalValue["gas_price"])))
            .toStringAsFixed(12)
      ];
    }
  }

  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          'Receive',
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 28.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                _launchURL(urlTransaction);
              },
              child: Text(
                "View on block explorer",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.blue),
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            GestureDetector(
              onTap: () {
                copyToClipboard();
              },
              child: Text(
                "Copy transaction ID",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.blue),
              ),
            ),
            SizedBox(
              height: 15.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Status",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  "Confirmed",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w300,
                      color: Colors.green),
                ),
              ],
            ),
            SizedBox(
              height: 15.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "From",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  "To",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                    "${transaction["from_address"].toString().substring(0, 8)}..."),
                Icon(Icons.arrow_forward_outlined),
                Text(
                    "${transaction["to_address"].toString().substring(0, 8)}..."),
              ],
            ),
            SizedBox(
              height: 15.h,
            ),
            Text(
              "Transaction",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            for (int i = 0; i < detailLabel.length; i++)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 5.h),
                    child: Text(
                      detailLabel[i],
                      style: TextStyle(
                          fontWeight: FontWeight.w300, fontSize: 14.sp),
                    ),
                  ),
                  Text(
                    detailValue[i].toString(),
                    style:
                        TextStyle(fontWeight: FontWeight.w300, fontSize: 14.sp),
                  ),
                ],
              )
          ],
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
                  'Close',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
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
