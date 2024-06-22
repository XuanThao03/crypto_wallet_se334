import 'package:flutter/material.dart';
import 'package:wallet/config/themes/media_src.dart';

class PlashScreen extends StatelessWidget {
  const PlashScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
