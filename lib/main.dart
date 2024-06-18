import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import "providers/wallet_provider.dart";

void main() {
  runApp(ChangeNotifierProvider<WalletProvider>(
    create: (context) => WalletProvider(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final walletProvider = Provider.of<WalletProvider>(context);

    return MaterialApp(
        title: 'Crypto Wallet',
        home: Scaffold(
            appBar: AppBar(
              title: const Text("Crypto Wallet"),
              centerTitle: true,
              backgroundColor: Colors.blue,
              titleTextStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      final mnemonic = walletProvider.generateMnemonic();
                      final privateKey =
                          await walletProvider.getPrivateKey(mnemonic);
                      final publicKey =
                          await walletProvider.getPublicKey(privateKey);

                      print("Mnemonic: $mnemonic");
                      print("Private Key: $privateKey");
                      print("Public Key: $publicKey");
                    },
                    style: const ButtonStyle(
                      backgroundColor:
                          WidgetStatePropertyAll<Color>(Colors.blue),
                    ),
                    child: const Text(
                      "Generate Wallet",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            )));
  }
}
