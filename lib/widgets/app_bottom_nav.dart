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
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: Colors.transparent,
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
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          left: 12,
          right: 12,
          bottom: bottomPadding > 0 ? bottomPadding : 8,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              height: 64,
              decoration: BoxDecoration(
                color: const Color(0xFF0A1E3D).withValues(alpha: 0.45),
                borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: AppColors.white.withValues(alpha: 0.08),
              width: 0.5,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? 14 : 12,
          vertical: 6,
        ),
        decoration: const BoxDecoration(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: isSelected ? 30 : 24,
              height: isSelected ? 30 : 24,
              decoration: isSelected
                  ? BoxDecoration(
                      color: AppColors.accentBlue,
                      shape: BoxShape.circle,
                    )
                  : null,
              child: Icon(
                isSelected ? activeIcon : icon,
                size: isSelected ? 16 : 22,
                color: isSelected
                    ? AppColors.white
                    : AppColors.white.withValues(alpha: 0.45),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected
                    ? AppColors.accentBlue
                    : AppColors.white.withValues(alpha: 0.45),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
