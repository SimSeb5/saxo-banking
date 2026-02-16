import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../../../data/mock_data.dart';
import '../../../utils/formatters.dart';

class BreakdownSection extends StatelessWidget {
  final int selectedAccountIndex;
  final Function(int)? onNavigateToTab;
  final ValueChanged<int>? onSwitchAccount;
  final VoidCallback? onDeleteAccount;

  const BreakdownSection({
    super.key,
    required this.selectedAccountIndex,
    this.onNavigateToTab,
    this.onSwitchAccount,
    this.onDeleteAccount,
  });

  @override
  Widget build(BuildContext context) {
    // Compute per-account breakdown
    final currency = MockData.currencyForIndex(selectedAccountIndex);
    double cashValue;
    double investedValue;
    double loansValue;

    if (selectedAccountIndex == 0) {
      // All accounts — global totals
      cashValue = MockData.cashBalance;
      investedValue = MockData.portfolioValue;
      loansValue = MockData.activeLoan.drawnAmount;
    } else {
      // Individual account — specific allocations
      cashValue = MockData.cashForAccountIndex(selectedAccountIndex);
      investedValue = MockData.investedForAccountIndex(selectedAccountIndex);
      loansValue = MockData.loansForAccountIndex(selectedAccountIndex);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.white.withValues(alpha: 0.1),
          ),
        ),
        child: Column(
          children: [
            _BreakdownRow(
              icon: Icons.account_balance_wallet_outlined,
              label: 'Cash',
              value: Formatters.formatCurrencyCompact(cashValue, currency),
              onTap: () {},
            ),
            Divider(
              height: 1,
              color: AppColors.white.withValues(alpha: 0.08),
              indent: 52,
            ),
            _BreakdownRow(
              icon: Icons.trending_up,
              label: 'Invested',
              value: Formatters.formatCurrencyCompact(investedValue, currency),
              onTap: () => onNavigateToTab?.call(1),
            ),
            Divider(
              height: 1,
              color: AppColors.white.withValues(alpha: 0.08),
              indent: 52,
            ),
            _BreakdownRow(
              icon: Icons.account_balance_outlined,
              label: 'Loans',
              value: Formatters.formatCurrencyCompact(loansValue, currency),
              onTap: () => onNavigateToTab?.call(3),
            ),
          ],
        ),
      ),
    );
  }
}

class _BreakdownRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;

  const _BreakdownRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: AppColors.white.withValues(alpha: 0.5),
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: AppColors.white,
              ),
            ),
            const Spacer(),
            Text(
              value,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.white.withValues(alpha: 0.85),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
