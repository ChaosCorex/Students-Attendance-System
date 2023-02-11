import 'package:flutter/material.dart';
import 'package:ssas/entities/app_user.dart';
import 'package:ssas/screens/profile.dart';

import 'academic_year.dart';

class DoctorHome extends StatefulWidget {
  final AppUser currentUser;

  const DoctorHome({required this.currentUser, Key? key}) : super(key: key);

  @override
  State<DoctorHome> createState() => _DoctorHomeState();
}

class _DoctorHomeState extends State<DoctorHome> {
  int _currentIndex = 0;

  final _items = [
    const BottomNavigationBarItem(
      icon: Icon(
        Icons.home_filled,
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
      AcademicYear(currentUser: widget.currentUser ),
      Profile(currentUser: widget.currentUser),
    ];
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
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
