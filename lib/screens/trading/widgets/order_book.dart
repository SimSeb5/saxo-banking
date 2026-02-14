import 'package:flutter/material.dart';
import 'dart:ui';
import '../../../theme/app_theme.dart';

class OrderBook extends StatelessWidget {
  const OrderBook({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Book',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.white,
            ),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.white.withValues(alpha: 0.1),
                  ),
                ),
                child: Column(
                  children: [
                    // Header
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Bid',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppColors.success,
                            ),
                          ),
                        ),
                        Text(
                          'Price',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.white.withValues(alpha: 0.5),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'Ask',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppColors.danger,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Order book levels
                    ..._buildOrderBookLevels(),
                    const SizedBox(height: 12),
                    // Spread
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.white.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Spread: ',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.white.withValues(alpha: 0.5),
                            ),
                          ),
                          Text(
                            '\$0.02 (0.01%)',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildOrderBookLevels() {
    final levels = [
      _OrderLevel(bidSize: 1250, price: 245.28, askSize: 800),
      _OrderLevel(bidSize: 2100, price: 245.29, askSize: 1500),
      _OrderLevel(bidSize: 850, price: 245.30, askSize: 3200),
      _OrderLevel(bidSize: 1800, price: 245.31, askSize: 950),
      _OrderLevel(bidSize: 600, price: 245.32, askSize: 2800),
    ];

    final maxSize = levels
        .map((l) => l.bidSize > l.askSize ? l.bidSize : l.askSize)
        .reduce((a, b) => a > b ? a : b);

    return levels.map((level) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            // Bid bar
            Expanded(
              child: Row(
                children: [
                  Text(
                    level.bidSize.toString(),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        height: 20,
                        width: (level.bidSize / maxSize) * 80,
                        decoration: BoxDecoration(
                          color: AppColors.success.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Price
            Container(
              width: 70,
              alignment: Alignment.center,
              child: Text(
                '\$${level.price.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.white,
                ),
              ),
            ),
            // Ask bar
            Expanded(
              child: Row(
                children: [
                  Container(
                    height: 20,
                    width: (level.askSize / maxSize) * 80,
                    decoration: BoxDecoration(
                      color: AppColors.danger.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      level.askSize.toString(),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.white,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }).toList();
  }
}

class _OrderLevel {
  final int bidSize;
  final double price;
  final int askSize;

  _OrderLevel({
    required this.bidSize,
    required this.price,
    required this.askSize,
  });
}
