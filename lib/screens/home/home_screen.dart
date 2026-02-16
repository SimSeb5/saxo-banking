import 'package:flutter/material.dart';
import 'dart:ui';
import '../../theme/app_theme.dart';
import '../../data/mock_data.dart';
import '../../models/account.dart';
import 'widgets/account_switcher.dart';
import 'widgets/balance_section.dart';
import 'widgets/breakdown_section.dart';
import 'widgets/quick_actions.dart';
import 'widgets/recent_transactions.dart';
import 'widgets/spending_stats.dart';

class HomeScreen extends StatefulWidget {
  final Function(int)? onNavigateToTab;

  const HomeScreen({super.key, this.onNavigateToTab});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedAccountIndex = 0;

  void _deleteCurrentAccount() {
    if (_selectedAccountIndex <= 0 ||
        _selectedAccountIndex > MockData.accounts.length) {
      return;
    }
    setState(() {
      MockData.accounts.removeAt(_selectedAccountIndex - 1);
      _selectedAccountIndex = 0; // Switch back to All
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: AppColors.success),
            const SizedBox(width: 12),
            const Text('Account deleted'),
          ],
        ),
        backgroundColor: const Color(0xFF1A3A5C),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _showNewAccountSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.45,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF1A3A5C),
              const Color(0xFF0A1E3D),
            ],
          ),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.white.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Open New Account',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Choose your account type',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.white.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _AccountTypeCard(
                    icon: Icons.account_balance_wallet,
                    title: 'Current Account',
                    subtitle: 'Day-to-day banking and payments',
                    onTap: () {
                      Navigator.pop(context);
                      _showCurrencyPicker(context, AccountType.current);
                    },
                  ),
                  const SizedBox(height: 12),
                  _AccountTypeCard(
                    icon: Icons.savings,
                    title: 'Savings Account',
                    subtitle: 'Earn interest on your deposits',
                    onTap: () {
                      Navigator.pop(context);
                      _showCurrencyPicker(context, AccountType.savings);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static const _currencies = [
    ('CHF', '🇨🇭', 'Swiss Franc'),
    ('USD', '🇺🇸', 'US Dollar'),
    ('EUR', '🇪🇺', 'Euro'),
    ('GBP', '🇬🇧', 'British Pound'),
    ('JPY', '🇯🇵', 'Japanese Yen'),
    ('CAD', '🇨🇦', 'Canadian Dollar'),
    ('AUD', '🇦🇺', 'Australian Dollar'),
    ('SGD', '🇸🇬', 'Singapore Dollar'),
  ];

  void _showCurrencyPicker(BuildContext context, AccountType type) {
    final typeName = type == AccountType.current ? 'Current' : 'Savings';

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.65,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF1A3A5C),
              const Color(0xFF0A1E3D),
            ],
          ),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.white.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              '$typeName Account',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Choose your currency',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.white.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _currencies.length,
                separatorBuilder: (_, _) => Divider(
                  height: 1,
                  color: AppColors.white.withValues(alpha: 0.08),
                ),
                itemBuilder: (context, index) {
                  final (code, flag, name) = _currencies[index];
                  return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      Navigator.pop(context);
                      if (type == AccountType.savings) {
                        _showSavingsConditions(context, code, flag);
                      } else {
                        _createAccount(
                          context,
                          type: AccountType.current,
                          currency: code,
                          flag: flag,
                        );
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      child: Row(
                        children: [
                          Text(flag, style: const TextStyle(fontSize: 24)),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  code,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.white,
                                  ),
                                ),
                                Text(
                                  name,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: AppColors.white.withValues(alpha: 0.5),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 14,
                            color: AppColors.white.withValues(alpha: 0.3),
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
      ),
    );
  }

  void _showSavingsConditions(BuildContext context, String currency, String flag) {
    // Default rates based on currency
    final baseRate = currency == 'CHF' ? 2.50 : currency == 'USD' ? 4.75 : currency == 'EUR' ? 3.25 : 3.80;

    final terms = [
      ('Flexible', baseRate, 'No lock-in, withdraw anytime'),
      ('3 Months', baseRate + 0.25, 'Higher rate, 3-month commitment'),
      ('6 Months', baseRate + 0.50, 'Even better rate, 6-month term'),
      ('1 Year', baseRate + 0.75, 'Best rate, 12-month term'),
    ];

    List<String> payoutOptionsForTerm(int termIndex) {
      switch (terms[termIndex].$1) {
        case 'Flexible':
          return ['Monthly'];
        case '3 Months':
          return ['Monthly', 'At Maturity'];
        case '6 Months':
          return ['Monthly', 'Quarterly', 'At Maturity'];
        case '1 Year':
          return ['Monthly', 'Quarterly', 'Annually'];
        default:
          return ['Monthly'];
      }
    }

    int selectedTermIndex = 0;
    int selectedPayoutIndex = 0;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) {
          final selectedRate = terms[selectedTermIndex].$2;
          final payoutOptions = payoutOptionsForTerm(selectedTermIndex);
          if (selectedPayoutIndex >= payoutOptions.length) {
            selectedPayoutIndex = 0;
          }
          return Container(
            height: MediaQuery.of(context).size.height * 0.85,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFF1A3A5C),
                  const Color(0xFF0A1E3D),
                ],
              ),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              children: [
                const SizedBox(height: 12),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.white.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  '$currency Savings Account',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Set your conditions',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.white.withValues(alpha: 0.6),
                  ),
                ),
                const SizedBox(height: 24),
                // Scrollable content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Interest rate display
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          decoration: BoxDecoration(
                            color: AppColors.success.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            children: [
                              Text(
                                '${selectedRate.toStringAsFixed(2)}%',
                                style: TextStyle(
                                  fontSize: 40,
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
                        const SizedBox(height: 24),
                        // Term selection
                        Text(
                          'Term',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.white.withValues(alpha: 0.7),
                          ),
                        ),
                        const SizedBox(height: 10),
                        ...List.generate(terms.length, (i) {
                          final (label, rate, desc) = terms[i];
                          final isSelected = i == selectedTermIndex;
                          return GestureDetector(
                            onTap: () => setSheetState(() {
                              selectedTermIndex = i;
                              selectedPayoutIndex = 0;
                            }),
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.accentBlue.withValues(alpha: 0.15)
                                    : AppColors.white.withValues(alpha: 0.06),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.accentBlue
                                      : AppColors.white.withValues(alpha: 0.1),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: isSelected
                                            ? AppColors.accentBlue
                                            : AppColors.white.withValues(alpha: 0.3),
                                        width: 2,
                                      ),
                                      color: isSelected
                                          ? AppColors.accentBlue
                                          : Colors.transparent,
                                    ),
                                    child: isSelected
                                        ? const Icon(Icons.check, size: 14, color: Colors.white)
                                        : null,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          label,
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.white,
                                          ),
                                        ),
                                        Text(
                                          desc,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: AppColors.white.withValues(alpha: 0.5),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    '${rate.toStringAsFixed(2)}%',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.success,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                        const SizedBox(height: 16),
                        // Payout selection
                        Text(
                          'Interest Payout',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.white.withValues(alpha: 0.7),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: List.generate(payoutOptions.length, (i) {
                            final isSelected = i == selectedPayoutIndex;
                            return Expanded(
                              child: GestureDetector(
                                onTap: () => setSheetState(() => selectedPayoutIndex = i),
                                child: Container(
                                  margin: EdgeInsets.only(right: i < payoutOptions.length - 1 ? 8 : 0),
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? AppColors.accentBlue.withValues(alpha: 0.15)
                                        : AppColors.white.withValues(alpha: 0.06),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: isSelected
                                          ? AppColors.accentBlue
                                          : AppColors.white.withValues(alpha: 0.1),
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    payoutOptions[i],
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: isSelected
                                          ? AppColors.accentBlue
                                          : AppColors.white.withValues(alpha: 0.6),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
                // Pinned button at bottom
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _createAccount(
                          context,
                          type: AccountType.savings,
                          currency: currency,
                          flag: flag,
                          interestRate: selectedRate,
                          term: terms[selectedTermIndex].$1,
                          interestPayout: payoutOptions[selectedPayoutIndex],
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accentBlue,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Open Savings Account',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _createAccount(
    BuildContext context, {
    required AccountType type,
    required String currency,
    required String flag,
    double? interestRate,
    String? term,
    String? interestPayout,
  }) {
    final typeName = type == AccountType.current ? 'Current' : 'Savings';
    final accountName = '$currency $typeName Account';
    final newId = 'ACC${(MockData.accounts.length + 1).toString().padLeft(3, '0')}';

    final newAccount = Account(
      id: newId,
      name: accountName,
      currency: currency,
      balance: 0.00,
      flagEmoji: flag,
      accountType: type,
      interestRate: interestRate,
      term: term,
      interestPayout: interestPayout,
    );

    setState(() {
      MockData.accounts.add(newAccount);
      _selectedAccountIndex = MockData.accounts.length;
    });

    // Show success confirmation
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF1A3A5C),
              const Color(0xFF0A1E3D),
            ],
          ),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle,
                color: AppColors.success,
                size: 48,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Account Created!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: AppColors.white,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Your new $accountName is ready to use',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: AppColors.white.withValues(alpha: 0.7),
              ),
            ),
            if (type == AccountType.savings) ...[
              const SizedBox(height: 8),
              Text(
                '${interestRate?.toStringAsFixed(2)}% · $term · $interestPayout payout',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.success,
                ),
              ),
            ],
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accentBlue,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Done',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showNotificationsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF1A3A5C),
              const Color(0xFF0A1E3D),
            ],
          ),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.white.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Notifications',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.white,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _NotificationItem(
                    icon: Icons.trending_up,
                    iconColor: AppColors.success,
                    title: 'AAPL is up 2.5%',
                    subtitle: 'Your holding increased by CHF 1,250',
                    time: '2 min ago',
                  ),
                  _NotificationItem(
                    icon: Icons.payment,
                    iconColor: AppColors.accentBlue,
                    title: 'Payment received',
                    subtitle: 'CHF 5,000 from Marc Dubois',
                    time: '1 hour ago',
                  ),
                  _NotificationItem(
                    icon: Icons.security,
                    iconColor: AppColors.warning,
                    title: 'Security alert',
                    subtitle: 'New login from Zurich, Switzerland',
                    time: '3 hours ago',
                  ),
                  _NotificationItem(
                    icon: Icons.account_balance,
                    iconColor: AppColors.accentGold,
                    title: 'Lombard loan approved',
                    subtitle: 'Your CHF 500,000 credit line is ready',
                    time: 'Yesterday',
                  ),
                ],
              ),
            ),
          ],
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
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: RefreshIndicator(
            onRefresh: () async {
              await Future.delayed(const Duration(seconds: 1));
            },
            color: AppColors.accentBlue,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  // Top bar: avatar + bell
                  _buildTopBar(context),
                  const SizedBox(height: 20),
                  // Account switcher pills
                  AccountSwitcher(
                    selectedIndex: _selectedAccountIndex,
                    onSelected: (index) =>
                        setState(() => _selectedAccountIndex = index),
                    onNewAccount: () => _showNewAccountSheet(context),
                  ),
                  const SizedBox(height: 48),
                  // Balance + action pills (animated)
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: BalanceSection(
                      key: ValueKey(_selectedAccountIndex),
                      selectedAccountIndex: _selectedAccountIndex,
                      onNavigateToTab: widget.onNavigateToTab,
                      onRefresh: () => setState(() {}),
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Breakdown section (animated)
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: BreakdownSection(
                      key: ValueKey('breakdown_$_selectedAccountIndex'),
                      selectedAccountIndex: _selectedAccountIndex,
                      onNavigateToTab: widget.onNavigateToTab,
                      onSwitchAccount: (index) =>
                          setState(() => _selectedAccountIndex = index),
                      onDeleteAccount: _selectedAccountIndex > 0
                          ? () => _deleteCurrentAccount()
                          : null,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Recent transactions (filtered)
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: RecentTransactions(
                      key: ValueKey('txn_$_selectedAccountIndex'),
                      selectedAccountIndex: _selectedAccountIndex,
                      onNavigateToTab: widget.onNavigateToTab,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Spending stats
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: SpendingStats(
                      key: ValueKey('stats_$_selectedAccountIndex'),
                      selectedAccountIndex: _selectedAccountIndex,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Quick actions (1 row)
                  QuickActions(
                    onNavigateToTab: widget.onNavigateToTab,
                    selectedAccountIndex: _selectedAccountIndex,
                  ),
                  const SizedBox(height: 110),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          // Title
          Text(
            'Home',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: AppColors.white,
            ),
          ),
          const Spacer(),
          // Notification bell
          GestureDetector(
            onTap: () => _showNotificationsSheet(context),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.white.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: AppColors.white.withValues(alpha: 0.12),
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(
                    Icons.notifications_outlined,
                    size: 22,
                    color: AppColors.white,
                  ),
                  Positioned(
                    right: 10,
                    top: 10,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: AppColors.accentGold,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFF0A1E3D),
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          // Account avatar
          GestureDetector(
            onTap: () => widget.onNavigateToTab?.call(4),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.white.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: AppColors.white.withValues(alpha: 0.12),
                ),
              ),
              child: Center(
                child: Text(
                  MockData.userProfile.initials,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AccountTypeCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _AccountTypeCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.white.withValues(alpha: 0.1),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: AppColors.accentBlue.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: AppColors.accentBlue, size: 26),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.white.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppColors.white.withValues(alpha: 0.5),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String time;

  const _NotificationItem({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.white.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.white.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.white.withValues(alpha: 0.4),
            ),
          ),
        ],
      ),
    );
  }
}
