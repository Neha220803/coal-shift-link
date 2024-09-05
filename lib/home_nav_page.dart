import 'package:flutter/material.dart';
import 'package:shift_link/BottomNavBar/notifications_screen.dart';
import 'package:shift_link/BottomNavBar/safety_plan.dart';
import 'package:shift_link/BottomNavBar/shift_screen.dart';
import 'package:shift_link/dashboard_screen.dart';
import 'package:shift_link/side_nav_page.dart';

class HomeNavPage extends StatefulWidget {
  const HomeNavPage({super.key});

  @override
  State<HomeNavPage> createState() => _HomeNavPageState();
}

class _HomeNavPageState extends State<HomeNavPage> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPage);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  void onBottomNavTap(int index) {
    setState(() {
      _currentPage = index;
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text(
          "Shift Link",
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: const SideNavPage(),
      body: PageView(
        controller: _pageController,
        onPageChanged: onPageChanged,
        children: const <Widget>[
          DashboardScreen(),
          ShiftScreen(),
          SafetyPlanScreen(),
          NotificationsScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.blueAccent,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white54,
        currentIndex: _currentPage,
        onTap: onBottomNavTap,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'Shift',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.warning_rounded),
            label: 'Safety Plan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_active),
            label: 'Notifications',
          ),
        ],
      ),
    );
  }
}
