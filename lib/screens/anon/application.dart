import 'package:flutter/material.dart';

class Application extends StatelessWidget {
  final bool isStudent;

  const Application(this.isStudent, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isStudent ? "Attention" : "Application"),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          isStudent
              ? "You are not allowed to login on web!!!\n please sign out"
              : "You are an anonymous user\n Please refer to a system administrator or student affairs for identity verification",
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
