import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:ui';
import '../../../theme/app_theme.dart';
import '../../../models/payment.dart';
import '../../../utils/formatters.dart';
import '../payment_success_screen.dart';

class ReviewStep extends StatelessWidget {
  final Contact recipient;
  final double amount;
  final String currency;

  const ReviewStep({
    super.key,
    required this.recipient,
    required this.amount,
    required this.currency,
  });

  void _confirmPayment(BuildContext context) {
    Navigator.of(context).pushReplacement(
      CupertinoPageRoute(
        builder: (context) => PaymentSuccessScreen(
          recipient: recipient,
          amount: amount,
          currency: currency,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0A1E3D),
              Color(0xFF071428),
              Color(0xFF0D2847),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom App Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back_ios, color: AppColors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    Expanded(
                      child: Text(
                        'Review Payment',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Amount card
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: AppColors.white.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: AppColors.white.withValues(alpha: 0.1),
                              ),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  'You are sending',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: AppColors.white.withValues(alpha: 0.6),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  Formatters.formatCurrency(amount, currency),
                                  style: TextStyle(
                                    fontSize: 36,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.accentBlue,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: AppColors.accentBlue.withValues(alpha: 0.2),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      recipient.initials,
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.accentBlue,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  recipient.name,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.white,
                                  ),
                                ),
                                Text(
                                  recipient.accountPreview,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: AppColors.white.withValues(alpha: 0.5),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Details card
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: AppColors.white.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: AppColors.white.withValues(alpha: 0.1),
                              ),
                            ),
                            child: Column(
                              children: [
                                _DetailRow(
                                  label: 'From',
                                  value: 'CHF Main Account',
                                ),
                                Container(
                                  height: 1,
                                  margin: const EdgeInsets.symmetric(vertical: 14),
                                  color: AppColors.white.withValues(alpha: 0.08),
                                ),
                                _DetailRow(
                                  label: 'To',
                                  value: recipient.accountPreview,
                                ),
                                Container(
                                  height: 1,
                                  margin: const EdgeInsets.symmetric(vertical: 14),
                                  color: AppColors.white.withValues(alpha: 0.08),
                                ),
                                _DetailRow(
                                  label: 'Fee',
                                  value: recipient.isInternal ? 'Free' : '$currency 5.00',
                                  valueColor:
                                      recipient.isInternal ? AppColors.success : null,
                                ),
                                Container(
                                  height: 1,
                                  margin: const EdgeInsets.symmetric(vertical: 14),
                                  color: AppColors.white.withValues(alpha: 0.08),
                                ),
                                _DetailRow(
                                  label: 'Execution',
                                  value: 'Immediate',
                                ),
                                Container(
                                  height: 1,
                                  margin: const EdgeInsets.symmetric(vertical: 14),
                                  color: AppColors.white.withValues(alpha: 0.08),
                                ),
                                _DetailRow(
                                  label: 'Reference',
                                  value: 'Add reference (optional)',
                                  isLink: true,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Total
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: AppColors.accentBlue.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: AppColors.accentBlue.withValues(alpha: 0.25),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Total Debit',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.white,
                                  ),
                                ),
                                Text(
                                  Formatters.formatCurrency(
                                    amount + (recipient.isInternal ? 0 : 5),
                                    currency,
                                  ),
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Confirm button
              ClipRRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.white.withValues(alpha: 0.05),
                      border: Border(
                        top: BorderSide(
                          color: AppColors.white.withValues(alpha: 0.1),
                        ),
                      ),
                    ),
                    child: SafeArea(
                      top: false,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.face_unlock_outlined,
                                size: 20,
                                color: AppColors.white.withValues(alpha: 0.5),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Confirm with Face ID',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.white.withValues(alpha: 0.5),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () => _confirmPayment(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.accentBlue,
                                foregroundColor: AppColors.white,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                'Confirm & Send',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final bool isLink;

  const _DetailRow({
    required this.label,
    required this.value,
    this.valueColor,
    this.isLink = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: AppColors.white.withValues(alpha: 0.6),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: valueColor ?? (isLink ? AppColors.accentBlue : AppColors.white),
          ),
        ),
      ],
    );
  }
}
