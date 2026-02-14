import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'dart:ui';
import '../../../theme/app_theme.dart';
import '../../../utils/formatters.dart';

class MarginMonitor extends StatelessWidget {
  const MarginMonitor({super.key});

  @override
  Widget build(BuildContext context) {
    const marginUsed = 125000.0;
    const totalMargin = 500000.0;
    const utilizationPercent = marginUsed / totalMargin;
    const marginCallLevel = 0.80;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ClipRRect(
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Margin Monitor',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.white,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.success.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'Healthy',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.success,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Utilization bar
                LinearPercentIndicator(
                  lineHeight: 12,
                  percent: utilizationPercent,
                  backgroundColor: AppColors.white.withValues(alpha: 0.1),
                  progressColor: _getUtilizationColor(utilizationPercent),
                  barRadius: const Radius.circular(6),
                  padding: EdgeInsets.zero,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${(utilizationPercent * 100).toStringAsFixed(0)}% utilized',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.white.withValues(alpha: 0.5),
                      ),
                    ),
                    Text(
                      'Margin call at ${(marginCallLevel * 100).toStringAsFixed(0)}%',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.warning,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Details
                Row(
                  children: [
                    Expanded(
                      child: _MarginDetail(
                        label: 'Margin Used',
                        value: Formatters.formatCurrency(marginUsed, 'CHF'),
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 40,
                      color: AppColors.white.withValues(alpha: 0.1),
                    ),
                    Expanded(
                      child: _MarginDetail(
                        label: 'Available',
                        value: Formatters.formatCurrency(
                            totalMargin - marginUsed, 'CHF'),
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 40,
                      color: AppColors.white.withValues(alpha: 0.1),
                    ),
                    Expanded(
                      child: _MarginDetail(
                        label: 'To Margin Call',
                        value: Formatters.formatCurrency(
                            totalMargin * marginCallLevel - marginUsed, 'CHF'),
                        valueColor: AppColors.success,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getUtilizationColor(double percent) {
    if (percent < 0.5) return AppColors.success;
    if (percent < 0.7) return AppColors.warning;
    return AppColors.danger;
  }
}

class _MarginDetail extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _MarginDetail({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: AppColors.white.withValues(alpha: 0.5),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: valueColor ?? AppColors.white,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
