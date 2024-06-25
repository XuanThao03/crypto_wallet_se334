import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:wallet/config/themes/app_palette.dart';
import 'package:wallet/core/common/const/networks.dart';
import 'package:wallet/screens/wallet.dart';
import 'package:wallet/providers/wallet_provider.dart';

class VerifyMnemonicPage extends StatefulWidget {
  final String mnemonic;

  const VerifyMnemonicPage({Key? key, required this.mnemonic})
      : super(key: key);

  @override
  _VerifyMnemonicPageState createState() => _VerifyMnemonicPageState();
}

class _VerifyMnemonicPageState extends State<VerifyMnemonicPage> {
  bool isVerified = false;
  String verificationText = '';

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Incorrect',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Mnemonic phrase is not matched. Please try again",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.w400),
              ),
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
                    'Try again',
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

  void verifyMnemonic() {
    final walletProvider = Provider.of<WalletProvider>(context, listen: false);

    if (verificationText.trim() == widget.mnemonic.trim()) {
      walletProvider
          .getPrivateKey(widget.mnemonic, Networks.sepolia, false)
          .then((privateKey) {
        setState(() {
          isVerified = true;
        });
      });
    } else {
      _dialogBuilder(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    void navigateToWalletPage() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const WalletPage()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Verify Mnemonic and Create',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Please verify your mnemonic phrase:',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 24.0),
            TextField(
              onChanged: (value) {
                setState(() {
                  verificationText = value;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Enter mnemonic phrase',
              ),
            ),
            SizedBox(height: 16.h),
            ElevatedButton(
              onPressed: verificationText != "" ? verifyMnemonic : null,
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppPalette.primary,
                  padding: EdgeInsets.all(16.w)),
              child: Text(
                'Verify',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(height: 24.h),
            ElevatedButton(
              onPressed: isVerified ? navigateToWalletPage : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                padding: EdgeInsets.all(16.w),
              ),
              child: Text(
                'Next',
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
