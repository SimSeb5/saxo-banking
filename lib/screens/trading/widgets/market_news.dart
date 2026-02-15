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

  static final _allNewsItems = [
    ..._newsItems,
    _NewsItem(
      title: 'ECB maintains rates amid inflation concerns',
      source: 'ECB Press',
      time: '7h ago',
      category: 'Economy',
    ),
    _NewsItem(
      title: 'Tech stocks rally on strong earnings season',
      source: 'CNBC',
      time: '8h ago',
      category: 'Stocks',
    ),
    _NewsItem(
      title: 'Oil prices surge on OPEC supply cut extension',
      source: 'Reuters',
      time: '9h ago',
      category: 'Commodities',
    ),
    _NewsItem(
      title: 'Crypto market update: Bitcoin holds above key level',
      source: 'CoinDesk',
      time: '10h ago',
      category: 'Crypto',
    ),
  ];

  static final _articleTexts = {
    'Fed signals potential rate cuts in 2026':
        'The Federal Reserve has indicated a potential shift in monetary policy, signaling that rate cuts could be on the horizon in 2026. Officials cited improving inflation data and a desire to support sustained economic growth. Markets responded positively, with bond yields falling across the curve as investors adjusted their rate expectations.',
    'NVIDIA reports record quarterly earnings':
        'NVIDIA Corporation reported record-breaking quarterly earnings, driven by surging demand for AI computing chips and data center infrastructure. Revenue exceeded analyst expectations by a significant margin, with the data center segment leading growth. The company also raised its forward guidance, citing continued strong demand from hyperscale cloud providers.',
    'Gold hits new all-time high amid uncertainty':
        'Gold prices surged to a new all-time high as investors sought safe-haven assets amid growing geopolitical uncertainty and inflation concerns. Central bank purchases remained a key driver, with several emerging market central banks continuing to diversify their reserves. Analysts suggest the rally could continue if macroeconomic headwinds persist.',
    'Swiss franc strengthens against major currencies':
        'The Swiss franc appreciated against most major currencies as global investors rotated into safe-haven assets. The Swiss National Bank maintained its measured approach to monetary policy, which supported the currency. The move reflects broader risk-off sentiment in global markets and Switzerland\'s perceived economic stability.',
    'ECB maintains rates amid inflation concerns':
        'The European Central Bank decided to keep interest rates unchanged at its latest meeting, citing persistent inflation pressures across the eurozone. President Lagarde emphasized that the bank would remain data-dependent in its approach to future rate decisions. Markets had widely anticipated the hold, with attention now shifting to the March meeting.',
    'Tech stocks rally on strong earnings season':
        'Technology stocks surged broadly as the earnings season delivered results that exceeded Wall Street expectations. Major tech companies reported robust revenue growth driven by AI adoption and cloud computing demand. The NASDAQ Composite posted its strongest weekly gain in months, buoyed by renewed investor confidence in the sector.',
    'Oil prices surge on OPEC supply cut extension':
        'Crude oil prices jumped sharply after OPEC+ members agreed to extend voluntary production cuts through the end of the quarter. The decision came amid concerns about weakening demand from key markets, with the cartel aiming to support prices at current levels. Brent crude rose above \$85 per barrel following the announcement.',
    'Crypto market update: Bitcoin holds above key level':
        'Bitcoin maintained its position above the key psychological level as institutional adoption continued to accelerate. Spot Bitcoin ETFs saw record weekly inflows, signaling growing mainstream acceptance. Analysts noted that the upcoming halving event and favorable macroeconomic conditions could provide further tailwinds for the leading cryptocurrency.',
  };

  void _showAllNews(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.85,
          maxChildSize: 0.85,
          minChildSize: 0.5,
          builder: (context, scrollController) {
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
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.white.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Market News',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: AppColors.white,
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: Icon(
                            Icons.close,
                            color: AppColors.white.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ListView.separated(
                      controller: scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: _allNewsItems.length,
                      separatorBuilder: (context, index) => Container(
                        height: 1,
                        color: AppColors.white.withValues(alpha: 0.08),
                      ),
                      itemBuilder: (context, index) {
                        final item = _allNewsItems[index];
                        return InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            _showNewsDetail(context, item);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 14),
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
                                        color: AppColors.accentBlue
                                            .withValues(alpha: 0.2),
                                        borderRadius:
                                            BorderRadius.circular(4),
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
                                        color: AppColors.white
                                            .withValues(alpha: 0.5),
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
                                    color: AppColors.white
                                        .withValues(alpha: 0.5),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showNewsDetail(BuildContext context, _NewsItem item) {
    final articleText = _articleTexts[item.title] ??
        'Full article content is currently unavailable. Please check back later for the complete story.';

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF1A3A5C),
                Color(0xFF0A1E3D),
              ],
            ),
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(24),
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: 8),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
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
                    IconButton(
                      onPressed: () => Navigator.pop(sheetContext),
                      icon: Icon(
                        Icons.close,
                        color: AppColors.white.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: AppColors.white,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Text(
                            item.source,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: AppColors.accentBlue,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            item.time,
                            style: TextStyle(
                              fontSize: 13,
                              color:
                                  AppColors.white.withValues(alpha: 0.5),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Container(
                        height: 1,
                        color: AppColors.white.withValues(alpha: 0.1),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        articleText,
                        style: TextStyle(
                          fontSize: 15,
                          color: AppColors.white.withValues(alpha: 0.85),
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(sheetContext);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Article link copied to clipboard'),
                          backgroundColor:
                              AppColors.accentBlue.withValues(alpha: 0.9),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          AppColors.white.withValues(alpha: 0.12),
                      foregroundColor: AppColors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: AppColors.white.withValues(alpha: 0.15),
                        ),
                      ),
                      elevation: 0,
                    ),
                    icon: const Icon(Icons.share_outlined, size: 20),
                    label: const Text(
                      'Share',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

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
                onPressed: () => _showAllNews(context),
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
                    return _NewsTile(
                      item: _newsItems[index],
                      onTap: () =>
                          _showNewsDetail(context, _newsItems[index]),
                    );
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
  final VoidCallback? onTap;

  const _NewsTile({required this.item, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
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
