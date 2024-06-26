import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallet/providers/wallet_provider.dart';
import 'package:wallet/screens/setupWallet_Screens/create_or_import.dart';
import 'package:web3dart/web3dart.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  String _publicKey = "";
  String? _mnemonicStr = "";
  bool _isShowed = false;
  void initState() {
    super.initState();
    loadWalletData();
  }

  void copyToClipboard(String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$label Copied to Clipboard')),
    );
  }

  Future<void> loadWalletData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? privateKey = prefs.getString('privateKey');
    String? mnemonic = prefs.getString('mnemonicStr');

    if (privateKey != null) {
      final walletProvider = WalletProvider();

      // Load Private Key
      await walletProvider.loadPrivateKey();
      EthereumAddress address = await walletProvider.getPublicKey(privateKey);
      setState(() {
        _publicKey = address.hex;
        _mnemonicStr = mnemonic;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Setting",
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 200.h,
              width: 200.h,
              child: QrImageView(
                data: _publicKey,
                version: QrVersions.auto,
                size: 320,
                gapless: false,
              ),
            ),
            SizedBox(
              width: 300.w,
              child: Text(
                _publicKey,
                style: TextStyle(fontSize: 16.sp),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 5.h,
            ),
            GestureDetector(
              child: Icon(Icons.copy),
              onTap: () {
                copyToClipboard(_publicKey, "Public Key");
              },
            ),
            SizedBox(
              height: 20.h,
            ),
            Text(
              "Mnemonic Phrase",
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 24.sp),
            ),
            _isShowed
                ? Text(
                    _mnemonicStr!,
                    textAlign: TextAlign.center,
                  )
                : Text("********",
                    style: TextStyle(
                        fontWeight: FontWeight.w400, fontSize: 24.sp)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isShowed = !_isShowed;
                    });
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Icon(_isShowed
                        ? CupertinoIcons.eye_slash
                        : CupertinoIcons.eye_fill),
                  ),
                ),
                SizedBox(
                  width: 20.w,
                ),
                GestureDetector(
                  child: Icon(Icons.copy),
                  onTap: () {
                    copyToClipboard(_mnemonicStr!, "Mnemonic");
                  },
                ),
              ],
            ),
            SizedBox(
              height: 24.h,
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.remove('privateKey');
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreateOrImportPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
