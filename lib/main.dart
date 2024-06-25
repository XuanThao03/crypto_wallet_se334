import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:wallet/config/routes/router.dart';
import 'package:wallet/screens/onBoarding_Screens/plash_screen.dart';
import 'providers/wallet_provider.dart';
import 'package:wallet/core/utils/routes.dart';
import 'package:wallet/screens/setupWallet_Screens/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load the private key
  WalletProvider walletProvider = WalletProvider();
  await walletProvider.loadPrivateKey();

  runApp(
    ChangeNotifierProvider<WalletProvider>.value(
      value: walletProvider,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(393, 852),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => child!,
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        // theme: AppTheme.lightThemeMode,
        routerConfig: AppRouter().router, //router
      ),
    );
  }
}
