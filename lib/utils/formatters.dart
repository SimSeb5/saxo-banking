import 'package:intl/intl.dart';

class Formatters {
  static final _currencyFormatters = <String, NumberFormat>{};

  static String formatCurrency(double amount, String currency) {
    _currencyFormatters[currency] ??= NumberFormat.currency(
      symbol: _getCurrencySymbol(currency),
      decimalDigits: 2,
    );
    return _currencyFormatters[currency]!.format(amount);
  }

  static String formatCurrencyCompact(double amount, String currency) {
    if (amount.abs() >= 1000000) {
      return '${_getCurrencySymbol(currency)}${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (amount.abs() >= 1000) {
      return '${_getCurrencySymbol(currency)}${(amount / 1000).toStringAsFixed(0)}K';
    }
    return formatCurrency(amount, currency);
  }

  static String _getCurrencySymbol(String currency) {
    switch (currency.toUpperCase()) {
      case 'CHF':
        return 'CHF ';
      case 'USD':
        return '\$ ';
      case 'EUR':
        return '\u20AC ';
      case 'GBP':
        return '\u00A3 ';
      default:
        return '$currency ';
    }
  }

  static String formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return '${difference.inMinutes}m ago';
      }
      return '${difference.inHours}h ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return DateFormat('EEEE').format(date);
    } else {
      return DateFormat('MMM d').format(date);
    }
  }

  static String formatPercent(double percent, {bool showSign = true}) {
    final sign = showSign && percent > 0 ? '+' : '';
    return '$sign${percent.toStringAsFixed(2)}%';
  }

  static String formatAmount(double amount, {bool showSign = true}) {
    final formatter = NumberFormat('#,##0.00');
    final sign = showSign && amount > 0 ? '+' : '';
    return '$sign${formatter.format(amount)}';
  }

  static String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good morning';
    } else if (hour < 17) {
      return 'Good afternoon';
    } else {
      return 'Good evening';
    }
  }
}
