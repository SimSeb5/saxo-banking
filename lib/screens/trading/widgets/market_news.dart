import 'package:flutter/material.dart';
import 'dart:ui';
import '../../../theme/app_theme.dart';

class MarketNews extends StatelessWidget {
  const MarketNews({super.key});

  static final _newsItems = [
    _NewsItem(
      title: 'Fed signals potential rate cuts in 2026',
      source: 'Reuters',
      time: '2h ago',
      category: 'Economy',
    ),
    _NewsItem(
      title: 'NVIDIA reports record quarterly earnings',
      source: 'Bloomberg',
      time: '4h ago',
      category: 'Stocks',
    ),
    _NewsItem(
      title: 'Gold hits new all-time high amid uncertainty',
      source: 'Financial Times',
      time: '5h ago',
      category: 'Commodities',
    ),
    _NewsItem(
      title: 'Swiss franc strengthens against major currencies',
      source: 'SIX',
      time: '6h ago',
      category: 'FX',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Market News',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.white,
                ),
              ),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'See all',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.accentBlue,
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
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _newsItems.length,
                  separatorBuilder: (context, index) => Container(
                    height: 1,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    color: AppColors.white.withValues(alpha: 0.08),
                  ),
                  itemBuilder: (context, index) {
                    return _NewsTile(item: _newsItems[index]);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NewsItem {
  final String title;
  final String source;
  final String time;
  final String category;

  _NewsItem({
    required this.title,
    required this.source,
    required this.time,
    required this.category,
  });
}

class _NewsTile extends StatelessWidget {
  final _NewsItem item;

  const _NewsTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.accentBlue.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    item.category,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: AppColors.accentBlue,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  item.time,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.white.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              item.title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              item.source,
              style: TextStyle(
                fontSize: 12,
                color: AppColors.white.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
