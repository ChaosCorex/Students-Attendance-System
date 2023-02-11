import 'package:flutter/material.dart';
import 'package:ssas/entities/app_user.dart';
import 'package:ssas/screens/admin/grades.dart';
import 'package:ssas/screens/profile.dart';
import 'package:ssas/screens/qr_identity/qr_identity_list.dart';
import 'package:ssas/screens/users.dart';

import 'academic_year_admin.dart';

class AdminHome extends StatefulWidget {
  final AppUser currentUser;

  const AdminHome({required this.currentUser, Key? key}) : super(key: key);

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  int _currentIndex = 0;

  final _items = [
    const BottomNavigationBarItem(
      icon: Icon(
        Icons.group,
      ),
      label: "Users",
    ),
    const BottomNavigationBarItem(
      icon: Icon(
        Icons.account_tree_rounded,
      ),
      label: "Levels",
    ),
    const BottomNavigationBarItem(
      icon: Icon(
        Icons.qr_code_rounded,
      ),
      label: "Qr Identity",
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
      Users(currentUser: widget.currentUser),
      AdminAcademicYear(currentUser: widget.currentUser),
      QrIdentityList(currentUser: widget.currentUser),
      Profile(currentUser: widget.currentUser),
    ];
    return Scaffold(
      backgroundColor: Colors.white54,
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        items: _items,
        onTap: _onTabItem,
      ),
    );
  }

  void _onTabItem(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
