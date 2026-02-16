import 'dart:math';
import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../../../data/mock_data.dart';
import '../../../models/account.dart';
import '../../../models/transaction.dart';
import '../../../utils/formatters.dart';

class BalanceSection extends StatelessWidget {
  final int selectedAccountIndex;
  final Function(int)? onNavigateToTab;
  final VoidCallback? onRefresh;

  const BalanceSection({
    super.key,
    required this.selectedAccountIndex,
    this.onNavigateToTab,
    this.onRefresh,
  });

  void _showAddMoneySheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => Container(
        height: MediaQuery.of(context).size.height * 0.5,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF1A3A5C),
              const Color(0xFF0A1E3D),
            ],
          ),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.white.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Add Money',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.white,
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _AddMoneyOption(
                    icon: Icons.account_balance,
                    title: 'Bank Transfer',
                    subtitle: 'Transfer from your bank account',
                    onTap: () {
                      Navigator.of(context).pop();
                      _showBankTransferDetails(context);
                    },
                  ),
                  const SizedBox(height: 12),
                  _AddMoneyOption(
                    icon: Icons.credit_card,
                    title: 'Debit Card',
                    subtitle: 'Instant deposit with card',
                    onTap: () {
                      Navigator.of(context).pop();
                      _showCardDeposit(context);
                    },
                  ),
                  const SizedBox(height: 12),
                  _AddMoneyOption(
                    icon: Icons.qr_code,
                    title: 'QR Code',
                    subtitle: 'Scan to receive payment',
                    onTap: () {
                      Navigator.of(context).pop();
                      _showQRCode(context);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showBankTransferDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.65,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF1A3A5C),
              const Color(0xFF0A1E3D),
            ],
          ),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.white.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Bank Transfer Details',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Use these details to receive funds',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.white.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _BankDetailRow(label: 'Account Name', value: 'Simon Safra'),
                    const SizedBox(height: 16),
                    _BankDetailRow(label: 'IBAN', value: 'CH93 0076 2011 6238 5295 7'),
                    const SizedBox(height: 16),
                    _BankDetailRow(label: 'BIC/SWIFT', value: 'SAABORBA'),
                    const SizedBox(height: 16),
                    _BankDetailRow(label: 'Bank', value: 'J. Safra Sarasin Ltd'),
                    const SizedBox(height: 16),
                    _BankDetailRow(label: 'Reference', value: 'SS-${MockData.userProfile.clientId}'),
                  ],
                ),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            Icon(Icons.check_circle, color: AppColors.success),
                            const SizedBox(width: 12),
                            const Text('Bank details copied to clipboard'),
                          ],
                        ),
                        backgroundColor: const Color(0xFF1A3A5C),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accentBlue,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.copy, size: 18),
                  label: const Text('Copy Details'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCardDeposit(BuildContext context) {
    final cardNumberController = TextEditingController();
    final expiryController = TextEditingController();
    final cvvController = TextEditingController();
    final amountController = TextEditingController();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF1A3A5C),
              const Color(0xFF0A1E3D),
            ],
          ),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.white.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Card Deposit',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.white,
              ),
            ),
            const SizedBox(height: 32),
            Expanded(
              child: SingleChildScrollView(
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Amount — large centered input
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: TextField(
                        controller: amountController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w700,
                          color: AppColors.white,
                        ),
                        textAlign: TextAlign.center,
                        cursorColor: AppColors.accentBlue,
                        decoration: InputDecoration(
                          hintText: 'CHF 0.00',
                          hintStyle: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.w700,
                            color: AppColors.white.withValues(alpha: 0.12),
                          ),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          filled: false,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _buildQuickChip('100', amountController, (_) {}),
                        const SizedBox(width: 8),
                        _buildQuickChip('500', amountController, (_) {}),
                        const SizedBox(width: 8),
                        _buildQuickChip('1,000', amountController, (_) {}),
                        const SizedBox(width: 8),
                        _buildQuickChip('5,000', amountController, (_) {}),
                      ],
                    ),
                    const SizedBox(height: 32),
                    // Card number
                    Text(
                      'Card Number',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppColors.white.withValues(alpha: 0.5),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: AppColors.white.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.credit_card,
                            size: 20,
                            color: AppColors.white.withValues(alpha: 0.3),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              controller: cardNumberController,
                              keyboardType: TextInputType.number,
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.white,
                                letterSpacing: 2,
                              ),
                              cursorColor: AppColors.accentBlue,
                              decoration: InputDecoration(
                                hintText: '0000 0000 0000 0000',
                                hintStyle: TextStyle(
                                  fontSize: 16,
                                  color: AppColors.white.withValues(alpha: 0.2),
                                  letterSpacing: 2,
                                ),
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                filled: false,
                                contentPadding: const EdgeInsets.symmetric(vertical: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Expiry + CVV row
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Expiry',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.white.withValues(alpha: 0.5),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                decoration: BoxDecoration(
                                  color: AppColors.white.withValues(alpha: 0.06),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: TextField(
                                  controller: expiryController,
                                  keyboardType: TextInputType.datetime,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: AppColors.white,
                                  ),
                                  cursorColor: AppColors.accentBlue,
                                  decoration: InputDecoration(
                                    hintText: 'MM/YY',
                                    hintStyle: TextStyle(
                                      fontSize: 16,
                                      color: AppColors.white.withValues(alpha: 0.2),
                                    ),
                                    border: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    filled: false,
                                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'CVV',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.white.withValues(alpha: 0.5),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                decoration: BoxDecoration(
                                  color: AppColors.white.withValues(alpha: 0.06),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.lock_outline,
                                      size: 16,
                                      color: AppColors.white.withValues(alpha: 0.3),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: TextField(
                                        controller: cvvController,
                                        keyboardType: TextInputType.number,
                                        obscureText: true,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: AppColors.white,
                                        ),
                                        cursorColor: AppColors.accentBlue,
                                        decoration: InputDecoration(
                                          hintText: '***',
                                          hintStyle: TextStyle(
                                            fontSize: 16,
                                            color: AppColors.white.withValues(alpha: 0.2),
                                          ),
                                          border: InputBorder.none,
                                          enabledBorder: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                          filled: false,
                                          contentPadding: const EdgeInsets.symmetric(vertical: 16),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Icon(
                          Icons.shield_outlined,
                          size: 14,
                          color: AppColors.white.withValues(alpha: 0.25),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Secured with 3D Secure',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.white.withValues(alpha: 0.25),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            Icon(Icons.check_circle, color: AppColors.success),
                            const SizedBox(width: 12),
                            const Text('Deposit initiated'),
                          ],
                        ),
                        backgroundColor: const Color(0xFF1A3A5C),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accentBlue,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Deposit'),
                ),
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }

  void _showQRCode(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (qrContext) => Scaffold(
          backgroundColor: const Color(0xFF0A1E3D),
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF0A1E3D),
                  Color(0xFF071428),
                  Color(0xFF0D2847),
                ],
                stops: [0.0, 0.5, 1.0],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  // Top bar with close button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(width: 40),
                        Text(
                          'Receive Payment',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.white,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pop(qrContext),
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: AppColors.white.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.close,
                              size: 20,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  // QR code area
                  Container(
                    width: 260,
                    height: 260,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Center(
                      child: CustomPaint(
                        size: const Size(200, 200),
                        painter: _QRPatternPainter(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'Simon Safra',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: AppColors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'SAXO Banking',
                    style: TextStyle(
                      fontSize: 15,
                      color: AppColors.white.withValues(alpha: 0.5),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'CH93 0076 2011 6238 5295 7',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.accentBlue.withValues(alpha: 0.8),
                      letterSpacing: 0.5,
                    ),
                  ),
                  const Spacer(),
                  // Share button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(qrContext);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Row(
                                children: [
                                  Icon(Icons.check_circle, color: AppColors.success),
                                  const SizedBox(width: 12),
                                  const Text('QR code shared'),
                                ],
                              ),
                              backgroundColor: const Color(0xFF1A3A5C),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accentBlue,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        icon: const Icon(Icons.share_outlined, size: 18),
                        label: const Text('Share QR Code'),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showMoveMoneySheet(BuildContext context) {
    final accounts = MockData.accounts;
    if (accounts.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('You need at least 2 accounts to move money'),
          backgroundColor: const Color(0xFF1A3A5C),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    int fromIdx = selectedAccountIndex > 0 ? selectedAccountIndex - 1 : 0;
    int toIdx = fromIdx == 0 ? 1 : 0;
    final amountController = TextEditingController();
    String? errorText;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) => StatefulBuilder(
        builder: (sheetContext, setSheetState) {
          final fromAccount = accounts[fromIdx];
          final toAccount = accounts[toIdx];
          final isCrossCurrency = fromAccount.currency != toAccount.currency;
          final fxRate = MockData.getFxRate(fromAccount.currency, toAccount.currency);

          // Compute converted amount for display
          final enteredAmount = double.tryParse(
            amountController.text.replaceAll(',', ''),
          );
          final convertedAmount = enteredAmount != null && enteredAmount > 0
              ? enteredAmount * fxRate
              : null;

          return GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: Container(
            height: MediaQuery.of(context).size.height * 0.82,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFF1A3A5C),
                  const Color(0xFF0A1E3D),
                ],
              ),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              children: [
                const SizedBox(height: 12),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.white.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Move Money',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                  ),
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'From',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: AppColors.white.withValues(alpha: 0.5),
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildAccountSelector(
                          account: fromAccount,
                          onTap: () async {
                            final selected = await _showAccountPicker(
                              sheetContext,
                              accounts,
                              exclude: toIdx,
                            );
                            if (selected != null) {
                              setSheetState(() {
                                fromIdx = selected;
                                if (fromIdx == toIdx) {
                                  toIdx = (toIdx + 1) % accounts.length;
                                }
                                errorText = null;
                              });
                            }
                          },
                        ),
                        const SizedBox(height: 10),
                        // Swap button
                        Center(
                          child: GestureDetector(
                            onTap: () => setSheetState(() {
                              final temp = fromIdx;
                              fromIdx = toIdx;
                              toIdx = temp;
                              errorText = null;
                            }),
                            child: Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: AppColors.accentBlue.withValues(alpha: 0.15),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.swap_vert,
                                size: 18,
                                color: AppColors.accentBlue,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'To',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: AppColors.white.withValues(alpha: 0.5),
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildAccountSelector(
                          account: toAccount,
                          onTap: () async {
                            final selected = await _showAccountPicker(
                              sheetContext,
                              accounts,
                              exclude: fromIdx,
                            );
                            if (selected != null) {
                              setSheetState(() {
                                toIdx = selected;
                                errorText = null;
                              });
                            }
                          },
                        ),
                        // FX rate indicator
                        if (isCrossCurrency) ...[
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(
                              color: AppColors.accentBlue.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.currency_exchange,
                                  size: 16,
                                  color: AppColors.accentBlue.withValues(alpha: 0.7),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '1 ${fromAccount.currency} = ${fxRate.toStringAsFixed(4)} ${toAccount.currency}',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.accentBlue,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  'Live rate',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: AppColors.white.withValues(alpha: 0.35),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        const SizedBox(height: 24),
                        // Amount input
                        Text(
                          'Amount',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: AppColors.white.withValues(alpha: 0.5),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.white.withValues(alpha: 0.06),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: TextField(
                            controller: amountController,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              color: AppColors.white,
                            ),
                            textAlign: TextAlign.center,
                            cursorColor: AppColors.accentBlue,
                            decoration: InputDecoration(
                              hintText: '${fromAccount.currency} 0.00',
                              hintStyle: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w700,
                                color: AppColors.white.withValues(alpha: 0.15),
                              ),
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              filled: false,
                            ),
                            onChanged: (_) {
                              setSheetState(() {
                                errorText = null;
                              });
                            },
                          ),
                        ),
                        if (errorText != null) ...[
                          const SizedBox(height: 6),
                          Text(
                            errorText!,
                            style: TextStyle(fontSize: 13, color: AppColors.danger),
                          ),
                        ],
                        const SizedBox(height: 8),
                        // Available + converted amount
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Available: ${Formatters.formatCurrency(fromAccount.balance, fromAccount.currency)}',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.white.withValues(alpha: 0.4),
                              ),
                            ),
                            if (isCrossCurrency && convertedAmount != null)
                              Text(
                                'Receives ${Formatters.formatCurrency(convertedAmount, toAccount.currency)}',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.success.withValues(alpha: 0.8),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Quick amount chips
                        Row(
                          children: [
                            _buildQuickChip('100', amountController, setSheetState),
                            const SizedBox(width: 8),
                            _buildQuickChip('1,000', amountController, setSheetState),
                            const SizedBox(width: 8),
                            _buildQuickChip('10,000', amountController, setSheetState),
                            const SizedBox(width: 8),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => setSheetState(() {
                                  amountController.text = fromAccount.balance.toStringAsFixed(2);
                                  errorText = null;
                                }),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  decoration: BoxDecoration(
                                    color: AppColors.accentBlue.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    'All',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.accentBlue,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                // Move button
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        final amount = double.tryParse(
                          amountController.text.replaceAll(',', ''),
                        );
                        if (amount == null || amount <= 0) {
                          setSheetState(() => errorText = 'Enter a valid amount');
                          return;
                        }
                        if (amount > fromAccount.balance) {
                          setSheetState(() => errorText = 'Insufficient funds');
                          return;
                        }
                        final received = amount * fxRate;
                        accounts[fromIdx] = fromAccount.copyWith(
                          balance: fromAccount.balance - amount,
                        );
                        accounts[toIdx] = toAccount.copyWith(
                          balance: toAccount.balance + received,
                        );
                        // Add transactions for both accounts
                        final now = DateTime.now();
                        final txnId = 'TXN_MOVE_${now.millisecondsSinceEpoch}';
                        // Debit on sender (shows on from-account + "All" view)
                        MockData.recentTransactions.insert(0, Transaction(
                          id: '${txnId}_debit',
                          title: 'Transfer ${fromAccount.currency} → ${toAccount.currency}',
                          subtitle: '${fromAccount.name} to ${toAccount.name}',
                          amount: -amount,
                          currency: fromAccount.currency,
                          date: now,
                          type: TransactionType.debit,
                          category: TransactionCategory.transfer,
                        ));
                        // Credit on receiver (shows only on to-account view)
                        if (fromAccount.currency != toAccount.currency) {
                          MockData.recentTransactions.insert(1, Transaction(
                            id: '${txnId}_credit',
                            title: 'Transfer ${fromAccount.currency} → ${toAccount.currency}',
                            subtitle: '${fromAccount.name} to ${toAccount.name}',
                            amount: received,
                            currency: toAccount.currency,
                            date: now,
                            type: TransactionType.credit,
                            category: TransactionCategory.transfer,
                          ));
                        }
                        Navigator.pop(sheetContext);
                        onRefresh?.call();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Row(
                              children: [
                                Icon(Icons.check_circle, color: AppColors.success),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    '${Formatters.formatCurrency(amount, fromAccount.currency)} moved to ${toAccount.name}${isCrossCurrency ? ' (${Formatters.formatCurrency(received, toAccount.currency)})' : ''}',
                                  ),
                                ),
                              ],
                            ),
                            backgroundColor: const Color(0xFF1A3A5C),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accentBlue,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Move',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          );
        },
      ),
    );
  }

  Widget _buildAccountSelector({
    required Account account,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Text(account.flagEmoji ?? '', style: const TextStyle(fontSize: 22)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    account.name,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.white,
                    ),
                  ),
                  Text(
                    Formatters.formatCurrency(account.balance, account.currency),
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.white.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down,
              size: 20,
              color: AppColors.white.withValues(alpha: 0.4),
            ),
          ],
        ),
      ),
    );
  }

  Future<int?> _showAccountPicker(
    BuildContext context,
    List<Account> accounts, {
    required int exclude,
  }) {
    return showModalBottomSheet<int>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        height: MediaQuery.of(context).size.height * 0.5,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF1A3A5C),
              const Color(0xFF0A1E3D),
            ],
          ),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.white.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Select Account',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.white,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: accounts.length,
                separatorBuilder: (_, _) => Divider(
                  height: 1,
                  color: AppColors.white.withValues(alpha: 0.08),
                ),
                itemBuilder: (ctx, i) {
                  if (i == exclude) {
                    return const SizedBox.shrink();
                  }
                  final account = accounts[i];
                  return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => Navigator.pop(ctx, i),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      child: Row(
                        children: [
                          Text(account.flagEmoji ?? '', style: const TextStyle(fontSize: 22)),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  account.name,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.white,
                                  ),
                                ),
                                Text(
                                  Formatters.formatCurrency(account.balance, account.currency),
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: AppColors.white.withValues(alpha: 0.5),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickChip(
    String label,
    TextEditingController controller,
    StateSetter setSheetState,
  ) {
    return Expanded(
      child: GestureDetector(
        onTap: () => setSheetState(() {
          controller.text = label.replaceAll(',', '');
        }),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.white.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.white.withValues(alpha: 0.7),
            ),
          ),
        ),
      ),
    );
  }

  void _showAccountDetailsSheet(BuildContext context) {
    if (selectedAccountIndex <= 0) {
      // Show message to select a specific account
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) => Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color(0xFF1A3A5C),
                const Color(0xFF0A1E3D),
              ],
            ),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 32),
              Icon(
                Icons.info_outline,
                size: 48,
                color: AppColors.accentBlue.withValues(alpha: 0.6),
              ),
              const SizedBox(height: 16),
              Text(
                'Select an Account',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Please select a specific account to view its details',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: AppColors.white.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accentBlue,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Got it'),
                ),
              ),
            ],
          ),
        ),
      );
      return;
    }
    final account = MockData.accounts[selectedAccountIndex - 1];
    final iban = 'CH93 0076 2011 6238 ${account.id.substring(account.id.length - 4)}';

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.55,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF1A3A5C),
              const Color(0xFF0A1E3D),
            ],
          ),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.white.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              account.name,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Account Details',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.white.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    _DetailsRow(label: 'Account Name', value: 'Simon Safra'),
                    const SizedBox(height: 16),
                    _DetailsRow(label: 'IBAN', value: iban),
                    const SizedBox(height: 16),
                    _DetailsRow(label: 'BIC/SWIFT', value: 'SAABORBA'),
                    const SizedBox(height: 16),
                    _DetailsRow(label: 'Currency', value: account.currency),
                    const SizedBox(height: 16),
                    _DetailsRow(
                      label: 'Balance',
                      value: Formatters.formatCurrency(account.balance, account.currency),
                    ),
                    const SizedBox(height: 16),
                    _DetailsRow(label: 'Bank', value: 'J. Safra Sarasin Ltd'),
                  ],
                ),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            Icon(Icons.check_circle, color: AppColors.success),
                            const SizedBox(width: 12),
                            const Text('Details copied to clipboard'),
                          ],
                        ),
                        backgroundColor: const Color(0xFF1A3A5C),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accentBlue,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.copy, size: 18),
                  label: const Text('Copy Details'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final balance = MockData.balanceForIndex(selectedAccountIndex);
    final currency = MockData.currencyForIndex(selectedAccountIndex);
    final label = selectedAccountIndex == 0
        ? 'Total Balance'
        : MockData.nameForIndex(selectedAccountIndex);

    // Split formatted balance into whole and decimal parts
    final formatted = Formatters.formatCurrency(balance, currency);
    final dotIndex = formatted.lastIndexOf('.');
    final wholePart = dotIndex >= 0 ? formatted.substring(0, dotIndex) : formatted;
    final decimalPart = dotIndex >= 0 ? formatted.substring(dotIndex) : '';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.white.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 16),
          // Balance with smaller decimals
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: wholePart,
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w700,
                    color: AppColors.white,
                    letterSpacing: -1,
                  ),
                ),
                TextSpan(
                  text: decimalPart,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    color: AppColors.white.withValues(alpha: 0.5),
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 44),
          // Action buttons: icon in circle, label below
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _ActionButton(
                  icon: Icons.add,
                  label: 'Add',
                  onTap: () => _showAddMoneySheet(context),
                ),
                _ActionButton(
                  icon: Icons.arrow_upward,
                  label: 'Send',
                  onTap: () => onNavigateToTab?.call(2),
                ),
                _ActionButton(
                  icon: Icons.swap_horiz,
                  label: 'Move',
                  onTap: () => _showMoveMoneySheet(context),
                ),
                _ActionButton(
                  icon: Icons.info_outline,
                  label: 'Details',
                  onTap: () => _showAccountDetailsSheet(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.10),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 22,
              color: AppColors.white,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.white.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}

class _AddMoneyOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _AddMoneyOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.white.withValues(alpha: 0.1),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.accentBlue.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppColors.accentBlue, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.white.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppColors.white.withValues(alpha: 0.5),
            ),
          ],
        ),
      ),
    );
  }
}

class _BankDetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _BankDetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: AppColors.white.withValues(alpha: 0.5),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.white,
          ),
        ),
      ],
    );
  }
}

class _DetailsRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailsRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: AppColors.white.withValues(alpha: 0.5),
          ),
        ),
        Flexible(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.white,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}

class _AmountChip extends StatelessWidget {
  final String amount;

  const _AmountChip({required this.amount});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.white.withValues(alpha: 0.15),
        ),
      ),
      child: Text(
        'CHF $amount',
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: AppColors.white,
        ),
      ),
    );
  }
}

class _QRPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF0A1E3D)
      ..style = PaintingStyle.fill;

    final cellSize = size.width / 25;
    final rng = Random(42); // Fixed seed for consistent pattern

    // Draw finder patterns (3 corners)
    _drawFinderPattern(canvas, paint, 0, 0, cellSize);
    _drawFinderPattern(canvas, paint, size.width - 7 * cellSize, 0, cellSize);
    _drawFinderPattern(canvas, paint, 0, size.height - 7 * cellSize, cellSize);

    // Draw data modules
    for (int row = 0; row < 25; row++) {
      for (int col = 0; col < 25; col++) {
        // Skip finder pattern areas
        if ((row < 8 && col < 8) || (row < 8 && col > 16) || (row > 16 && col < 8)) continue;
        if (rng.nextBool()) {
          final rect = Rect.fromLTWH(
            col * cellSize,
            row * cellSize,
            cellSize * 0.9,
            cellSize * 0.9,
          );
          canvas.drawRRect(
            RRect.fromRectAndRadius(rect, Radius.circular(cellSize * 0.2)),
            paint,
          );
        }
      }
    }
  }

  void _drawFinderPattern(Canvas canvas, Paint paint, double x, double y, double cell) {
    // Outer ring
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(x, y, 7 * cell, 7 * cell),
        Radius.circular(cell),
      ),
      paint,
    );
    // White inner
    final whitePaint = Paint()..color = const Color(0xFFFFFFFF);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(x + cell, y + cell, 5 * cell, 5 * cell),
        Radius.circular(cell * 0.6),
      ),
      whitePaint,
    );
    // Center block
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(x + 2 * cell, y + 2 * cell, 3 * cell, 3 * cell),
        Radius.circular(cell * 0.5),
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
