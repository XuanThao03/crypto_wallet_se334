import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:wallet/components/successful_dialog.dart';
import 'package:wallet/config/themes/media_src.dart';
import 'package:wallet/core/common/const/networks.dart';
import 'package:wallet/core/utils/contract.dart';
import 'package:wallet/core/utils/get_balances.dart';
import 'package:web3dart/web3dart.dart';

class SendTokensPage extends StatefulWidget {
  final List tokenList;
  final String privateKey;
  final String chainID;

  SendTokensPage(
      {super.key,
      required this.privateKey,
      required this.tokenList,
      required this.chainID});

  @override
  State<SendTokensPage> createState() => _SendTokensPageState();
}

class _SendTokensPageState extends State<SendTokensPage> {
  final TextEditingController recipientController = TextEditingController();

  final TextEditingController amountController = TextEditingController();

  late String _balance;
  String _estimatedFee = "0";
  late String? _selectedToken;

  @override
  void initState() {
    _balance = widget.tokenList[0]["balance"];
    _selectedToken = widget.tokenList[0]["address"];
  }

  Future<void> loadTransactionData() async {
    var apiUrl =
        'https://eth-sepolia.g.alchemy.com/v2/9CHWPQ9T5RM-zml0NglGU8uDjNKAYO0d'; // Replace with your API
    // Replace with your API
    var httpClient = http.Client();
    var ethClient = Web3Client(apiUrl, httpClient);
    EthPrivateKey credentials = EthPrivateKey.fromHex('0x' + widget.privateKey);
    EtherAmount etherAmount = await ethClient.getBalance(credentials.address);

    // Gas Price
    EtherAmount gasPrice = await ethClient.getGasPrice();

    // Calculate Gas Fee (Gas Price * Gas Amount)
    EtherAmount estimatedGasFee = EtherAmount.inWei(
      BigInt.from(gasPrice.getValueInUnit(EtherUnit.wei)),
    );

    setState(() {
      _estimatedFee =
          estimatedGasFee.getValueInUnit(EtherUnit.ether).toStringAsFixed(18);
    });
  }

  String validateAmount(String value) {
    print("value, $value");
    print("_balance, $_balance");
    if (value.isNotEmpty) {
      if (double.parse(value) > double.parse(_balance)) {
        print("true");
        print("value2, $value");
        print("_balance2, $_balance");
        return "You do not have enough this token in your account";
      }
    }

    return "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Send Tokens'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: recipientController,
              decoration: const InputDecoration(
                  labelText: 'Recipient Address',
                  labelStyle: TextStyle(fontWeight: FontWeight.w600)),
            ),
            SizedBox(height: 24.h),
            if (widget.tokenList.isNotEmpty)
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                    label: const Text("Token"),
                    contentPadding: EdgeInsets.symmetric(vertical: 10.h)),
                onChanged: (value) {
                  value = value;
                },
                value: widget.tokenList[0]["token"],
                items: [
                  const DropdownMenuItem(
                    alignment: Alignment.center,
                    value: "",
                    enabled: false,
                    child: Text("Select Token"),
                  ),
                  for (var tk in widget.tokenList)
                    DropdownMenuItem(
                      value: tk["token"],
                      child: Text(tk["token"]),
                      onTap: () => setState(() {
                        _selectedToken = tk["address"];
                        _balance = tk["balance"];
                      }),
                    )
                ],
              ),
            SizedBox(height: 15.h),
            Text(
              "Balance: $_balance",
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: 16.sp),
            ),
            SizedBox(height: 24.h),
            TextField(
              onChanged: (value) => loadTransactionData(),
              controller: amountController,
              decoration: InputDecoration(
                  labelText: 'Amount',
                  labelStyle: TextStyle(fontWeight: FontWeight.w600)),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
            ),
            SizedBox(height: 24.h),
            Row(
              children: [
                Text("Estimated fee: "),
                Text(
                    "$_estimatedFee ${widget.chainID == "sepolia" ? "SepoliaETH" : "ETH"}")
              ],
            ),
            ElevatedButton(
              onPressed: recipientController.text.isNotEmpty &&
                      amountController.text.isNotEmpty
                  ? () {
                      String recipient = recipientController.text;
                      double amount = double.parse(amountController.text);
                      BigInt bigIntValue = BigInt.from(amount * pow(10, 18));
                      print(bigIntValue);
                      EtherAmount ethAmount =
                          EtherAmount.fromBigInt(EtherUnit.wei, bigIntValue);
                      print(ethAmount);
                      // Convert the amount to EtherAmount
                      sendTransaction(recipient, ethAmount, bigIntValue);
                    }
                  : null,
              child: const Text('Send'),
            ),
          ],
        ),
      ),
    );
  }

  void sendTransaction(
      String receiver, EtherAmount txValue, BigInt bigIntValue) async {
    var apiUrl =
        'https://eth-sepolia.g.alchemy.com/v2/9CHWPQ9T5RM-zml0NglGU8uDjNKAYO0d'; // Replace with your API
    // Replace with your API
    var httpClient = http.Client();
    var ethClient = Web3Client(apiUrl, httpClient);

    EthPrivateKey credentials = EthPrivateKey.fromHex('0x' + widget.privateKey);
    print("key ${credentials.address}");

    successfulDialog(context);

    if (_selectedToken != null) {
      var ercToken = ERC20(
          address: EthereumAddress.fromHex(_selectedToken!), client: ethClient);
      await ercToken.transfer(EthereumAddress.fromHex(receiver), bigIntValue,
          credentials: credentials);
      // BigInt balance = await ercToken
      //     .balanceOf(EthereumAddress.fromHex(credentials.address.toString()));
      // print("balance.toString() ${balance.toString()}");
    } else {
      EtherAmount etherAmount = await ethClient.getBalance(credentials.address);
      EtherAmount gasPrice = await ethClient.getGasPrice();

      print("etherAmount $etherAmount");

      await ethClient.sendTransaction(
        credentials,
        Transaction(
          to: EthereumAddress.fromHex(receiver),
          gasPrice: gasPrice,
          maxGas: 100000,
          value: txValue,
        ),
        chainId: 11155111,
      );
    }
  }
}
