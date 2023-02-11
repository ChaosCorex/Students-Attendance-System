import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'sign_in_page.dart';
import 'sign_up_page.dart';

class FirstPage extends StatefulWidget {
  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: !kIsWeb? AppBar(
      //backgroundColor: Color(0xFFD72149),
      //centerTitle: true,
      //title: Text(
      // "SSAS",
      // style: TextStyle(
      //  fontSize: 24,
      //  fontWeight: FontWeight.w600,
      // ),
      //),

      //):PreferredSize(child: SizedBox(), preferredSize: Size(double.infinity,10.0)),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (kIsWeb) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.only(top: 15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(),
                    height: 200,
                    width: 370,
                    child: Column(
                      children: [
                        Image.asset('assets/img/logo.png'),
                        SizedBox(
                          height: 14.0,
                        ),
                        Text(
                          'Smart Student Attendance System',
                          style: GoogleFonts.lato(
                            fontSize: 24,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 400,
            child: VerticalDivider(
              thickness: 2,
              color: Color(0xFFD72149),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(),
              //width: double.infinity,
              // height: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Join to use our services",
                    style: GoogleFonts.lato(
                      fontSize: kIsWeb ? 38 : 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFD72149),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "A Simple, fun, and fast way to ",
                    style: GoogleFonts.lato(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black45,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "record attendance, view and save it",
                    style: GoogleFonts.lato(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black45,
                    ),
                  ),
                  SizedBox(
                    height: 70,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 35),
                    child: Container(
                        height: 50,
                        width: 317,

                        // margin: EdgeInsets.symmetric(horizontal: 50),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Color(0xFFD72149)),
                        //Color.fromARGB(250, 182, 46, 71
                        child: MaterialButton(
                          height: 50,
                          minWidth: 320,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => SignIn()),
                            );
                          },
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
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 35),
                    child: Container(
                        height: 50,
                        width: 317,

                        // margin: EdgeInsets.symmetric(horizontal: 50),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Color(0xFFD72149)),
                        child: MaterialButton(
                          height: 50,
                          minWidth: 320,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => SignUp()),
                            );
                          },
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
          ),
          //SizedBox(width: 20.0,),
        ],
      );
    } else {
      return SafeArea(
        child: Container(
          decoration: BoxDecoration(),
          width: double.infinity,
          height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image(
                  image: AssetImage('assets/img/logo.png'),
                  height: 98,
                  width: 200,
              ),
            SizedBox(height: 60.0,),
              Text(
                "Join to use our services",
                style: GoogleFonts.lato(
                  fontSize: kIsWeb ? 34 : 25,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFD72149),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Text(
                "A Simple, fun, and fast way to ",
                style: GoogleFonts.lato(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black45,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                "record attendance, view and save it.",
                style: GoogleFonts.lato(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black45,
                ),
              ),
              SizedBox(
                height: 45,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35),
                child: Container(
                    height: 50,
                    width: kIsWeb ? 370 : 320,

                    // margin: EdgeInsets.symmetric(horizontal: 50),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Color(0xFFD72149)),
                    //Color.fromARGB(250, 182, 46, 71
                    child: MaterialButton(
                      height: 50,
                      minWidth: 320,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignIn()),
                        );
                      },
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
              SizedBox(
                height: 16,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35),
                child: Container(
                    height: 50,
                    width: kIsWeb ? 370 : 320,

                    // margin: EdgeInsets.symmetric(horizontal: 50),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Color(0xFFD72149)),
                    child: MaterialButton(
                      height: 50,
                      minWidth: 320,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignUp()),
                        );
                      },
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
      );
    }
  }
}
