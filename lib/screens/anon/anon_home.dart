import 'package:flutter/material.dart';
import 'package:ssas/entities/app_user.dart';
import 'package:ssas/screens/anon/application.dart';
import 'package:ssas/screens/profile.dart';
import 'package:ssas/utils/qr_handler.dart';

class AnonHome extends StatefulWidget {
  final AppUser currentUser;
  final bool isStudent;

  const AnonHome({required this.currentUser, this.isStudent = false, Key? key})
      : super(key: key);

  @override
  State<AnonHome> createState() => _AnonHomeState();
}

class _AnonHomeState extends State<AnonHome> {
  int _currentIndex = 0;

  final _items = [
    const BottomNavigationBarItem(
      icon: Icon(
        Icons.scatter_plot,
      ),
      label: "Application",
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
      Application(widget.isStudent),
      Profile(currentUser: widget.currentUser),
    ];
    return Scaffold(
        body: _screens[_currentIndex],
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            QrHandler(currentUser: widget.currentUser).scanQr(context,false);
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
                  Icons.scatter_plot,
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
        ));
  }

  void _onTabItem(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
