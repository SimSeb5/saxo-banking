import 'package:flutter/material.dart';

enum TransactionType { debit, credit, trade }

enum TransactionCategory {
  shopping,
  transfer,
  trade,
  subscription,
  food,
  travel,
  salary,
  dividend,
}

class Transaction {
  final String id;
  final String title;
  final String subtitle;
  final double amount;
  final String currency;
  final DateTime date;
  final TransactionType type;
  final TransactionCategory category;

  const Transaction({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.currency,
    required this.date,
    required this.type,
    required this.category,
  });

  IconData get categoryIcon {
    switch (category) {
      case TransactionCategory.shopping:
        return Icons.shopping_bag_outlined;
      case TransactionCategory.transfer:
        return Icons.swap_horiz;
      case TransactionCategory.trade:
        return Icons.candlestick_chart_outlined;
      case TransactionCategory.subscription:
        return Icons.repeat;
      case TransactionCategory.food:
        return Icons.restaurant_outlined;
      case TransactionCategory.travel:
        return Icons.flight_outlined;
      case TransactionCategory.salary:
        return Icons.account_balance_outlined;
      case TransactionCategory.dividend:
        return Icons.payments_outlined;
    }
  }
}
