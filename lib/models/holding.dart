class Holding {
  final String id;
  final String ticker;
  final String name;
  final int quantity;
  final double currentPrice;
  final double averagePrice;
  final String currency;
  final double changePercent;

  const Holding({
    required this.id,
    required this.ticker,
    required this.name,
    required this.quantity,
    required this.currentPrice,
    required this.averagePrice,
    required this.currency,
    required this.changePercent,
  });

  double get currentValue => quantity * currentPrice;
  double get costBasis => quantity * averagePrice;
  double get profitLoss => currentValue - costBasis;
  double get profitLossPercent => ((currentValue - costBasis) / costBasis) * 100;
}

class WatchlistItem {
  final String ticker;
  final String name;
  final double price;
  final double changePercent;
  final String currency;

  const WatchlistItem({
    required this.ticker,
    required this.name,
    required this.price,
    required this.changePercent,
    required this.currency,
  });
}
