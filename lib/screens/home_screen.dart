import 'package:flutter/material.dart';
import 'package:fit_motiv/widgets/bottom_navigation_bar.dart';
import 'package:fit_motiv/screens/dashboard_screen.dart';
import 'package:fit_motiv/screens/plans_screen.dart';
import 'package:fit_motiv/screens/routines_screen.dart';
import 'package:fit_motiv/screens/progress_screen.dart';
import 'package:fit_motiv/screens/community_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = [
    DashboardScreen(),
    PlansScreen(),
    RoutinesScreen(),
    ProgressScreen(),
    CommunityScreen(),
  ];

  void _onItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemSelected: _onItemSelected,
      ),
    );
  }
}
