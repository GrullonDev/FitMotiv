import 'package:flutter/material.dart';
import 'package:fit_motiv/widgets/bottom_navigation_bar.dart';
import 'package:fit_motiv/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:fit_motiv/features/plans/presentation/screens/plans_screen.dart';
import 'package:fit_motiv/features/routines/presentation/screens/routines_screen.dart';
import 'package:fit_motiv/features/progress/presentation/screens/progress_screen.dart';
import 'package:fit_motiv/features/community/presentation/screens/community_screen.dart';
import 'package:fit_motiv/features/profile_settings/presentation/screens/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  
  void _onItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const DashboardScreen(),
      const PlansScreen(),
      const RoutinesScreen(),
      const ProgressScreen(),
      const CommunityScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemSelected: _onItemSelected,
      ),
    );
  }
}
