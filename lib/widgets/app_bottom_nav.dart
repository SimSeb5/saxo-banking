import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:ui';
import '../theme/app_theme.dart';
import '../screens/home/home_screen.dart';
import '../screens/trading/trading_screen.dart';
import '../screens/payments/payments_screen.dart';
import '../screens/credit/credit_screen.dart';
import '../screens/settings/settings_screen.dart';

class AppBottomNav extends StatefulWidget {
  final int initialIndex;

  const AppBottomNav({super.key, this.initialIndex = 0});

  static final GlobalKey<_AppBottomNavState> globalKey = GlobalKey<_AppBottomNavState>();

  static void switchToTab(BuildContext context, int index) {
    final state = context.findAncestorStateOfType<_AppBottomNavState>();
    if (state != null) {
      state.switchTab(index);
    }
  }

  @override
  State<AppBottomNav> createState() => _AppBottomNavState();
}

class _AppBottomNavState extends State<AppBottomNav> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void switchTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          HomeScreen(onNavigateToTab: switchTab),
          const TradingScreen(),
          const PaymentsScreen(),
          const CreditScreen(),
          const SettingsScreen(),
        ],
      ),
      extendBody: true,
      bottomNavigationBar: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF0A1E3D).withValues(alpha: 0.9),
              border: Border(
                top: BorderSide(
                  color: AppColors.white.withValues(alpha: 0.1),
                  width: 0.5,
                ),
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _NavItem(
                      icon: CupertinoIcons.house,
                      activeIcon: CupertinoIcons.house_fill,
                      label: 'Home',
                      isSelected: _currentIndex == 0,
                      onTap: () => switchTab(0),
                    ),
                    _NavItem(
                      icon: CupertinoIcons.chart_bar,
                      activeIcon: CupertinoIcons.chart_bar_fill,
                      label: 'Trading',
                      isSelected: _currentIndex == 1,
                      onTap: () => switchTab(1),
                    ),
                    _NavItem(
                      icon: CupertinoIcons.creditcard,
                      activeIcon: CupertinoIcons.creditcard_fill,
                      label: 'Payments',
                      isSelected: _currentIndex == 2,
                      onTap: () => switchTab(2),
                    ),
                    _NavItem(
                      icon: CupertinoIcons.building_2_fill,
                      activeIcon: CupertinoIcons.building_2_fill,
                      label: 'Credit',
                      isSelected: _currentIndex == 3,
                      onTap: () => switchTab(3),
                    ),
                    _NavItem(
                      icon: CupertinoIcons.settings,
                      activeIcon: CupertinoIcons.settings_solid,
                      label: 'Settings',
                      isSelected: _currentIndex == 4,
                      onTap: () => switchTab(4),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.accentBlue.withValues(alpha: 0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              size: 24,
              color: isSelected
                  ? AppColors.accentBlue
                  : AppColors.white.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected
                    ? AppColors.accentBlue
                    : AppColors.white.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
