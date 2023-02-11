import 'package:flutter/material.dart';
import 'package:ssas/entities/app_user.dart';
import 'package:ssas/screens/profile.dart';
import 'package:ssas/screens/qr_identity/qr_identity_list.dart';
import 'package:ssas/screens/users.dart';

class AffairsHome extends StatefulWidget {
  final AppUser currentUser;

  const AffairsHome({required this.currentUser, Key? key}) : super(key: key);

  @override
  State<AffairsHome> createState() => _AffairsHomeState();
}

class _AffairsHomeState extends State<AffairsHome> {
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
      Users(currentUser: widget.currentUser, isAffairs: true),
      QrIdentityList(currentUser: widget.currentUser),
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
