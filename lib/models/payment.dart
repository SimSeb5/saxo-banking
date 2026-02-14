enum PaymentStatus { pending, completed, failed, scheduled }

enum PaymentDirection { sent, received }

class Payment {
  final String id;
  final String recipientName;
  final String recipientAccount;
  final double amount;
  final String currency;
  final DateTime date;
  final PaymentStatus status;
  final PaymentDirection direction;
  final String? reference;

  const Payment({
    required this.id,
    required this.recipientName,
    required this.recipientAccount,
    required this.amount,
    required this.currency,
    required this.date,
    required this.status,
    required this.direction,
    this.reference,
  });
}

class Contact {
  final String id;
  final String name;
  final String initials;
  final String accountPreview;
  final bool isInternal;

  const Contact({
    required this.id,
    required this.name,
    required this.initials,
    required this.accountPreview,
    required this.isInternal,
  });
}
