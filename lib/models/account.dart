class Account {
  final String id;
  final String name;
  final String currency;
  final double balance;
  final String? flagEmoji;

  const Account({
    required this.id,
    required this.name,
    required this.currency,
    required this.balance,
    this.flagEmoji,
  });
}
