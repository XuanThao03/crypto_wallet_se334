import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallet/components/network_dialog.dart';
import 'package:wallet/components/token_balances.dart';
import 'package:wallet/config/routes/routes.dart';
import 'package:wallet/config/themes/app_palette.dart';
import 'package:wallet/config/themes/media_src.dart';
import 'package:wallet/core/common/const/networks.dart';
import 'package:wallet/providers/wallet_provider.dart';
import 'package:wallet/screens/setupWallet_Screens/create_or_import.dart';
import 'package:web3dart/web3dart.dart';
import 'package:wallet/core/utils/get_balances.dart';
import 'package:wallet/components/nft_balances.dart';
import 'package:wallet/screens/sendToken_Screens/send_tokens.dart';
import 'dart:convert';

class WalletPage extends StatefulWidget {
  const WalletPage({Key? key}) : super(key: key);

  @override
  _WalletPageState createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  String walletAddress = '';
  String balance = '';
  String pvKey = '';
  Map? chain = {"name": Networks.sepolia, "chain": "sepolia"};
  final List<dynamic> _tkList = [];

  //Copy to clipboard
  void copyToClipboard() {
    Clipboard.setData(ClipboardData(text: walletAddress));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Address Copied to Clipboard')),
    );
  }

  @override
  void initState() {
    super.initState();
    loadWalletData();
  }

  void updateChain(String name, String chainID) async {
    setState(() {
      chain?["name"] = name;
      chain?["chain"] = chainID;
    });
    await loadWalletData();
  }

  Future<void> loadWalletData() async {
    _tkList.clear();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? privateKey = prefs.getString('privateKey');
    if (privateKey != null) {
      final walletProvider = WalletProvider();

      // Load Private Key
      await walletProvider.loadPrivateKey();
      EthereumAddress address = await walletProvider.getPublicKey(privateKey);
      print(address.hex);
      setState(() {
        walletAddress = address.hex;
        pvKey = privateKey;
      });
      print(pvKey);

      //Get Native Balance
      String response = await getNativeBalances(address.hex, chain!["chain"]);
      dynamic data = json.decode(response);
      String newBalance = data['balance'] ?? '0';
      // Transform balance from wei to ether
      EtherAmount latestBalance =
          EtherAmount.fromBigInt(EtherUnit.wei, BigInt.parse(newBalance));
      String latestBalanceInEther =
          latestBalance.getValueInUnit(EtherUnit.ether).toString();

      setState(() {
        balance =
            latestBalanceInEther.length > 5 && latestBalanceInEther[1] == "."
                ? latestBalanceInEther.substring(0, 8)
                : latestBalanceInEther;
      });

      setState(() {
        _tkList.add({
          "token": chain!["chain"].toString().toUpperCase(),
          "balance": balance,
          "address": data['token_address']
        });
      });

      //get ERC balance
      response = await getERCBalances(address.hex, chain!["chain"]);

      var newdata = [];
      newdata = json.decode(response);
      print(newdata);
      for (var i = 0; i < newdata.length; i++) {
        newBalance = newdata[i]['balance'] ?? '0';
        print(newBalance);
        latestBalance =
            EtherAmount.fromBigInt(EtherUnit.wei, BigInt.parse(newBalance));
        latestBalanceInEther =
            latestBalance.getValueInUnit(EtherUnit.ether).toString();
        String ercBalance =
            latestBalanceInEther.length > 5 && latestBalanceInEther[1] == "."
                ? latestBalanceInEther.substring(0, 8)
                : latestBalanceInEther;

        setState(() {
          _tkList.add({
            "token": newdata[i]['name'],
            "balance": ercBalance,
            "address": newdata[i]['token_address']
          });
        });
      }

      print("balance List $_tkList");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          child: Container(
            width: 250.w,
            padding: EdgeInsets.all(8.sp),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(chain?["name"]),
                SizedBox(
                  width: 8.w,
                ),
                Icon(Icons.expand_more),
              ],
            ),
          ),
          onTap: () {
            chainDialog(context, updateChain);
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.4,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Wallet Address',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    GestureDetector(
                      onTap: () {
                        copyToClipboard();
                      },
                      child: SizedBox(
                        height: 50.h,
                        width: 50.h,
                        child: Icon(Icons.copy),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 16.0),
                Text(
                  walletAddress,
                  style: const TextStyle(
                    fontSize: 20.0,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32.0),
                const Text(
                  'Balance',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16.0),
                Text(
                  balance,
                  style: const TextStyle(
                    fontSize: 20.0,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  FloatingActionButton(
                    backgroundColor: AppPalette.primary,
                    heroTag: 'sendButton', // Unique tag for send button
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SendTokensPage(
                                  privateKey: pvKey,
                                  tokenList: _tkList,
                                  chainID: chain!["chain"],
                                )),
                      );
                    },
                    child: const Icon(
                      Icons.send,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  const Text('Send'),
                ],
              ),
              Column(
                children: [
                  FloatingActionButton(
                    backgroundColor: Colors.white,
                    heroTag: 'refreshButton', // Unique tag for send button
                    onPressed: () {
                      loadWalletData();
                    },
                    child: const Icon(Icons.replay_outlined),
                  ),
                  const SizedBox(height: 8.0),
                  const Text('Refresh'),
                ],
              ),
            ],
          ),
          const SizedBox(height: 30.0),
          Expanded(
            child: DefaultTabController(
              length: 3,
              child: Column(
                children: [
                  const TabBar(
                    labelColor: Colors.blue,
                    tabs: [
                      Tab(text: 'Assets'),
                      Tab(text: 'NFTs'),
                      Tab(text: 'Options'),
                    ],
                  ),
                  Expanded(
                    child: SizedBox(
                      child: TabBarView(
                        children: [
                          // Assets Tab
                          TkBalancesList(
                            tkList: _tkList,
                          ),
                          // NFTs Tab
                          SingleChildScrollView(
                              child: NFTListPage(
                                  address: walletAddress, chain: 'sepolia')),

                          // Activities Tab
                          Center(
                            child: ListTile(
                              leading: const Icon(Icons.logout),
                              title: const Text('Logout'),
                              onTap: () async {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                await prefs.remove('privateKey');
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          CreateOrImportPage()),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
