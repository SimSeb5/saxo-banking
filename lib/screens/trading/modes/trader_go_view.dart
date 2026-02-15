import 'package:flutter/material.dart';
import 'dart:ui';
import '../../../theme/app_theme.dart';
import '../../../models/holding.dart';
import '../widgets/portfolio_chart.dart';
import '../widgets/holdings_list.dart';
import '../widgets/watchlist.dart';
import '../widgets/market_news.dart';

class TraderGoView extends StatefulWidget {
  final Function(Holding)? onHoldingTap;

  const TraderGoView({super.key, this.onHoldingTap});

  @override
  State<TraderGoView> createState() => _TraderGoViewState();
}

class _TraderGoViewState extends State<TraderGoView> {
  final List<Map<String, dynamic>> _orders = [
    {
      'ticker': 'AAPL',
      'orderType': 'Limit Buy',
      'quantity': 10,
      'price': 240.00,
      'status': 'Pending',
    },
    {
      'ticker': 'NVDA',
      'orderType': 'Stop Loss',
      'quantity': 25,
      'price': 135.00,
      'status': 'Active',
    },
  ];

  void _removeOrder(int index) {
    setState(() {
      _orders.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          // Enhanced Portfolio Chart
          const PortfolioChart(showCandlestick: true),
          const SizedBox(height: 24),
          // Open Orders
          _buildOpenOrders(),
          const SizedBox(height: 24),
          // Holdings with more details
          HoldingsList(showDetails: true, onHoldingTap: widget.onHoldingTap),
          const SizedBox(height: 24),
          // Watchlist Pro with alerts
          const WatchlistWidget(showAlerts: true),
          const SizedBox(height: 24),
          // Market News
          const MarketNews(),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildOpenOrders() {
    final pendingCount = _orders.length;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Open Orders',
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
                  color: AppColors.warning.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '$pendingCount pending',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.warning,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.white.withValues(alpha: 0.1),
                  ),
                ),
                child: Column(
                  children: [
                    for (int i = 0; i < _orders.length; i++) ...[
                      if (i > 0)
                        Container(
                          height: 1,
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          color: AppColors.white.withValues(alpha: 0.08),
                        ),
                      _OrderTile(
                        ticker: _orders[i]['ticker'] as String,
                        orderType: _orders[i]['orderType'] as String,
                        quantity: _orders[i]['quantity'] as int,
                        price: _orders[i]['price'] as double,
                        status: _orders[i]['status'] as String,
                        onCancelled: () => _removeOrder(i),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderTile extends StatefulWidget {
  final String ticker;
  final String orderType;
  final int quantity;
  final double price;
  final String status;
  final VoidCallback? onCancelled;

  const _OrderTile({
    required this.ticker,
    required this.orderType,
    required this.quantity,
    required this.price,
    required this.status,
    this.onCancelled,
  });

  @override
  State<_OrderTile> createState() => _OrderTileState();
}

class _OrderTileState extends State<_OrderTile> {
  bool _cancelled = false;

  Future<void> _handleCancel() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Order'),
        content: Text(
          'Are you sure you want to cancel the ${widget.orderType} order for ${widget.ticker}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Yes'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      setState(() {
        _cancelled = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Order cancelled')),
      );
      widget.onCancelled?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_cancelled) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.accentBlue.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                widget.ticker,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.accentBlue,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.orderType,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: AppColors.white,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${widget.quantity} shares @ \$${widget.price}',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.white.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: widget.status == 'Active'
                      ? AppColors.success.withValues(alpha: 0.2)
                      : AppColors.warning.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  widget.status,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: widget.status == 'Active'
                        ? AppColors.success
                        : AppColors.warning,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              GestureDetector(
                onTap: _handleCancel,
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.danger,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
