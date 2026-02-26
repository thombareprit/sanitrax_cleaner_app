import 'package:flutter/material.dart';
import 'package:sanitrax_staff_app/features/history/screens/history_screen.dart';
import 'tasks/screens/home_screen.dart';
import 'profile/screens/profile_screen.dart';
import '../core/constants/colors.dart';

// 2. Update the _pages list

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int _selectedIndex = 0;

  // List of pages to display
  final List<Widget> _pages = [
  const HomeScreen(),
  const HistoryScreen(), // Replace the Center widget with this
  const ProfileScreen(),
];


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0,
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.lightTextSecondary,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped, // This handles the navigation!
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.assignment_rounded), label: "Tasks"),
          BottomNavigationBarItem(icon: Icon(Icons.history_rounded), label: "History"),
          BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: "Profile"),
        ],
      ),
    );
  }
}