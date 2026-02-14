import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bottom_nav.dart';

class PinScreen extends StatefulWidget {
  const PinScreen({super.key});

  @override
  State<PinScreen> createState() => _PinScreenState();
}

class _PinScreenState extends State<PinScreen> {
  final List<int> _enteredPIN = [];
  static const int _pinLength = 6;

  void _addDigit(int digit) {
    if (_enteredPIN.length < _pinLength) {
      HapticFeedback.lightImpact();
      setState(() {
        _enteredPIN.add(digit);
      });

      // Auto-submit when 6 digits entered
      if (_enteredPIN.length == _pinLength) {
        _submitPIN();
      }
    }
  }

  void _removeDigit() {
    if (_enteredPIN.isNotEmpty) {
      HapticFeedback.lightImpact();
      setState(() {
        _enteredPIN.removeLast();
      });
    }
  }

  void _submitPIN() {
    // Simulate PIN verification (any 6-digit PIN works)
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        HapticFeedback.mediumImpact();
        Navigator.of(context).pushAndRemoveUntil(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const AppBottomNav(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 400),
          ),
          (route) => false,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: AppColors.textPrimary,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 40),
            // Title
            Text(
              'Enter your PIN',
              style: AppTextStyles.sectionHeader.copyWith(
                fontSize: 22,
              ),
            ),
            const SizedBox(height: 40),
            // PIN Dots
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_pinLength, (index) {
                final isFilled = index < _enteredPIN.length;
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isFilled
                        ? AppColors.navyPrimary
                        : Colors.transparent,
                    border: Border.all(
                      color: AppColors.navyPrimary,
                      width: 2,
                    ),
                  ),
                );
              }),
            ),
            const Spacer(),
            // Number Pad
            _buildNumberPad(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildNumberPad() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: [
          // Row 1: 1, 2, 3
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNumberButton(1),
              _buildNumberButton(2),
              _buildNumberButton(3),
            ],
          ),
          const SizedBox(height: 16),
          // Row 2: 4, 5, 6
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNumberButton(4),
              _buildNumberButton(5),
              _buildNumberButton(6),
            ],
          ),
          const SizedBox(height: 16),
          // Row 3: 7, 8, 9
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNumberButton(7),
              _buildNumberButton(8),
              _buildNumberButton(9),
            ],
          ),
          const SizedBox(height: 16),
          // Row 4: empty, 0, delete
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildEmptyButton(),
              _buildNumberButton(0),
              _buildDeleteButton(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNumberButton(int digit) {
    return GestureDetector(
      onTap: () => _addDigit(digit),
      child: Container(
        width: 72,
        height: 72,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.offWhite,
        ),
        child: Center(
          child: Text(
            digit.toString(),
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyButton() {
    return const SizedBox(width: 72, height: 72);
  }

  Widget _buildDeleteButton() {
    return GestureDetector(
      onTap: _removeDigit,
      child: Container(
        width: 72,
        height: 72,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.transparent,
        ),
        child: Center(
          child: Icon(
            Icons.backspace_outlined,
            size: 24,
            color: AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}
