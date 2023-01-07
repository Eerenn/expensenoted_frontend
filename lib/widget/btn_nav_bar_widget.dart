import 'package:expensenoted/screen/overview_screen.dart';
import 'package:expensenoted/screen/profile_screen.dart';
import 'package:expensenoted/screen/report_screen.dart';
import 'package:expensenoted/screen/goal_screen.dart';
import 'package:flutter/material.dart';

class BtmNavBar extends StatelessWidget {
  const BtmNavBar({
    Key? key,
    required int selectedIndex,
  })  : _selectedIndex = selectedIndex,
        super(key: key);

  final int _selectedIndex;

  @override
  Widget build(BuildContext context) {
    void _onItemTapped(int index) {
      switch (index) {
        case 0:
          _selectedIndex == index
              ? null
              : Navigator.pushReplacementNamed(
                  context, OverviewScreen.routeName);
          break;
        case 1:
          _selectedIndex == index
              ? null
              : Navigator.pushReplacementNamed(context, ReportScreen.routeName);
          break;
        case 2:
          _selectedIndex == index
              ? null
              : Navigator.pushReplacementNamed(context, GoalScreen.routeName);
          break;
        case 3:
          _selectedIndex == index
              ? null
              : Navigator.pushReplacementNamed(
                  context, ProfileScreen.routeName);
          break;
      }
    }

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      elevation: 10,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.note),
          label: 'Entries',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bar_chart_outlined),
          label: 'Report',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.checklist),
          label: 'Goal',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle_outlined),
          label: 'Profile',
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Theme.of(context).colorScheme.tertiary,
      unselectedItemColor: Colors.grey[700],
      onTap: _onItemTapped,
    );
  }
}
