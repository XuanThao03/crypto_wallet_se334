import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wallet/config/routes/routes.dart';
import 'package:wallet/screens/create_or_import.dart';
import 'package:wallet/screens/login_page.dart';
import 'package:wallet/screens/onBoarding_Screens/onBoarding.dart';
import 'package:wallet/screens/onBoarding_Screens/plash_screen.dart';
import 'package:wallet/screens/wallet.dart';

class AppRouter {
  GoRouter router = GoRouter(
    initialLocation: '/plashScreen',
    routes: [
      GoRoute(
        name: Routes.plashScreen,
        path: '/plashScreen',
        pageBuilder: (context, state) => const MaterialPage(
          child: PlashScreen(),
        ),
      ),
      GoRoute(
        name: Routes.onBoarding,
        path: '/onBoarding',
        pageBuilder: (context, state) => MaterialPage(
          child: OnBoarding(),
        ),
      ),
      GoRoute(
        name: Routes.logIn,
        path: '/logIn',
        pageBuilder: (context, state) => const MaterialPage(
          child: LoginPage(),
        ),
      ),
      GoRoute(
        name: Routes.accessWallet,
        path: '/accessWallet',
        pageBuilder: (context, state) => const MaterialPage(
          child: CreateOrImportPage(),
        ),
      ),
      GoRoute(
        name: Routes.home,
        path: '/home',
        pageBuilder: (context, state) => const MaterialPage(
          child: WalletPage(),
        ),
      ),
    ],
  );
}

SlideTransition buildTransition(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  final tween = Tween(begin: const Offset(1, 0), end: Offset.zero).animate(
    CurvedAnimation(parent: animation, curve: Curves.easeInOut),
  );
  return SlideTransition(
    position: tween,
    child: child,
  );
}
