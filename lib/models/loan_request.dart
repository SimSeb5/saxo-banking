enum LoanStatus {
  draft,
  submitted,
  underReview,
  pendingCompliance,
  approved,
  rejected,
  disbursed,
}

class LoanRequest {
  final String id;
  final String referenceNumber;
  final double amount;
  final String currency;
  final String purpose;
  final DateTime submittedDate;
  final LoanStatus status;
  final double ltv;
  final double collateralValue;

  const LoanRequest({
    required this.id,
    required this.referenceNumber,
    required this.amount,
    required this.currency,
    required this.purpose,
    required this.submittedDate,
    required this.status,
    required this.ltv,
    required this.collateralValue,
  });

  String get statusLabel {
    switch (status) {
      case LoanStatus.draft:
        return 'Draft';
      case LoanStatus.submitted:
        return 'Submitted';
      case LoanStatus.underReview:
        return 'Under Review';
      case LoanStatus.pendingCompliance:
        return 'Pending Compliance';
      case LoanStatus.approved:
        return 'Approved';
      case LoanStatus.rejected:
        return 'Rejected';
      case LoanStatus.disbursed:
        return 'Disbursed';
    }
  }
}

class ActiveLoan {
  final String id;
  final String name;
  final double facilityAmount;
  final double drawnAmount;
  final double rate;
  final double ltv;
  final double collateralValue;
  final DateTime nextReview;

  const ActiveLoan({
    required this.id,
    required this.name,
    required this.facilityAmount,
    required this.drawnAmount,
    required this.rate,
    required this.ltv,
    required this.collateralValue,
    required this.nextReview,
  });

  double get utilizationPercent => (drawnAmount / facilityAmount) * 100;
}
