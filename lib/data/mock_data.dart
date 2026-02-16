import '../models/account.dart';
import '../models/transaction.dart';
import '../models/holding.dart';
import '../models/payment.dart';
import '../models/loan_request.dart';
import '../models/user_profile.dart';

class MockData {
  // User Profile
  static const userProfile = UserProfile(
    id: 'USR001',
    firstName: 'Simon',
    lastName: 'Safra',
    email: 'simon.safra@jsafrasarasin.com',
    phone: '+41 79 123 45 67',
    clientId: 'JSS-2024-78542',
    segment: 'UHNW',
    relationshipManager: 'Marc Dubois',
    bookingCenter: 'Geneva',
  );

  // Accounts (mutable so new accounts can be added)
  static final List<Account> accounts = [
    const Account(
      id: 'ACC001',
      name: 'CHF Account',
      currency: 'CHF',
      balance: 1250000.00,
      flagEmoji: '🇨🇭',
    ),
    const Account(
      id: 'ACC002',
      name: 'USD Account',
      currency: 'USD',
      balance: 892000.00,
      flagEmoji: '🇺🇸',
    ),
    const Account(
      id: 'ACC003',
      name: 'EUR Account',
      currency: 'EUR',
      balance: 315000.00,
      flagEmoji: '🇪🇺',
    ),
    const Account(
      id: 'ACC004',
      name: 'GBP Account',
      currency: 'GBP',
      balance: 180350.00,
      flagEmoji: '🇬🇧',
    ),
  ];

  // Total balance in CHF (computed from accounts + portfolio + loans)
  static double get totalBalance =>
      cashBalance + portfolioValue + activeLoan.drawnAmount;

  // Cash = sum of all account balances
  static double get cashBalance =>
      accounts.fold(0.0, (sum, a) => sum + a.balance);

  static const double dailyChange = 12450.00;
  static const double dailyChangePercent = 0.44;

  // Flag emoji for a currency code
  static String? flagForCurrency(String currency) {
    switch (currency.toUpperCase()) {
      case 'CHF': return '🇨🇭';
      case 'USD': return '🇺🇸';
      case 'EUR': return '🇪🇺';
      case 'GBP': return '🇬🇧';
      case 'JPY': return '🇯🇵';
      case 'CAD': return '🇨🇦';
      case 'AUD': return '🇦🇺';
      case 'SEK': return '🇸🇪';
      case 'NOK': return '🇳🇴';
      case 'DKK': return '🇩🇰';
      case 'SGD': return '🇸🇬';
      case 'HKD': return '🇭🇰';
      default: return null;
    }
  }

  // Portfolio summary
  static const double portfolioValue = 1890000.00;
  static const double portfolioTodayPercent = 0.8;
  static const double portfolio1MPercent = 3.2;
  static const double portfolioYTDPercent = 7.1;

  // Holdings
  static final holdings = [
    Holding(
      id: 'HLD001',
      ticker: 'BRK.B',
      name: 'Berkshire Hathaway',
      quantity: 50,
      currentPrice: 465.20,
      averagePrice: 414.30,
      currency: 'USD',
      changePercent: 12.3,
    ),
    Holding(
      id: 'HLD002',
      ticker: 'IVV',
      name: 'iShares S&P 500 ETF',
      quantity: 200,
      currentPrice: 585.40,
      averagePrice: 538.50,
      currency: 'USD',
      changePercent: 8.7,
    ),
    Holding(
      id: 'HLD003',
      ticker: 'IBIT',
      name: 'Bitcoin ETF',
      quantity: 100,
      currentPrice: 58.30,
      averagePrice: 47.00,
      currency: 'USD',
      changePercent: 24.1,
    ),
    Holding(
      id: 'HLD004',
      ticker: 'NESN',
      name: 'Nestlé',
      quantity: 150,
      currentPrice: 98.50,
      averagePrice: 100.60,
      currency: 'CHF',
      changePercent: -2.1,
    ),
    Holding(
      id: 'HLD005',
      ticker: 'NOVN',
      name: 'Novartis',
      quantity: 100,
      currentPrice: 92.80,
      averagePrice: 88.00,
      currency: 'CHF',
      changePercent: 5.4,
    ),
    Holding(
      id: 'HLD006',
      ticker: 'GLD',
      name: 'Gold ETF',
      quantity: 80,
      currentPrice: 198.50,
      averagePrice: 172.30,
      currency: 'USD',
      changePercent: 15.2,
    ),
  ];

  // Watchlist
  static const watchlist = [
    WatchlistItem(
      ticker: 'AAPL',
      name: 'Apple',
      price: 245.30,
      changePercent: 1.2,
      currency: 'USD',
    ),
    WatchlistItem(
      ticker: 'NVDA',
      name: 'NVIDIA',
      price: 142.80,
      changePercent: 3.5,
      currency: 'USD',
    ),
    WatchlistItem(
      ticker: 'EUR/USD',
      name: 'Euro / US Dollar',
      price: 1.0842,
      changePercent: -0.15,
      currency: '',
    ),
    WatchlistItem(
      ticker: 'XAU',
      name: 'Gold',
      price: 2915.40,
      changePercent: 0.8,
      currency: 'USD',
    ),
    WatchlistItem(
      ticker: 'BTC',
      name: 'Bitcoin',
      price: 98450.00,
      changePercent: 2.1,
      currency: 'USD',
    ),
    WatchlistItem(
      ticker: 'SREN',
      name: 'Swiss Re',
      price: 128.90,
      changePercent: 0.5,
      currency: 'CHF',
    ),
  ];

  // Recent Transactions
  static final recentTransactions = [
    Transaction(
      id: 'TXN001',
      title: 'Apple Store',
      subtitle: 'Electronics',
      amount: -1299.00,
      currency: 'CHF',
      date: DateTime.now().subtract(const Duration(hours: 2)),
      type: TransactionType.debit,
      category: TransactionCategory.shopping,
    ),
    Transaction(
      id: 'TXN002',
      title: 'Dividend - Nestlé',
      subtitle: 'Quarterly dividend',
      amount: 2850.00,
      currency: 'CHF',
      date: DateTime.now().subtract(const Duration(days: 1)),
      type: TransactionType.credit,
      category: TransactionCategory.dividend,
    ),
    Transaction(
      id: 'TXN003',
      title: 'Trade - NVDA',
      subtitle: 'Bought 25 shares',
      amount: -3570.00,
      currency: 'USD',
      date: DateTime.now().subtract(const Duration(days: 1)),
      type: TransactionType.trade,
      category: TransactionCategory.trade,
    ),
    Transaction(
      id: 'TXN004',
      title: 'Transfer to Marc',
      subtitle: 'Internal transfer',
      amount: -15000.00,
      currency: 'CHF',
      date: DateTime.now().subtract(const Duration(days: 2)),
      type: TransactionType.debit,
      category: TransactionCategory.transfer,
    ),
    Transaction(
      id: 'TXN005',
      title: 'Restaurant du Lac',
      subtitle: 'Dining',
      amount: -385.00,
      currency: 'CHF',
      date: DateTime.now().subtract(const Duration(days: 3)),
      type: TransactionType.debit,
      category: TransactionCategory.food,
    ),
    Transaction(
      id: 'TXN006',
      title: 'Salary Credit',
      subtitle: 'Monthly salary',
      amount: 18500.00,
      currency: 'CHF',
      date: DateTime.now().subtract(const Duration(days: 4)),
      type: TransactionType.credit,
      category: TransactionCategory.salary,
    ),
    Transaction(
      id: 'TXN007',
      title: 'Trade - AAPL',
      subtitle: 'Sold 15 shares',
      amount: 4125.00,
      currency: 'USD',
      date: DateTime.now().subtract(const Duration(days: 4)),
      type: TransactionType.credit,
      category: TransactionCategory.trade,
    ),
    Transaction(
      id: 'TXN008',
      title: 'Zurich Insurance',
      subtitle: 'Premium payment',
      amount: -750.00,
      currency: 'CHF',
      date: DateTime.now().subtract(const Duration(days: 5)),
      type: TransactionType.debit,
      category: TransactionCategory.subscription,
    ),
    Transaction(
      id: 'TXN009',
      title: 'Amazon',
      subtitle: 'Online shopping',
      amount: -219.90,
      currency: 'USD',
      date: DateTime.now().subtract(const Duration(days: 5)),
      type: TransactionType.debit,
      category: TransactionCategory.shopping,
    ),
    Transaction(
      id: 'TXN010',
      title: 'Swisscom',
      subtitle: 'Mobile subscription',
      amount: -89.00,
      currency: 'CHF',
      date: DateTime.now().subtract(const Duration(days: 6)),
      type: TransactionType.debit,
      category: TransactionCategory.subscription,
    ),
    Transaction(
      id: 'TXN011',
      title: 'Interest Credit',
      subtitle: 'Savings interest',
      amount: 1250.00,
      currency: 'CHF',
      date: DateTime.now().subtract(const Duration(days: 7)),
      type: TransactionType.credit,
      category: TransactionCategory.dividend,
    ),
    Transaction(
      id: 'TXN012',
      title: 'Uber',
      subtitle: 'Transportation',
      amount: -42.50,
      currency: 'CHF',
      date: DateTime.now().subtract(const Duration(days: 7)),
      type: TransactionType.debit,
      category: TransactionCategory.travel,
    ),
  ];

  // Recent Contacts
  static const contacts = [
    Contact(
      id: 'CON001',
      name: 'Marc Dubois',
      initials: 'MD',
      accountPreview: 'CH93 0076 2011 ****',
      isInternal: true,
    ),
    Contact(
      id: 'CON002',
      name: 'Sophie Laurent',
      initials: 'SL',
      accountPreview: 'CH12 0483 5012 ****',
      isInternal: true,
    ),
    Contact(
      id: 'CON003',
      name: 'James Wilson',
      initials: 'JW',
      accountPreview: 'GB29 NWBK 6016 ****',
      isInternal: false,
    ),
    Contact(
      id: 'CON004',
      name: 'Elena Fischer',
      initials: 'EF',
      accountPreview: 'DE89 3704 0044 ****',
      isInternal: false,
    ),
    Contact(
      id: 'CON005',
      name: 'Pierre Martin',
      initials: 'PM',
      accountPreview: 'FR76 3000 6000 ****',
      isInternal: false,
    ),
  ];

  // Active Loan
  static final activeLoan = ActiveLoan(
    id: 'LOAN001',
    name: 'Lombard Facility',
    facilityAmount: 500000.00,
    drawnAmount: 300000.00,
    rate: 1.40, // SARON + 0.95%
    ltv: 52.0,
    collateralValue: 960000.00,
    nextReview: DateTime(2026, 3, 15),
  );

  // Loan Requests
  static final loanRequests = [
    LoanRequest(
      id: 'REQ001',
      referenceNumber: 'LMB-2026-00138',
      amount: 250000.00,
      currency: 'CHF',
      purpose: 'Portfolio leverage',
      submittedDate: DateTime.now().subtract(const Duration(days: 5)),
      status: LoanStatus.underReview,
      ltv: 45.0,
      collateralValue: 550000.00,
    ),
  ];

  // Chart data points (mock sparkline for portfolio)
  static const portfolioChartData = [
    1820000.0, 1835000.0, 1828000.0, 1845000.0, 1852000.0,
    1848000.0, 1862000.0, 1855000.0, 1870000.0, 1865000.0,
    1878000.0, 1882000.0, 1875000.0, 1890000.0,
  ];

  // Asset allocation for donut chart
  static const assetAllocation = {
    'Equities': 45.0,
    'Bonds': 30.0,
    'ETFs': 20.0,
    'Cash': 5.0,
  };

  // Haircut rates for collateral
  static const haircutRates = {
    'Listed Equities': 35.0,
    'Government Bonds': 10.0,
    'Corporate Bonds (IG)': 20.0,
    'ETFs': 25.0,
    'Crypto ETFs': 55.0,
    'Cash': 5.0,
    'Precious Metals': 30.0,
  };

  // Mock FX rates (all relative to CHF)
  static const _fxRates = <String, double>{
    'CHF': 1.0,
    'USD': 1.12,
    'EUR': 0.93,
    'GBP': 0.79,
    'JPY': 168.50,
    'CAD': 1.52,
    'AUD': 1.72,
    'SGD': 1.50,
  };

  static double getFxRate(String from, String to) {
    if (from == to) return 1.0;
    final fromRate = _fxRates[from] ?? 1.0;
    final toRate = _fxRates[to] ?? 1.0;
    return toRate / fromRate;
  }

  // Per-account investment allocations
  static const _accountInvestments = <String, double>{
    'ACC001': 1050000.0, // CHF: equities + bonds
    'ACC002': 840000.0,  // USD: equities + ETFs
    // EUR: no investments
    // GBP: no investments
  };

  // Per-account loan allocations
  static const _accountLoans = <String, double>{
    'ACC001': 300000.0, // CHF: lombard facility
    // USD: no loans
    // EUR: no loans
    // GBP: no loans
  };

  // IDs of pre-existing accounts (for transaction matching)
  static const _originalAccountIds = {'ACC001', 'ACC002', 'ACC003', 'ACC004'};

  static double investedForAccountIndex(int index) {
    if (index == 0) return portfolioValue;
    final accountId = accounts[index - 1].id;
    return _accountInvestments[accountId] ?? 0.0;
  }

  static double loansForAccountIndex(int index) {
    if (index == 0) return activeLoan.drawnAmount;
    final accountId = accounts[index - 1].id;
    return _accountLoans[accountId] ?? 0.0;
  }

  static double cashForAccountIndex(int index) {
    if (index == 0) return cashBalance;
    return accounts[index - 1].balance;
  }

  // --- Account switcher helpers ---
  // index 0 = "All Accounts", index 1+ = individual accounts

  static double balanceForIndex(int index) {
    if (index == 0) return totalBalance;
    return accounts[index - 1].balance +
        investedForAccountIndex(index) +
        loansForAccountIndex(index);
  }

  static String currencyForIndex(int index) {
    if (index == 0) return 'CHF';
    return accounts[index - 1].currency;
  }

  static String nameForIndex(int index) {
    if (index == 0) return 'All Accounts';
    return accounts[index - 1].name;
  }

  static List<Transaction> transactionsForIndex(int index) {
    if (index == 0) {
      // On "All" view, hide the credit side of internal transfers to avoid duplicates
      return recentTransactions
          .where((t) => !t.id.endsWith('_credit'))
          .toList();
    }
    final account = accounts[index - 1];
    // New accounts have no transaction history
    if (!_originalAccountIds.contains(account.id)) return [];
    return recentTransactions
        .where((t) => t.currency == account.currency)
        .toList();
  }
}
