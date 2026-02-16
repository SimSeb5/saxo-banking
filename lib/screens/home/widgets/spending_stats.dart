import 'dart:math';
import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../../../data/mock_data.dart';
import '../../../models/account.dart';
import '../../../models/transaction.dart';
import '../../../utils/formatters.dart';

class SpendingStats extends StatelessWidget {
  final int selectedAccountIndex;

  const SpendingStats({
    super.key,
    required this.selectedAccountIndex,
  });

  @override
  Widget build(BuildContext context) {
    if (selectedAccountIndex > 0) {
      final account = MockData.accounts[selectedAccountIndex - 1];
      if (account.accountType == AccountType.savings) {
        return _buildSavingsInfo(context, account);
      }
      if (account.balance == 0) {
        return const SizedBox.shrink();
      }
    }

    return _buildSpendingStats(context);
  }

  Widget _buildSavingsInfo(BuildContext context, Account account) {
    final currency = account.currency;
    final rate = account.interestRate ?? 2.50;
    final term = account.term ?? 'Flexible';
    final payout = account.interestPayout ?? 'Monthly';
    final accruedInterest = account.balance * (rate / 100 / 12);

    final isFlexible = term == 'Flexible';
    final lockIn = isFlexible ? 'None' : term;
    final withdrawal = isFlexible
        ? 'Anytime, no penalty'
        : 'Early withdrawal fee applies';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Savings Details',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.white,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.white.withValues(alpha: 0.1),
              ),
            ),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '${rate.toStringAsFixed(2)}%',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          color: AppColors.success,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Annual Interest Rate',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.white.withValues(alpha: 0.5),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _InfoRow(
                  label: 'Accrued This Month',
                  value: Formatters.formatCurrency(accruedInterest, currency),
                  valueColor: AppColors.success,
                ),
                const SizedBox(height: 12),
                _InfoRow(label: 'Term', value: term),
                const SizedBox(height: 12),
                _InfoRow(label: 'Interest Payout', value: payout),
                const SizedBox(height: 12),
                _InfoRow(label: 'Lock-in Period', value: lockIn),
                const SizedBox(height: 12),
                _InfoRow(label: 'Withdrawal', value: withdrawal),
                const SizedBox(height: 12),
                _InfoRow(label: 'Compounding', value: 'Daily'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpendingStats(BuildContext context) {
    final currency = MockData.currencyForIndex(selectedAccountIndex);
    final balance = MockData.cashForAccountIndex(selectedAccountIndex);
    final categories = categoriesForAccount(selectedAccountIndex, balance);

    double totalSpent = 0;
    for (final c in categories) {
      totalSpent += c.amount;
    }
    final totalReceived = balance * 0.02;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with "See more"
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'This Month',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.white,
                ),
              ),
              GestureDetector(
                onTap: () => _showDetailedStats(context),
                child: Text(
                  'See more',
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
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.white.withValues(alpha: 0.1),
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Spent',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.white.withValues(alpha: 0.45),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            Formatters.formatCurrencyRounded(totalSpent, currency),
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: AppColors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 36,
                      color: AppColors.white.withValues(alpha: 0.1),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Received',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.white.withValues(alpha: 0.45),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              Formatters.formatCurrencyRounded(totalReceived, currency),
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: AppColors.success,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                if (categories.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: SizedBox(
                      height: 6,
                      child: Row(
                        children: categories.map((c) {
                          return Expanded(
                            flex: (c.percentage * 100).round().clamp(1, 100),
                            child: Container(
                              color: c.color,
                              margin: const EdgeInsets.only(right: 1),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  ...categories.map((c) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: c.color,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          c.label,
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.white.withValues(alpha: 0.7),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          Formatters.formatCurrencyRounded(c.amount, currency),
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.white.withValues(alpha: 0.85),
                          ),
                        ),
                      ],
                    ),
                  )),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showDetailedStats(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => AnalyticsPage(selectedAccountIndex: selectedAccountIndex),
      ),
    );
  }
}

// ── Full-page Analytics ──────────────────────────────────────

class AnalyticsPage extends StatefulWidget {
  final int selectedAccountIndex;
  const AnalyticsPage({super.key, required this.selectedAccountIndex});

  @override
  State<AnalyticsPage> createState() => AnalyticsPageState();
}

class AnalyticsPageState extends State<AnalyticsPage> {
  int selectedPeriod = 0;
  int selectedChart = 0; // 0=categories, 1=pie, 2=trend
  String? expandedCategory;

  static const periods = ['This Month', 'This Quarter', 'This Year', 'All Time'];
  static const multipliers = [1.0, 3.2, 12.5, 24.0];

  @override
  Widget build(BuildContext context) {
    final currency = MockData.currencyForIndex(widget.selectedAccountIndex);
    final balance = MockData.cashForAccountIndex(widget.selectedAccountIndex);
    final mult = multipliers[selectedPeriod];
    final categories = categoriesForAccount(widget.selectedAccountIndex, balance);
    final scaledCategories = categories
        .map((c) => SpendingCategory(c.label, c.amount * mult, c.percentage, c.color))
        .toList();

    double totalSpent = 0;
    for (final c in scaledCategories) {
      totalSpent += c.amount;
    }
    final totalReceived = balance * 0.02 * mult;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0D2847),
              Color(0xFF071428),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  children: [
                    Text(
                      'Analytics',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: AppColors.white,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: AppColors.white.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.close,
                          size: 20,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              // Time period selector
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: List.generate(periods.length, (i) {
                    final isSelected = i == selectedPeriod;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => selectedPeriod = i),
                        child: Container(
                          margin: EdgeInsets.only(right: i < periods.length - 1 ? 6 : 0),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.accentBlue
                                : AppColors.white.withValues(alpha: 0.06),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            periods[i].replaceAll('This ', ''),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isSelected
                                  ? AppColors.white
                                  : AppColors.white.withValues(alpha: 0.5),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 16),
              // Chart type selector
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppColors.white.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      _buildChartTab('Categories', 0),
                      _buildChartTab('Pie', 1),
                      _buildChartTab('Trend', 2),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Summary cards
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.white.withValues(alpha: 0.06),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Spent',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.white.withValues(alpha: 0.45),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              Formatters.formatCurrencyRounded(totalSpent, currency),
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: AppColors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.white.withValues(alpha: 0.06),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Received',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.white.withValues(alpha: 0.45),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              Formatters.formatCurrencyRounded(totalReceived, currency),
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: AppColors.success,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Chart area
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: selectedChart == 0
                      ? _buildCategoriesView(scaledCategories, currency)
                      : selectedChart == 1
                          ? _buildPieView(scaledCategories, currency)
                          : _buildTrendView(totalSpent, currency, mult),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChartTab(String label, int index) {
    final isSelected = index == selectedChart;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() {
          selectedChart = index;
          expandedCategory = null;
        }),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.accentBlue : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isSelected
                  ? AppColors.white
                  : AppColors.white.withValues(alpha: 0.5),
            ),
          ),
        ),
      ),
    );
  }

  // ── Categories view with tappable rows ──

  Widget _buildCategoriesView(List<SpendingCategory> categories, String currency) {
    if (categories.isEmpty) {
      return Center(
        child: Text(
          'No spending data',
          style: TextStyle(
            fontSize: 15,
            color: AppColors.white.withValues(alpha: 0.4),
          ),
        ),
      );
    }
    return SingleChildScrollView(
      child: Column(
        children: [
          // Stacked bar
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: SizedBox(
              height: 10,
              child: Row(
                children: categories.map((c) {
                  return Expanded(
                    flex: (c.percentage * 100).round().clamp(1, 100),
                    child: Container(
                      color: c.color,
                      margin: const EdgeInsets.only(right: 1),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 20),
          ...categories.map((c) => _buildCategoryRow(c, currency)),
        ],
      ),
    );
  }

  Widget _buildCategoryRow(SpendingCategory c, String currency) {
    final isExpanded = expandedCategory == c.label;
    final transactions = _transactionsForCategory(c.label);

    return Column(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => setState(() {
            expandedCategory = isExpanded ? null : c.label;
          }),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: c.color,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    c.label,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.white.withValues(alpha: 0.7),
                    ),
                  ),
                ),
                Text(
                  '${(c.percentage * 100).toStringAsFixed(0)}%',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.white.withValues(alpha: 0.4),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  Formatters.formatCurrencyRounded(c.amount, currency),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                  ),
                ),
                const SizedBox(width: 6),
                AnimatedRotation(
                  turns: isExpanded ? 0.25 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    Icons.chevron_right,
                    size: 18,
                    color: AppColors.white.withValues(alpha: 0.3),
                  ),
                ),
              ],
            ),
          ),
        ),
        // Expanded transactions
        AnimatedCrossFade(
          firstChild: const SizedBox.shrink(),
          secondChild: transactions.isNotEmpty
              ? Container(
                  margin: const EdgeInsets.only(left: 20, bottom: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.white.withValues(alpha: 0.04),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.white.withValues(alpha: 0.06),
                    ),
                  ),
                  child: Column(
                    children: transactions.map((t) {
                      final isCredit = t.type == TransactionType.credit;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: AppColors.white.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                t.categoryIcon,
                                size: 16,
                                color: AppColors.white.withValues(alpha: 0.6),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    t.title,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.white,
                                    ),
                                  ),
                                  Text(
                                    Formatters.formatDate(t.date),
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: AppColors.white.withValues(alpha: 0.4),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              '${isCredit ? '+' : ''}${Formatters.formatCurrencyRounded(t.amount.abs(), t.currency)}',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: isCredit ? AppColors.success : AppColors.white,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                )
              : Container(
                  margin: const EdgeInsets.only(left: 20, bottom: 12),
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                  decoration: BoxDecoration(
                    color: AppColors.white.withValues(alpha: 0.04),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      'No individual transactions',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.white.withValues(alpha: 0.35),
                      ),
                    ),
                  ),
                ),
          crossFadeState: isExpanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 200),
        ),
      ],
    );
  }

  List<Transaction> _transactionsForCategory(String categoryLabel) {
    final transactions = MockData.transactionsForIndex(widget.selectedAccountIndex);
    return transactions.where((t) {
      final catName = t.category.name;
      switch (categoryLabel.toLowerCase()) {
        case 'shopping':
          return catName == 'shopping';
        case 'investments':
          return catName == 'trade';
        case 'transfers':
          return catName == 'transfer';
        case 'dining':
          return catName == 'food';
        case 'dividends':
          return catName == 'dividend';
        case 'subscriptions':
          return catName == 'subscription';
        default:
          return catName == categoryLabel.toLowerCase();
      }
    }).toList();
  }

  // ── Pie view ──

  Widget _buildPieView(List<SpendingCategory> categories, String currency) {
    if (categories.isEmpty) {
      return Center(
        child: Text(
          'No spending data',
          style: TextStyle(
            fontSize: 15,
            color: AppColors.white.withValues(alpha: 0.4),
          ),
        ),
      );
    }
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 180,
            width: 180,
            child: CustomPaint(
              painter: _PieChartPainter(categories),
              size: const Size(180, 180),
            ),
          ),
          const SizedBox(height: 24),
          ...categories.map((c) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: c.color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    c.label,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.white.withValues(alpha: 0.7),
                    ),
                  ),
                ),
                Text(
                  Formatters.formatCurrencyRounded(c.amount, currency),
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.white.withValues(alpha: 0.5),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  '${(c.percentage * 100).toStringAsFixed(0)}%',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  // ── Trend view ──

  Widget _buildTrendView(double monthlySpent, String currency, double mult) {
    final months = ['Sep', 'Oct', 'Nov', 'Dec', 'Jan', 'Feb'];
    final random = Random(42);
    final data = List.generate(6, (i) {
      return monthlySpent * (0.7 + random.nextDouble() * 0.6) / mult;
    });
    data[5] = monthlySpent / mult;

    final maxVal = data.reduce(max);

    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 200,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(months.length, (i) {
                final ratio = maxVal > 0 ? data[i] / maxVal : 0.0;
                final isLast = i == months.length - 1;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          Formatters.formatNumberCompact(data[i]),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: AppColors.white.withValues(alpha: 0.4),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Flexible(
                          child: FractionallySizedBox(
                            heightFactor: ratio.clamp(0.05, 1.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: isLast
                                    ? AppColors.accentBlue
                                    : AppColors.accentBlue.withValues(alpha: 0.3),
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          months[i],
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: isLast ? FontWeight.w600 : FontWeight.w400,
                            color: isLast
                                ? AppColors.white
                                : AppColors.white.withValues(alpha: 0.4),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Shared helpers ──────────────────────────────────────────

List<SpendingCategory> categoriesForAccount(int index, double balance) {
  final scale = balance / 2637350;

  if (index == 0) {
    final shopping = 1299 * scale;
    final investments = 3570 * scale;
    final transfers = 15000 * scale;
    final dining = 385 * scale;
    final dividends = 2850 * scale;
    final total = shopping + investments + transfers + dining + dividends;
    if (total == 0) return [];
    return [
      SpendingCategory('Shopping', shopping, shopping / total, AppColors.warning),
      SpendingCategory('Investments', investments, investments / total, AppColors.accentBlue),
      SpendingCategory('Transfers', transfers, transfers / total, const Color(0xFF8B5CF6)),
      SpendingCategory('Dining', dining, dining / total, AppColors.accentGold),
      SpendingCategory('Dividends', dividends, dividends / total, AppColors.success),
    ];
  }

  if (balance <= 0) return [];

  final transactions = MockData.transactionsForIndex(index);
  if (transactions.isNotEmpty) {
    final Map<String, double> grouped = {};
    double total = 0;
    for (final t in transactions) {
      if (t.amount < 0) {
        final cat = t.category.name;
        grouped[cat] = (grouped[cat] ?? 0) + t.amount.abs();
        total += t.amount.abs();
      }
    }
    if (total > 0) {
      final colors = [
        AppColors.accentBlue,
        AppColors.warning,
        const Color(0xFF8B5CF6),
        AppColors.accentGold,
        AppColors.success,
      ];
      int colorIdx = 0;
      return grouped.entries.map((e) {
        final c = SpendingCategory(
          _capitalize(e.key),
          e.value,
          e.value / total,
          colors[colorIdx++ % colors.length],
        );
        return c;
      }).toList();
    }
  }

  final monthlySpend = balance * 0.015;
  final shopping = monthlySpend * 0.30;
  final transfers = monthlySpend * 0.35;
  final dining = monthlySpend * 0.15;
  final subscriptions = monthlySpend * 0.20;
  return [
    SpendingCategory('Shopping', shopping, 0.30, AppColors.warning),
    SpendingCategory('Transfers', transfers, 0.35, const Color(0xFF8B5CF6)),
    SpendingCategory('Dining', dining, 0.15, AppColors.accentGold),
    SpendingCategory('Subscriptions', subscriptions, 0.20, AppColors.accentBlue),
  ];
}

String _capitalize(String s) =>
    s.isEmpty ? s : '${s[0].toUpperCase()}${s.substring(1)}';

// ── Data classes ─────────────────────────────────────────────

class SpendingCategory {
  final String label;
  final double amount;
  final double percentage;
  final Color color;

  const SpendingCategory(this.label, this.amount, this.percentage, this.color);
}

class _PieChartPainter extends CustomPainter {
  final List<SpendingCategory> categories;

  _PieChartPainter(this.categories);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    double startAngle = -pi / 2;

    for (final cat in categories) {
      final sweepAngle = cat.percentage * 2 * pi;
      final paint = Paint()
        ..color = cat.color
        ..style = PaintingStyle.fill;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        paint,
      );
      startAngle += sweepAngle;
    }

    // Donut hole
    canvas.drawCircle(
      center,
      radius * 0.55,
      Paint()..color = const Color(0xFF0F2A4A),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoRow({required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: AppColors.white.withValues(alpha: 0.5),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: valueColor ?? AppColors.white,
          ),
        ),
      ],
    );
  }
}
