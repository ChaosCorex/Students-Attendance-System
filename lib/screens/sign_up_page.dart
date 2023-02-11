import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ssas/entities/app_user.dart';
import 'package:string_validator/string_validator.dart';

import '../services/auth_service.dart';
import '../ui/loading.dart';
import 'firstPage.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final confirmpasswordController= TextEditingController();
  bool isLoading = false;
  bool hasError = false;
  String errorMessage = "";
  final authService = AuthService();
  final _formkey = GlobalKey<FormState>();

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
        backgroundColor:Color(0xFFD72149),
      ),
      body: _buildBody() ,
    );
  }

  Widget _buildBody(){
    return Container(
        decoration: BoxDecoration(),
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          child: Form(
            key: _formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 80,
                ),

                Container(
                  width: kIsWeb?380:280,
                  child: TextFormField(
                    validator: (value){
                      if(value!.isEmpty){
                        return("Please enter your first name");
                      }
                    },
                      controller: firstNameController,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "First Name",
                        hintStyle: TextStyle(color: Colors.black, fontSize: 18),
                        labelStyle: TextStyle(color: Colors.black),
                        prefixIcon: Icon(Icons.drive_file_rename_outline,
                            color: Colors.black),
                      ),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  width: kIsWeb?380:280,
                  child: TextFormField(
                    validator: (value){
                      if(value!.isEmpty){
                        return ("Please enter your last name");
                      }
                    },
                      controller: lastNameController,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Last Name",
                        hintStyle: TextStyle(color: Colors.black, fontSize: 18),
                        labelStyle: TextStyle(color: Colors.black),
                        prefixIcon:
                        Icon(Icons.drive_file_rename_outline, color: Colors.black),
                      ),
                    ),
                ),
                SizedBox(height: 20,),
                Container(
                  width: kIsWeb?380:280,
                  child: TextFormField(
                    validator: (value){
                      if(value!.isEmpty){
                        return ("Please enter your email ");
                      }else if(isEmail(value)==false){
                        return ('Please enter valid email');
                      }
                    },
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
               SizedBox(height: 20,),
               Container(
                 width: kIsWeb?380:280,
                 child: TextFormField(
                   validator: (value){
                     if(value!.isEmpty){
                       return 'Please enter your password';
                     }else if(value.length < 6){
                       return 'Password must be at least 6 digits ';

                     }
                   },
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
                SizedBox(height: 20,),
                Container(
                  width: kIsWeb?380:280,
                  child: TextFormField(
                    validator: (value){
                      if(value!.isEmpty){
                        return 'password does not match';
                      }else if(value != passwordController.text){
                        return 'password does not match';

                      }
                    },
                    controller: confirmpasswordController,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Confirm Password",
                      labelStyle: TextStyle(color: Colors.black),
                      hintStyle: TextStyle(color: Colors.black, fontSize: 18),
                      prefixIcon:
                      Icon(Icons.password_outlined, color: Colors.black),
                    ),
                  ),
                ),
                SizedBox(height: 35),
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
                        onPressed: !isLoading ? onRegister : null,
                        child: Center(
                          child: Text(
                            "Sign Up",
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

  void onRegister() async {
    if (_formkey.currentState!.validate()) {



    String emailValue = emailController.text;
    String passwordValue = passwordController.text;
    setState(() {
      Profile_FirstName = firstNameController.text;
      Profile_LastName = lastNameController.text;
      isLoading = true;
      hasError = false;
    });
    try {
      await authService.signUp(emailValue, passwordValue);
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
}
