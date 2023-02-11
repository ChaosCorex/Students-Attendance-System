import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Splash extends StatelessWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          "assets/img/logo.png",
          width: kIsWeb? 370:300,
        ),
      ),
    );
  }
}
