import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:wallet/config/routes/routes.dart';
import 'package:wallet/config/themes/app_palette.dart';
import 'package:wallet/config/themes/media_src.dart';
import 'package:wallet/core/common/const/networks.dart';
import 'package:wallet/providers/wallet_provider.dart';
import 'package:wallet/screens/wallet.dart';

class ImportWallet extends StatefulWidget {
  const ImportWallet({Key? key}) : super(key: key);

  @override
  _ImportWalletState createState() => _ImportWalletState();
}

class _ImportWalletState extends State<ImportWallet> {
  bool isVerified = false;
  String verificationText = '', selectedNetwork = Networks.sepolia;

  void navigateToWalletPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => WalletPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    print("Selected $selectedNetwork");
    void verifyMnemonic() async {
      final walletProvider =
          Provider.of<WalletProvider>(context, listen: false);

      // Call the getPrivateKey function from the WalletProvider
      final privateKey = await walletProvider.getPrivateKey(
          verificationText, selectedNetwork, true);
      print("privateK $privateKey");
      // Navigate to the WalletPage
      navigateToWalletPage();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Import from Seed'),
        leading: Icon(Icons.arrow_back),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Select network',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
            ),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                  label: const Text("Network"),
                  contentPadding: EdgeInsets.symmetric(vertical: 10.h)),
              onChanged: (value) {
                value = value;
              },
              value: "Sepolia",
              items: [
                const DropdownMenuItem(
                  alignment: Alignment.center,
                  value: "",
                  enabled: false,
                  child: Text("Select Network"),
                ),
                DropdownMenuItem(
                  value: "Ethereum",
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        MediaResource.ethereumIC,
                        width: 15.w,
                      ),
                      SizedBox(width: 15.w),
                      Text(Networks.ethereum),
                    ],
                  ),
                  onTap: () => selectedNetwork = Networks.ethereum,
                ),
                DropdownMenuItem(
                  value: "Sepolia",
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        MediaResource.sepoliaIC,
                        width: 20.w,
                      ),
                      SizedBox(width: 15.w),
                      Text(Networks.sepolia),
                    ],
                  ),
                  onTap: () => selectedNetwork = Networks.sepolia,
                )
              ],
            ),
            SizedBox(height: 48.h),
            const Text(
              'Please Enter your mnemonic phrase:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
            ),
            TextField(
              onChanged: (value) {
                setState(() {
                  verificationText = value;
                });
              },
              maxLines: null,
              decoration: const InputDecoration(
                labelText: 'Enter mnemonic phrase',
              ),
            ),
            SizedBox(height: 48.h),
            ElevatedButton(
              onPressed: verifyMnemonic,
              child: Text(
                'Import',
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18.sp,
                    color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppPalette.primary,
                padding: const EdgeInsets.all(16.0),
              ),
            ),
            const SizedBox(height: 24.0),
          ],
        ),
      ),
    );
  }
}
