import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';

class PillBottomNav extends StatelessWidget {
  final int currentIndex;

  const PillBottomNav({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.outline,
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
      onTap: (index) {
        switch (index) {
          case 0:
            context.go('/home');
            break;
          case 1:
            context.go('/city-vehicles');
            break;
          case 2:
            context.go('/saved');
            break;
          case 3:
            context.go('/profile');
            break;
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.explore_outlined),
          activeIcon: Icon(Icons.explore),
          label: 'Explore',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bookmark_outline),
          activeIcon: Icon(Icons.bookmark),
          label: 'Saved',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }
}