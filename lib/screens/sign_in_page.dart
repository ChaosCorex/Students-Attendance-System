import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ssas/entities/app_user.dart';
import '../entities/user_role.dart';
import '../services/auth_service.dart';
import '../ui/loading.dart';
import 'firstPage.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;
  bool hasError = false;
  String errorMessage = "";
  final authService = AuthService();
  var formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context,
                  MaterialPageRoute(builder: (context) => FirstPage()));
            },
            icon: Icon(Icons.arrow_back)),
        backgroundColor: Color(0xFFD72149),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody(){
    return Container(
        decoration: BoxDecoration(),
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          child: Form(
            key: formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 80,
                ),
                Text(
                  "Sign In",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: kIsWeb?30:22,
                  ),
                ),
                SizedBox(
                  height: 26,
                ),
                Text(
                  "Welcome Back ",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: kIsWeb?28:22,
                  ),
                ),

                SizedBox(
                  height: 50,
                ),

                  Container(
                    width: kIsWeb?380:280,

                    child: TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Email",
                        hintStyle: TextStyle(color: Colors.black, fontSize: 18),
                        labelStyle: TextStyle(color: Colors.black),
                        prefixIcon:
                        Icon(Icons.email_sharp, color: Colors.black),
                      ),
                ),
                  ),
                SizedBox(height: 25),

                Container(
                  width: kIsWeb?380:280,
                  child: TextFormField(
                      controller: passwordController,
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Password",
                        labelStyle: TextStyle(color: Colors.black),
                        hintStyle: TextStyle(color: Colors.black, fontSize: 18),
                        prefixIcon:
                        Icon(Icons.password_outlined, color: Colors.black),
                      ),
                  ),
                ),
                SizedBox(height: 38),
                !hasError
                    ? const SizedBox()
                    : Container(
                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                    child: Text(errorMessage)),
                isLoading
                    ? const Loading()
                    : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 35),
                  child: Container(
                      height: 50,
                      width: 240,

                      // margin: EdgeInsets.symmetric(horizontal: 50),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Color(0xFFD72149)),
                      child: MaterialButton(
                        height: 50,
                        minWidth: 240,
                        onPressed: !isLoading ? onSignIn : null,
                        child: Center(
                          child: Text(
                            "Sign In",
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      )),
                ),

              ],
            ),
          ),
        ));
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
      AppUser? appUser= await authService.getCurrentUser();
      Navigator.pop(context);

    } on FirebaseException catch (error) {
      setState(() {
        hasError = true;
        errorMessage = error.code;
        isLoading = false;
      });
    }
  }

}
