enum AccountType { current, savings }

class Account {
  final String id;
  final String name;
  final String currency;
  final double balance;
  final String? flagEmoji;
  final AccountType accountType;
  // Savings-specific fields
  final double? interestRate;
  final String? term; // e.g. "Flexible", "6 Months", "1 Year"
  final String? interestPayout; // e.g. "Monthly", "Quarterly", "Annually"

  const Account({
    required this.id,
    required this.name,
    required this.currency,
    required this.balance,
    this.flagEmoji,
    this.accountType = AccountType.current,
    this.interestRate,
    this.term,
    this.interestPayout,
  });

  Account copyWith({double? balance}) {
    return Account(
      id: id,
      name: name,
      currency: currency,
      balance: balance ?? this.balance,
      flagEmoji: flagEmoji,
      accountType: accountType,
      interestRate: interestRate,
      term: term,
      interestPayout: interestPayout,
    );
  }
}
