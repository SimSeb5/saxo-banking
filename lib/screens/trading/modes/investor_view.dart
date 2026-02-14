import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:ui';
import '../../../theme/app_theme.dart';
import '../../../data/mock_data.dart';
import '../../../models/holding.dart';
import '../widgets/portfolio_chart.dart';
import '../widgets/holdings_list.dart';
import '../widgets/watchlist.dart';

class InvestorView extends StatelessWidget {
  final Function(Holding)? onHoldingTap;

  const InvestorView({super.key, this.onHoldingTap});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          // Portfolio Chart
          const PortfolioChart(),
          const SizedBox(height: 24),
          // Asset Allocation
          _buildAssetAllocation(),
          const SizedBox(height: 24),
          // Holdings
          HoldingsList(onHoldingTap: onHoldingTap),
          const SizedBox(height: 24),
          // Watchlist
          const WatchlistWidget(),
          const SizedBox(height: 24),
          // Discover Section
          _buildDiscoverSection(),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildAssetAllocation() {
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
                Text(
                  'Asset Allocation',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    // Donut chart
                    SizedBox(
                      width: 120,
                      height: 120,
                      child: PieChart(
                        PieChartData(
                          sectionsSpace: 2,
                          centerSpaceRadius: 35,
                          sections: _buildPieChartSections(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 24),
                    // Legend
                    Expanded(
                      child: Column(
                        children: MockData.assetAllocation.entries.map((entry) {
                          return _LegendItem(
                            label: entry.key,
                            value: '${entry.value.toStringAsFixed(0)}%',
                            color: _getColorForCategory(entry.key),
                          );
                        }).toList(),
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

  List<PieChartSectionData> _buildPieChartSections() {
    final colors = [
      AppColors.accentBlue,
      const Color(0xFF5EEAD4),
      AppColors.success,
      AppColors.white.withValues(alpha: 0.4),
    ];

    return MockData.assetAllocation.entries.toList().asMap().entries.map((e) {
      return PieChartSectionData(
        value: e.value.value,
        color: colors[e.key % colors.length],
        radius: 25,
        showTitle: false,
      );
    }).toList();
  }

  Color _getColorForCategory(String category) {
    switch (category) {
      case 'Equities':
        return AppColors.accentBlue;
      case 'Bonds':
        return const Color(0xFF5EEAD4);
      case 'ETFs':
        return AppColors.success;
      case 'Cash':
        return AppColors.white.withValues(alpha: 0.4);
      default:
        return AppColors.white.withValues(alpha: 0.5);
    }
  }

  Widget _buildDiscoverSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Discover',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.white,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 100,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _DiscoverCard(
                  title: 'Popular ETFs',
                  subtitle: 'Top performers',
                  icon: Icons.trending_up,
                ),
                _DiscoverCard(
                  title: 'Top Movers',
                  subtitle: "Today's highlights",
                  icon: Icons.bolt,
                ),
                _DiscoverCard(
                  title: 'Saxo Picks',
                  subtitle: 'Expert selections',
                  icon: Icons.star_outline,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _LegendItem({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: AppColors.white.withValues(alpha: 0.6),
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _DiscoverCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const _DiscoverCard({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: 140,
          margin: const EdgeInsets.only(right: 12),
          padding: const EdgeInsets.all(16),
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
              Icon(
                icon,
                size: 24,
                color: AppColors.accentBlue,
              ),
              const Spacer(),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.white,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.white.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
