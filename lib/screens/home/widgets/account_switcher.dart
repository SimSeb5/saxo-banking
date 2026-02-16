import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../../../data/mock_data.dart';

class AccountSwitcher extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final VoidCallback onNewAccount;

  const AccountSwitcher({
    super.key,
    required this.selectedIndex,
    required this.onSelected,
    required this.onNewAccount,
  });

  @override
  Widget build(BuildContext context) {
    // 0 = All, 1..n = accounts, last = +New
    final accounts = MockData.accounts;

    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: accounts.length + 2, // All + accounts + New
        itemBuilder: (context, index) {
          if (index == accounts.length + 1) {
            return _NewAccountPill(onTap: onNewAccount);
          }
          final isSelected = index == selectedIndex;
          final label = index == 0
              ? 'All'
              : '${accounts[index - 1].flagEmoji ?? ''} ${accounts[index - 1].currency}';

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => onSelected(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.accentBlue
                      : AppColors.white.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.accentBlue
                        : AppColors.white.withValues(alpha: 0.15),
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isSelected
                        ? AppColors.white
                        : AppColors.white.withValues(alpha: 0.7),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _NewAccountPill extends StatelessWidget {
  final VoidCallback onTap;

  const _NewAccountPill({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.accentBlue.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.accentBlue.withValues(alpha: 0.3),
          ),
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add, size: 16, color: AppColors.accentBlue),
            const SizedBox(width: 4),
            Text(
              'New',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.accentBlue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
