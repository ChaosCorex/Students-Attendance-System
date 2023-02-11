import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ssas/services/auth_service.dart';
import 'package:ssas/ui/loading.dart';

class Auth extends StatefulWidget {
  const Auth({Key? key}) : super(key: key);

  @override
  _AuthState createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  bool isLoading = false;
  bool hasError = false;
  String errorMessage = "";
  final authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                    filled: true,
                    labelText: "E-mail",
                    border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  filled: true,
                  labelText: "Password",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              !hasError
                  ? const SizedBox()
                  : Container(
                      margin: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                      child: Text(errorMessage)),
              isLoading
                  ? const Loading()
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          child: const Text("SignIn"),
                          onPressed: !isLoading ? onSignIn : null,
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton(
                          child: const Text("Register"),
                          onPressed: !isLoading ? onRegister : null,
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }

  void onSignIn() async {
    String emailValue = emailController.text;
    String passwordValue = passwordController.text;
    setState(() {
      isLoading = true;
      hasError = false;
    });
    try {
      await authService.signIn(emailValue, passwordValue);
    } on FirebaseException catch (error) {
      setState(() {
        hasError = true;
        errorMessage = error.code;
        isLoading = false;
      });
    }
  }

  void onRegister() async {
    String emailValue = emailController.text;
    String passwordValue = passwordController.text;
    setState(() {
      isLoading = true;
      hasError = false;
    });
    try {
      await authService.signUp(emailValue, passwordValue);
    } on FirebaseException catch (error) {
      setState(() {
        hasError = true;
        errorMessage = error.code;
        isLoading = false;
      });
    }
  }
}
