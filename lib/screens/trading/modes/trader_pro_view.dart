import 'package:flutter/material.dart';
import 'dart:ui';
import '../../../theme/app_theme.dart';
import '../../../models/holding.dart';
import '../widgets/portfolio_chart.dart';
import '../widgets/holdings_list.dart';
import '../widgets/order_book.dart';
import '../widgets/margin_monitor.dart';
import '../widgets/market_news.dart';

class TraderProView extends StatefulWidget {
  final Function(Holding)? onHoldingTap;

  const TraderProView({super.key, this.onHoldingTap});

  @override
  State<TraderProView> createState() => _TraderProViewState();
}

class _TraderProViewState extends State<TraderProView> {
  bool _oneClickEnabled = false;

  void _showOrderConfirmationSheet({
    required String side,
    required String price,
    required Color color,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF1A3A5C),
                Color(0xFF0A1E3D),
              ],
            ),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              // Drag handle
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Order Confirmation',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.white,
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    _buildSheetRow('Instrument', 'AAPL'),
                    const SizedBox(height: 12),
                    _buildSheetRow('Quantity', '100 shares'),
                    const SizedBox(height: 12),
                    _buildSheetRow('Price', price),
                    const SizedBox(height: 12),
                    _buildSheetRow('Side', side.toUpperCase()),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(this.context).showSnackBar(
                        SnackBar(
                          content: Text(
                            '${side.substring(0, 1).toUpperCase()}${side.substring(1).toLowerCase()} order placed for 100 AAPL shares',
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Confirm ${side.substring(0, 1).toUpperCase()}${side.substring(1).toLowerCase()}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSheetRow(String label, String value) {
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
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.white,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          // Pro Chart with more features
          const PortfolioChart(showCandlestick: true),
          const SizedBox(height: 24),
          // Quick Trade Panel
          _buildQuickTradePanel(),
          const SizedBox(height: 24),
          // Order Book
          const OrderBook(),
          const SizedBox(height: 24),
          // Margin Monitor
          const MarginMonitor(),
          const SizedBox(height: 24),
          // Advanced Order Types
          _buildAdvancedOrderTypes(),
          const SizedBox(height: 24),
          // Position Analytics
          _buildPositionAnalytics(),
          const SizedBox(height: 24),
          // Holdings
          HoldingsList(showDetails: true, onHoldingTap: widget.onHoldingTap),
          const SizedBox(height: 24),
          // Market News
          const MarketNews(),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildQuickTradePanel() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.white.withValues(alpha: 0.15),
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Quick Trade',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.white,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          'One-Click',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.white.withValues(alpha: 0.7),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Switch(
                          value: _oneClickEnabled,
                          onChanged: (value) {
                            setState(() {
                              _oneClickEnabled = value;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'One-Click Trading ${value ? 'enabled' : 'disabled'}',
                                ),
                              ),
                            );
                          },
                          activeTrackColor: AppColors.accentBlue.withValues(alpha: 0.5),
                          activeThumbColor: AppColors.accentBlue,
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _QuickTradeButton(
                        label: 'BUY',
                        price: '\$245.30',
                        color: AppColors.success,
                        onTap: () {
                          _showOrderConfirmationSheet(
                            side: 'Buy',
                            price: '\$245.30',
                            color: AppColors.success,
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _QuickTradeButton(
                        label: 'SELL',
                        price: '\$245.28',
                        color: AppColors.danger,
                        onTap: () {
                          _showOrderConfirmationSheet(
                            side: 'Sell',
                            price: '\$245.28',
                            color: AppColors.danger,
                          );
                        },
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

  Widget _buildAdvancedOrderTypes() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Advanced Orders',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.white,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _OrderTypeChip(label: 'TWAP', isActive: false),
              _OrderTypeChip(label: 'Iceberg', isActive: false),
              _OrderTypeChip(label: 'OCO', isActive: true),
              _OrderTypeChip(label: 'Trailing Stop', isActive: false),
              _OrderTypeChip(label: 'Bracket', isActive: false),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPositionAnalytics() {
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
                  'Position Analytics',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _AnalyticItem(
                        label: 'Unrealized P&L',
                        value: '+CHF 42,350',
                        valueColor: AppColors.success,
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 40,
                      color: AppColors.white.withValues(alpha: 0.1),
                    ),
                    Expanded(
                      child: _AnalyticItem(
                        label: 'Day P&L',
                        value: '+CHF 3,250',
                        valueColor: AppColors.success,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  height: 1,
                  color: AppColors.white.withValues(alpha: 0.1),
                ),
                const SizedBox(height: 16),
                Text(
                  'Exposure by Region',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.white.withValues(alpha: 0.5),
                  ),
                ),
                const SizedBox(height: 12),
                _ExposureBar(
                  segments: [
                    _ExposureSegment('US', 0.55, AppColors.accentBlue),
                    _ExposureSegment('EU', 0.25, const Color(0xFF5EEAD4)),
                    _ExposureSegment('CH', 0.15, AppColors.success),
                    _ExposureSegment('Other', 0.05, AppColors.white.withValues(alpha: 0.4)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _QuickTradeButton extends StatelessWidget {
  final String label;
  final String price;
  final Color color;
  final VoidCallback onTap;

  const _QuickTradeButton({
    required this.label,
    required this.price,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.white,
              ),
            ),
            Text(
              price,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OrderTypeChip extends StatelessWidget {
  final String label;
  final bool isActive;

  const _OrderTypeChip({
    required this.label,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: isActive
            ? AppColors.accentBlue.withValues(alpha: 0.3)
            : AppColors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isActive
              ? AppColors.accentBlue.withValues(alpha: 0.5)
              : AppColors.white.withValues(alpha: 0.1),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: isActive ? AppColors.white : AppColors.white.withValues(alpha: 0.6),
        ),
      ),
    );
  }
}

class _AnalyticItem extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _AnalyticItem({
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
            fontSize: 13,
            color: AppColors.white.withValues(alpha: 0.5),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: valueColor ?? AppColors.white,
          ),
        ),
      ],
    );
  }
}

class _ExposureSegment {
  final String label;
  final double percent;
  final Color color;

  _ExposureSegment(this.label, this.percent, this.color);
}

class _ExposureBar extends StatelessWidget {
  final List<_ExposureSegment> segments;

  const _ExposureBar({required this.segments});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Row(
            children: segments.map((segment) {
              return Expanded(
                flex: (segment.percent * 100).toInt(),
                child: Container(
                  height: 8,
                  color: segment.color,
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: segments.map((segment) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: segment.color,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  '${segment.label} ${(segment.percent * 100).toInt()}%',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.white.withValues(alpha: 0.6),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }
}
