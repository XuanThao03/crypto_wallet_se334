import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wallet/config/routes/routes.dart';
import 'package:wallet/screens/login_page.dart';
import 'package:wallet/screens/plash_screen.dart';

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
        name: Routes.plashScreen,
        path: '/logIn',
        pageBuilder: (context, state) => const MaterialPage(
          child: LoginPage(),
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
