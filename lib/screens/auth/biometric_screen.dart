import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:ui';
import 'package:flutter_animate/flutter_animate.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bottom_nav.dart';
import 'pin_screen.dart';

class BiometricScreen extends StatefulWidget {
  const BiometricScreen({super.key});

  @override
  State<BiometricScreen> createState() => _BiometricScreenState();
}

class _BiometricScreenState extends State<BiometricScreen> {
  bool _isAuthenticating = false;

  void _authenticate() {
    setState(() {
      _isAuthenticating = true;
    });

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        _navigateToHome();
      }
    });
  }

  void _navigateToHome() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const AppBottomNav(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  void _navigateToPIN() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const PinScreen(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        _authenticate();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0A1E3D),
              Color(0xFF0F2744),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              // Face ID icon at top center (Apple style)
              Icon(
                Icons.face,
                size: 48,
                color: AppColors.white.withValues(alpha: 0.6),
              )
                  .animate()
                  .fade(duration: 600.ms)
                  .scale(
                    begin: const Offset(0.8, 0.8),
                    end: const Offset(1.0, 1.0),
                    duration: 600.ms,
                    curve: Curves.easeOut,
                  ),
              const Spacer(),
              // User avatar with initials (centered)
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.accentGold.withValues(alpha: 0.8),
                      AppColors.accentGold.withValues(alpha: 0.5),
                    ],
                  ),
                  border: Border.all(
                    color: AppColors.accentGold.withValues(alpha: 0.4),
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    'SS',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      color: AppColors.white,
                    ),
                  ),
                ),
              )
                  .animate()
                  .fade(duration: 600.ms, delay: 200.ms)
                  .scale(
                    begin: const Offset(0.8, 0.8),
                    end: const Offset(1.0, 1.0),
                    duration: 600.ms,
                    delay: 200.ms,
                    curve: Curves.easeOut,
                  ),
              const SizedBox(height: 20),
              // Greeting text
              Text(
                'Welcome back, Simon',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: AppColors.white,
                ),
              )
                  .animate()
                  .fade(duration: 600.ms, delay: 400.ms),
              const SizedBox(height: 8),
              Text(
                _isAuthenticating
                    ? 'Authenticating...'
                    : 'Use Face ID to unlock',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.white.withValues(alpha: 0.5),
                ),
              )
                  .animate()
                  .fade(duration: 600.ms, delay: 500.ms),
              const Spacer(),
              // PIN fallback at bottom
              GestureDetector(
                onTap: _navigateToPIN,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.white.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Text(
                    'Use PIN instead',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.white.withValues(alpha: 0.7),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }
}
