import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:ui';
import '../../../../theme/app_theme.dart';

class ComplianceStep extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;

  const ComplianceStep({
    super.key,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<ComplianceStep> createState() => _ComplianceStepState();
}

class _ComplianceStepState extends State<ComplianceStep> {
  final List<_CheckItem> _checks = [
    _CheckItem('KYC/AML status', 'Valid'),
    _CheckItem('PEP screening', 'Clear'),
    _CheckItem('Tax compliance (FATCA/CRS)', 'Compliant'),
    _CheckItem('Cross-border check', 'Within policy'),
    _CheckItem('Group of borrowers', 'No conflicts detected'),
    _CheckItem('Sanctions screening', 'Clear'),
    _CheckItem('Central file', 'Documents up to date'),
  ];

  int _completedChecks = 0;
  bool _allChecksComplete = false;

  @override
  void initState() {
    super.initState();
    _runChecks();
  }

  void _runChecks() async {
    for (int i = 0; i < _checks.length; i++) {
      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) {
        setState(() {
          _completedChecks = i + 1;
        });
      }
    }
    await Future.delayed(const Duration(milliseconds: 300));
    if (mounted) {
      setState(() {
        _allChecksComplete = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Compliance Check',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: AppColors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'We\'re verifying your eligibility. This only takes a moment.',
            style: TextStyle(
              fontSize: 15,
              color: AppColors.white.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 32),
          // Checklist
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.white.withValues(alpha: 0.1),
                  ),
                ),
                child: Column(
                  children: _checks.asMap().entries.map((entry) {
                    final index = entry.key;
                    final check = entry.value;
                    final isComplete = index < _completedChecks;
                    final isRunning = index == _completedChecks;

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        children: [
                          _buildStatusIcon(isComplete, isRunning),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  check.label,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: isComplete || isRunning
                                        ? AppColors.white
                                        : AppColors.white.withValues(alpha: 0.4),
                                  ),
                                ),
                                if (isComplete)
                                  Text(
                                    check.result,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: AppColors.success,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Success message
          if (_allChecksComplete)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.success.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    color: AppColors.success,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Everything looks good! Let\'s continue.',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.success,
                      ),
                    ),
                  ),
                ],
              ),
            )
                .animate()
                .fadeIn(duration: 400.ms)
                .slideY(begin: 0.2, end: 0),
          const SizedBox(height: 40),
          // Navigation buttons
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: OutlinedButton(
                      onPressed: widget.onBack,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(
                          color: AppColors.white.withValues(alpha: 0.2),
                        ),
                        backgroundColor: AppColors.white.withValues(alpha: 0.05),
                      ),
                      child: Text(
                        'Back',
                        style: TextStyle(color: AppColors.white),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: _allChecksComplete ? widget.onNext : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accentBlue,
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    disabledBackgroundColor: AppColors.white.withValues(alpha: 0.1),
                  ),
                  child: Text(
                    'Continue',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusIcon(bool isComplete, bool isRunning) {
    if (isComplete) {
      return Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: AppColors.success,
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.check,
          size: 18,
          color: AppColors.white,
        ),
      )
          .animate()
          .scale(begin: const Offset(0, 0), end: const Offset(1, 1), duration: 200.ms);
    }

    if (isRunning) {
      return SizedBox(
        width: 28,
        height: 28,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation(AppColors.accentBlue),
        ),
      );
    }

    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
    );
  }
}

class _CheckItem {
  final String label;
  final String result;

  _CheckItem(this.label, this.result);
}
