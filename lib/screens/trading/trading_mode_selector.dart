import 'package:flutter/material.dart';
import 'dart:ui';
import '../../theme/app_theme.dart';

enum TradingMode { investor, traderGo, traderPro }

class TradingModeSelector extends StatelessWidget {
  final TradingMode selectedMode;
  final ValueChanged<TradingMode> onModeChanged;

  const TradingModeSelector({
    super.key,
    required this.selectedMode,
    required this.onModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.white.withValues(alpha: 0.1),
              ),
            ),
            child: Row(
              children: [
                _ModeButton(
                  label: 'SaxoInvestor',
                  isSelected: selectedMode == TradingMode.investor,
                  onTap: () => onModeChanged(TradingMode.investor),
                ),
                _ModeButton(
                  label: 'TraderGO',
                  isSelected: selectedMode == TradingMode.traderGo,
                  onTap: () => onModeChanged(TradingMode.traderGo),
                ),
                _ModeButton(
                  label: 'TraderPRO',
                  isSelected: selectedMode == TradingMode.traderPro,
                  onTap: () => onModeChanged(TradingMode.traderPro),
                  isPro: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ModeButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isPro;

  const _ModeButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.isPro = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.accentBlue.withValues(alpha: 0.3)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: isSelected
                ? Border.all(
                    color: AppColors.accentBlue.withValues(alpha: 0.5),
                  )
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected
                      ? AppColors.white
                      : AppColors.white.withValues(alpha: 0.6),
                ),
              ),
              if (isPro) ...[
                const SizedBox(width: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.accentGold,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'PRO',
                    style: TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.w700,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
