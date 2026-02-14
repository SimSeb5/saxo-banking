import 'package:flutter/material.dart';
import 'dart:ui';
import '../../../../theme/app_theme.dart';
import '../../../../utils/formatters.dart';

class LoanParamsStep extends StatelessWidget {
  final double amount;
  final String currency;
  final String purpose;
  final String termType;
  final String drawdownPref;
  final ValueChanged<double> onAmountChanged;
  final ValueChanged<String> onCurrencyChanged;
  final ValueChanged<String> onPurposeChanged;
  final ValueChanged<String> onTermTypeChanged;
  final ValueChanged<String> onDrawdownPrefChanged;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const LoanParamsStep({
    super.key,
    required this.amount,
    required this.currency,
    required this.purpose,
    required this.termType,
    required this.drawdownPref,
    required this.onAmountChanged,
    required this.onCurrencyChanged,
    required this.onPurposeChanged,
    required this.onTermTypeChanged,
    required this.onDrawdownPrefChanged,
    required this.onNext,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'How much do you need?',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: AppColors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Set your desired loan amount and preferences.',
            style: TextStyle(
              fontSize: 15,
              color: AppColors.white.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 32),
          // Amount display
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.accentBlue.withValues(alpha: 0.3),
                      AppColors.accentBlue.withValues(alpha: 0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.accentBlue.withValues(alpha: 0.3),
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      'Loan Amount',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.white.withValues(alpha: 0.7),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      Formatters.formatCurrency(amount, currency),
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w700,
                        color: AppColors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Quick amount buttons
          Row(
            children: [
              _QuickAmountButton(
                label: '100K',
                isSelected: amount == 100000,
                onTap: () => onAmountChanged(100000),
              ),
              const SizedBox(width: 8),
              _QuickAmountButton(
                label: '250K',
                isSelected: amount == 250000,
                onTap: () => onAmountChanged(250000),
              ),
              const SizedBox(width: 8),
              _QuickAmountButton(
                label: '500K',
                isSelected: amount == 500000,
                onTap: () => onAmountChanged(500000),
              ),
              const SizedBox(width: 8),
              _QuickAmountButton(
                label: '1M',
                isSelected: amount == 1000000,
                onTap: () => onAmountChanged(1000000),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Currency selector
          _DropdownField(
            label: 'Currency',
            value: currency,
            options: ['CHF', 'USD', 'EUR', 'GBP'],
            onChanged: onCurrencyChanged,
          ),
          const SizedBox(height: 16),
          // Purpose selector
          _DropdownField(
            label: 'Loan Purpose',
            value: purpose,
            options: [
              'Portfolio leverage',
              'Real estate bridge',
              'Tax planning',
              'Business investment',
              'Personal liquidity',
              'Other',
            ],
            onChanged: onPurposeChanged,
          ),
          const SizedBox(height: 16),
          // Term type
          _DropdownField(
            label: 'Term Preference',
            value: termType,
            options: [
              'Open-ended (revolving)',
              'Fixed term - 1 year',
              'Fixed term - 2 years',
              'Fixed term - 3 years',
            ],
            onChanged: onTermTypeChanged,
          ),
          const SizedBox(height: 16),
          // Drawdown preference
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.white.withValues(alpha: 0.1),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Drawdown Preference',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.white.withValues(alpha: 0.5),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _DrawdownOption(
                          label: 'Full amount',
                          isSelected: drawdownPref == 'Full amount',
                          onTap: () => onDrawdownPrefChanged('Full amount'),
                        ),
                        const SizedBox(width: 12),
                        _DrawdownOption(
                          label: 'Partial as needed',
                          isSelected: drawdownPref == 'Partial as needed',
                          onTap: () => onDrawdownPrefChanged('Partial as needed'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),
          // Navigation buttons
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: OutlinedButton(
                      onPressed: onBack,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(
                          color: AppColors.white.withValues(alpha: 0.2),
                        ),
                        backgroundColor: AppColors.white.withValues(alpha: 0.05),
                      ),
                      child: Text(
                        'Back',
                        style: TextStyle(color: AppColors.white),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: onNext,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accentBlue,
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Continue',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
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

class _QuickAmountButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _QuickAmountButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.accentBlue
                : AppColors.white.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected
                  ? AppColors.accentBlue
                  : AppColors.white.withValues(alpha: 0.1),
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DropdownField extends StatelessWidget {
  final String label;
  final String value;
  final List<String> options;
  final ValueChanged<String> onChanged;

  const _DropdownField({
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.white.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.white.withValues(alpha: 0.1),
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              dropdownColor: const Color(0xFF1A3A5C),
              icon: Icon(
                Icons.keyboard_arrow_down,
                color: AppColors.white.withValues(alpha: 0.4),
              ),
              items: options.map((option) {
                return DropdownMenuItem(
                  value: option,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (option == value)
                        Text(
                          label,
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.white.withValues(alpha: 0.5),
                          ),
                        ),
                      Text(
                        option,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: AppColors.white,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (v) => v != null ? onChanged(v) : null,
            ),
          ),
        ),
      ),
    );
  }
}

class _DrawdownOption extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _DrawdownOption({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.accentBlue.withValues(alpha: 0.2)
                : AppColors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected
                  ? AppColors.accentBlue
                  : AppColors.white.withValues(alpha: 0.1),
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected
                    ? AppColors.white
                    : AppColors.white.withValues(alpha: 0.6),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
