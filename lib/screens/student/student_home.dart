import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ssas/entities/app_user.dart';
import 'package:ssas/screens/profile.dart';
import 'package:ssas/screens/student/attendance.dart';
import 'package:ssas/services/user_service.dart';
import '../../entities/academic.dart';
import '../../entities/activeAcademic.dart';
import '../../services/academic_service.dart';
import '../../ui/snakbar.dart';
import '../../utils/qr_handler.dart';
import 'face_authenticate.dart';

class StudentHome extends StatefulWidget {
  final AppUser currentUser;

  const StudentHome({required this.currentUser, Key? key}) : super(key: key);

  @override
  State<StudentHome> createState() => _StudentHomeState();
}

class _StudentHomeState extends State<StudentHome> {
  final _academicServices = AcademicService();
  final _userServices =UserService();
  int _currentIndex = 0;

  final _items = [
    const BottomNavigationBarItem(
      icon: Icon(
        Icons.home,
      ),
      label: "Home",
    ),
    const BottomNavigationBarItem(
      icon: Icon(
        Icons.person,
      ),
      label: "Profile",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final _screens = [
      StreamBuilder<ActiveAcademic>(
          stream:
          _academicServices.getItemStreamById("ssasActiveYear"),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              print(snapshot.error);
              return Text(snapshot.error.toString());
            }
            if (snapshot.hasData) {

              final activeAcademic = snapshot.data!;

              return  StudentLanding(currentUser: widget.currentUser,academic:academicFromString(activeAcademic!.activeAcademicYear) );
            }
            return SizedBox();
          }),
      Profile(currentUser: widget.currentUser),
    ];
    return Scaffold(
      body: _screens[_currentIndex],
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () async{
          if(widget.currentUser.student!.canTakeImage == false)
          {
            num RandomNum = await widget.currentUser.student!.random!;

            if (RandomNum == 0) {
              _onFaceAuth(context, true);
            }
            else {

               await QrHandler(currentUser: widget.currentUser).scanQr(context, false);
              RandomNum--;
              await _userServices.updateUserInfo(
                  widget.currentUser.id, AppUser.randomKey, RandomNum);
            }
          }
          else{           showSnackBar(context, "you need to register your image first !!");
          }
        },
        child: const Icon(Icons.qr_code_scanner_rounded),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              onPressed: () {
                _onTabItem(0);
              },
              icon: Icon(
                Icons.home,
                color: _currentIndex == 0
                    ? Theme.of(context).colorScheme.secondary
                    : Colors.grey,
              ),
            ),
            IconButton(
              onPressed: () {
                _onTabItem(1);
              },
              icon: Icon(
                Icons.person,
                color: _currentIndex == 1
                    ? Theme.of(context).colorScheme.secondary
                    : Colors.grey,
              ),
            )
          ],
        ),
      ),
    );
  }

  void _onTabItem(int index) {
    setState(() {
      _currentIndex = index;
    });
  }



  void _onFaceAuth(BuildContext context,bool canUpdate) async {

    final String? faceOutput = await showDialog<String>(

        context: context,
        builder: (context) {

            return Dialog(
                insetPadding: EdgeInsets.zero,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: FaceAuthenticats(
                ));

        });
    if (faceOutput != null && faceOutput != "error") {
      QrHandler(currentUser: widget.currentUser).scanQr(context,canUpdate);

    }
    else{
     // Navigator.of(context).pop();
      showSnackBar(context, "not match face !!");

    }
  }


}
