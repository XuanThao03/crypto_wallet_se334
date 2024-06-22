import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:wallet/config/routes/routes.dart';
import 'package:wallet/config/themes/media_src.dart';
import 'package:wallet/providers/wallet_provider.dart';

class PlashScreen extends StatelessWidget {
  const PlashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(
      const Duration(seconds: 3),
      () {
        final walletProvider =
            Provider.of<WalletProvider>(context, listen: false);

        if (walletProvider.privateKey == null) {
          // If private key doesn't exist, load CreateOrImportPage
          context.pushReplacementNamed(Routes.onBoarding);
        } else {
          // If private key exists, load WalletPage
          context.pushReplacementNamed(Routes.home);
        }
      },
    );

    return Scaffold(
      body: Container(
        color: Colors.yellow[700],
        child: Center(
          child: Image.asset(
            MediaResource.logoBlack,
            fit: BoxFit.contain,
            width: 200,
            height: 100,
          ),
        ),
      ),
    );
  }
}
