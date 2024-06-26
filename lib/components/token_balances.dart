import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wallet/core/common/const/networks.dart';
import 'package:wallet/core/utils/get_balances.dart';
import 'package:web3dart/web3dart.dart';

class TkBalancesList extends StatefulWidget {
  final List<dynamic> tkList;

  const TkBalancesList({super.key, required this.tkList});

  @override
  State<TkBalancesList> createState() => _TkBanlancesListState();
}

class _TkBanlancesListState extends State<TkBalancesList> {
  @override
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var tk in widget.tkList)
          Card(
            margin: EdgeInsets.all(8.0),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    tk['token'],
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    tk['balance'],
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w300,
                    ),
                  )
                ],
              ),
            ),
          )
      ],
    );
  }
}
