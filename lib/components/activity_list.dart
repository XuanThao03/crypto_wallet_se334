import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:wallet/components/transaction_detail_dialog.dart';
import 'package:wallet/config/themes/media_src.dart';
import 'package:wallet/core/common/const/networks.dart';
import 'package:wallet/core/utils/get_balances.dart';
import 'package:web3dart/web3dart.dart';

class ActivityList extends StatefulWidget {
  final List<dynamic> activityList;
  final String publicKey;

  const ActivityList(
      {super.key, required this.activityList, required this.publicKey});

  @override
  State<ActivityList> createState() => _ActivityListState();
}

class _ActivityListState extends State<ActivityList> {
  String handleDateTime(String timestamp) {
    DateTime dateTime = DateTime.parse(timestamp);
    String formattedDate = DateFormat('MMM dd, yyyy').format(dateTime);
    return formattedDate;
  }

  String handleValue(String value) {
    EtherAmount valueEther =
        EtherAmount.fromBigInt(EtherUnit.wei, BigInt.parse(value));
    String formattedvalue =
        valueEther.getValueInUnit(EtherUnit.ether).toString();
    return formattedvalue.length > 8
        ? formattedvalue.substring(0, 8)
        : formattedvalue;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var act in widget.activityList)
          if (act["value"] != "0")
            GestureDetector(
              onTap: () {
                TransactionDialog(context, act, widget.publicKey);
              },
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      handleDateTime(act["block_timestamp"]),
                      style: TextStyle(fontSize: 16.sp),
                    ),
                    Container(
                      padding: EdgeInsets.only(bottom: 10.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SvgPicture.asset(
                                  act["from_address"] == widget.publicKey
                                      ? MediaResource.sendIC
                                      : MediaResource.receiveIC),
                              SizedBox(
                                width: 15.w,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    act["token_name"] ?? "SepoliaETH",
                                    style: TextStyle(
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    "Confirm",
                                    style: TextStyle(
                                        fontSize: 12.sp,
                                        color: Colors.green,
                                        fontWeight: FontWeight.w400),
                                  )
                                ],
                              ),
                            ],
                          ),
                          Text(
                            textAlign: TextAlign.end,
                            "${handleValue(act["value"])} ${act["token_symbol"] ?? "SepoliaETH"}",
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
      ],
    );
  }
}
