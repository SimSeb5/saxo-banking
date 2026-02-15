import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:fl_chart/fl_chart.dart';
import '../../../theme/app_theme.dart';
import '../../../data/mock_data.dart';
import '../../../utils/formatters.dart';

class PortfolioSummary extends StatelessWidget {
  final VoidCallback? onTap;

  const PortfolioSummary({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.white.withValues(alpha: 0.12),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.success.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              Icons.trending_up,
                              size: 18,
                              color: AppColors.success,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Investment Portfolio',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.white,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.white.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.arrow_forward_ios,
                          size: 14,
                          color: AppColors.white.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    Formatters.formatCurrency(MockData.portfolioValue, 'CHF'),
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: AppColors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.success.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.arrow_upward,
                              size: 12,
                              color: AppColors.success,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '+CHF 42,350 (${Formatters.formatPercent(MockData.portfolioYTDPercent)})',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.success,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'YTD',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.white.withValues(alpha: 0.5),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Mini sparkline chart
                  SizedBox(
                    height: 80,
                    child: LineChart(
                      LineChartData(
                        gridData: const FlGridData(show: false),
                        titlesData: const FlTitlesData(show: false),
                        borderData: FlBorderData(show: false),
                        lineTouchData: const LineTouchData(enabled: false),
                        lineBarsData: [
                          LineChartBarData(
                            spots: MockData.portfolioChartData
                                .asMap()
                                .entries
                                .map((e) => FlSpot(e.key.toDouble(), e.value / 1000000))
                                .toList(),
                            isCurved: true,
                            color: AppColors.success,
                            barWidth: 2.5,
                            isStrokeCapRound: true,
                            dotData: const FlDotData(show: false),
                            belowBarData: BarAreaData(
                              show: true,
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  AppColors.success.withValues(alpha: 0.3),
                                  AppColors.success.withValues(alpha: 0.0),
                                ],
                              ),
                            ),
                          ),
                        ],
                        minY: MockData.portfolioChartData.reduce((a, b) => a < b ? a : b) / 1000000 - 0.02,
                        maxY: MockData.portfolioChartData.reduce((a, b) => a > b ? a : b) / 1000000 + 0.02,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Period returns
                  Row(
                    children: [
                      Expanded(
                        child: _PeriodReturn(
                          label: 'Today',
                          value: MockData.portfolioTodayPercent,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _PeriodReturn(
                          label: '1M',
                          value: MockData.portfolio1MPercent,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _PeriodReturn(
                          label: 'YTD',
                          value: MockData.portfolioYTDPercent,
                        ),
                      ),
                    ],
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

class _PeriodReturn extends StatelessWidget {
  final String label;
  final double value;

  const _PeriodReturn({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final isPositive = value >= 0;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColors.white.withValues(alpha: 0.06),
        ),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: AppColors.white.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            Formatters.formatPercent(value),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isPositive ? AppColors.success : AppColors.danger,
            ),
          ),
        ],
      ),
    );
  }
}
