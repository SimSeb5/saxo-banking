import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'dart:ui';
import '../../../../theme/app_theme.dart';
import '../../../../data/mock_data.dart';
import '../../../../utils/formatters.dart';

class CollateralStep extends StatelessWidget {
  final double loanAmount;
  final Set<String> selectedCollateral;
  final ValueChanged<Set<String>> onCollateralChanged;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const CollateralStep({
    super.key,
    required this.loanAmount,
    required this.selectedCollateral,
    required this.onCollateralChanged,
    required this.onNext,
    required this.onBack,
  });

  double get _totalCollateralValue {
    return MockData.holdings
        .where((h) => selectedCollateral.contains(h.id))
        .fold(0.0, (sum, h) => sum + h.currentValue);
  }

  double get _lendingValue {
    // Apply average 35% haircut
    return _totalCollateralValue * 0.65;
  }

  double get _ltvRatio {
    if (_lendingValue == 0) return 0;
    return (loanAmount / _totalCollateralValue) * 100;
  }

  bool get _isLtvValid => _ltvRatio > 0 && _ltvRatio <= 65;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "What's backing this loan?",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: AppColors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Select assets from your portfolio as collateral.',
            style: TextStyle(
              fontSize: 15,
              color: AppColors.white.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 24),
          // LTV Calculator
          _buildLtvCalculator(),
          const SizedBox(height: 24),
          // Holdings list
          Text(
            'Select from your portfolio',
            style: TextStyle(
              fontSize: 16,
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
                  itemCount: MockData.holdings.length,
                  separatorBuilder: (context, index) => Divider(
                    height: 1,
                    color: AppColors.white.withValues(alpha: 0.1),
                  ),
                  itemBuilder: (context, index) {
                    final holding = MockData.holdings[index];
                    final isSelected = selectedCollateral.contains(holding.id);
                    return InkWell(
                      onTap: () {
                        final newSelection = Set<String>.from(selectedCollateral);
                        if (isSelected) {
                          newSelection.remove(holding.id);
                        } else {
                          newSelection.add(holding.id);
                        }
                        onCollateralChanged(newSelection);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.accentBlue
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.accentBlue
                                      : AppColors.white.withValues(alpha: 0.3),
                                  width: 2,
                                ),
                              ),
                              child: isSelected
                                  ? Icon(
                                      Icons.check,
                                      size: 16,
                                      color: AppColors.white,
                                    )
                                  : null,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    holding.name,
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.white,
                                    ),
                                  ),
                                  Text(
                                    '${holding.quantity} shares • ${holding.ticker}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.white.withValues(alpha: 0.5),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              Formatters.formatCurrency(
                                  holding.currentValue, holding.currency),
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: AppColors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Haircut info
          _buildHaircutInfo(),
          const SizedBox(height: 24),
          // AI Tip
          if (selectedCollateral.isNotEmpty) _buildAiTip(),
          const SizedBox(height: 24),
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
                  onPressed: _isLtvValid ? onNext : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accentBlue,
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    disabledBackgroundColor: AppColors.white.withValues(alpha: 0.1),
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

  Widget _buildLtvCalculator() {
    return ClipRRect(
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
            children: [
              _CalcRow(
                label: 'Collateral Value:',
                value: Formatters.formatCurrency(_totalCollateralValue, 'CHF'),
              ),
              const SizedBox(height: 8),
              _CalcRow(
                label: 'Haircut Applied:',
                value: '-35%',
                valueColor: AppColors.danger,
              ),
              const SizedBox(height: 8),
              _CalcRow(
                label: 'Lending Value:',
                value: Formatters.formatCurrency(_lendingValue, 'CHF'),
              ),
              const SizedBox(height: 8),
              _CalcRow(
                label: 'Requested Amount:',
                value: Formatters.formatCurrency(loanAmount, 'CHF'),
                isBold: true,
              ),
              const SizedBox(height: 16),
              Divider(color: AppColors.white.withValues(alpha: 0.1)),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'LTV Ratio:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.white,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        '${_ltvRatio.toStringAsFixed(1)}%',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: _isLtvValid ? AppColors.success : AppColors.danger,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        _isLtvValid ? Icons.check_circle : Icons.warning,
                        color: _isLtvValid ? AppColors.success : AppColors.danger,
                        size: 24,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              LinearPercentIndicator(
                lineHeight: 8,
                percent: (_ltvRatio / 100).clamp(0, 1),
                backgroundColor: AppColors.white.withValues(alpha: 0.1),
                progressColor: _getLtvColor(),
                barRadius: const Radius.circular(4),
                padding: EdgeInsets.zero,
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Status: ${_isLtvValid ? 'Within limits' : 'Select more collateral'}',
                    style: TextStyle(
                      fontSize: 12,
                      color: _isLtvValid ? AppColors.success : AppColors.danger,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'Max: ${Formatters.formatCurrency(_lendingValue, 'CHF')}',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.white.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getLtvColor() {
    if (_ltvRatio <= 50) return AppColors.success;
    if (_ltvRatio <= 65) return AppColors.warning;
    return AppColors.danger;
  }

  Widget _buildHaircutInfo() {
    return Theme(
      data: ThemeData.dark().copyWith(
        dividerColor: Colors.transparent,
      ),
      child: ExpansionTile(
        title: Text(
          'Haircut Rates by Asset Class',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.white,
          ),
        ),
        iconColor: AppColors.white.withValues(alpha: 0.6),
        collapsedIconColor: AppColors.white.withValues(alpha: 0.6),
        tilePadding: EdgeInsets.zero,
        children: MockData.haircutRates.entries.map((entry) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  entry.key,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.white.withValues(alpha: 0.7),
                  ),
                ),
                Text(
                  '${entry.value.toStringAsFixed(0)}%',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildAiTip() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.accentBlue.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.accentBlue.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.lightbulb_outline,
            color: AppColors.accentBlue,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Your portfolio mix qualifies for preferential haircuts. Consider including government bonds to further lower your LTV.',
              style: TextStyle(
                fontSize: 13,
                color: AppColors.white.withValues(alpha: 0.8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CalcRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final bool isBold;

  const _CalcRow({
    required this.label,
    required this.value,
    this.valueColor,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
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
            fontWeight: isBold ? FontWeight.w600 : FontWeight.w500,
            color: valueColor ?? AppColors.white,
          ),
        ),
      ],
    );
  }
}
