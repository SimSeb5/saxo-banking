import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:ui';
import '../../theme/app_theme.dart';
import '../../data/mock_data.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _faceIdEnabled = true;
  bool _pushNotifications = true;
  bool _priceAlerts = true;
  bool _paymentNotifications = true;
  bool _securityAlerts = true;
  String _defaultTradingMode = 'SaxoInvestor';
  String _sessionTimeout = '15 minutes';
  String _defaultOrderType = 'Market';
  bool _emailAlerts = false;

  @override
  Widget build(BuildContext context) {
    final user = MockData.userProfile;

    return Scaffold(
      backgroundColor: Colors.transparent,
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
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 16),
                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Text(
                        'Settings',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: AppColors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Profile card
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.white.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppColors.white.withValues(alpha: 0.1),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.accentBlue,
                                    AppColors.accentBlue.withValues(alpha: 0.7),
                                  ],
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  user.initials,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.white,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    user.fullName,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    user.clientId,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: AppColors.white.withValues(alpha: 0.5),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.accentGold,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                'Platinum',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Personal Information
                _SettingsSection(
                  title: 'Personal Information',
                  children: [
                    _SettingsTile(
                      icon: Icons.person_outline,
                      title: 'Name',
                      value: user.fullName,
                    ),
                    _SettingsTile(
                      icon: Icons.email_outlined,
                      title: 'Email',
                      value: user.email,
                    ),
                    _SettingsTile(
                      icon: Icons.phone_outlined,
                      title: 'Phone',
                      value: user.phone,
                    ),
                    _SettingsTile(
                      icon: Icons.info_outline,
                      title: 'Contact RM to update',
                      isSubtitle: true,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Security
                _SettingsSection(
                  title: 'Security',
                  children: [
                    _SettingsToggleTile(
                      icon: Icons.face_unlock_outlined,
                      title: 'Face ID',
                      value: _faceIdEnabled,
                      onChanged: (v) => setState(() => _faceIdEnabled = v),
                    ),
                    _SettingsTile(
                      icon: Icons.pin_outlined,
                      title: 'Change PIN',
                      showArrow: true,
                      onTap: () => _showChangePinSheet(),
                    ),
                    _SettingsTile(
                      icon: Icons.security_outlined,
                      title: 'Two-Factor Authentication',
                      value: 'Enabled',
                      showArrow: true,
                      onTap: () => _show2FASheet(),
                    ),
                    _SettingsDropdownTile(
                      icon: Icons.timer_outlined,
                      title: 'Session Timeout',
                      value: _sessionTimeout,
                      options: ['5 minutes', '10 minutes', '15 minutes', '30 minutes'],
                      onChanged: (v) => setState(() => _sessionTimeout = v),
                    ),
                    _SettingsTile(
                      icon: Icons.history,
                      title: 'Recent Login Activity',
                      showArrow: true,
                      onTap: () => _showLoginActivitySheet(),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Account Management
                _SettingsSection(
                  title: 'Account Management',
                  children: [
                    _SettingsTile(
                      icon: Icons.account_balance_wallet_outlined,
                      title: 'Sub-accounts',
                      value: '4 accounts',
                      showArrow: true,
                      onTap: () => _showSubAccountsSheet(),
                    ),
                    _SettingsTile(
                      icon: Icons.currency_exchange,
                      title: 'Default Currency',
                      value: 'CHF',
                      showArrow: true,
                      onTap: () => _showCurrencySheet(),
                    ),
                    _SettingsTile(
                      icon: Icons.description_outlined,
                      title: 'Statement Preferences',
                      value: 'Monthly',
                      showArrow: true,
                      onTap: () => _showStatementSheet(),
                    ),
                    _SettingsTile(
                      icon: Icons.receipt_long_outlined,
                      title: 'Tax Documents',
                      showArrow: true,
                      onTap: () => _showTaxDocumentsSheet(),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Trading Preferences
                _SettingsSection(
                  title: 'Trading Preferences',
                  children: [
                    _SettingsDropdownTile(
                      icon: Icons.candlestick_chart_outlined,
                      title: 'Default Trading Mode',
                      value: _defaultTradingMode,
                      options: ['SaxoInvestor', 'SaxoTraderGO', 'SaxoTraderPRO'],
                      onChanged: (v) => setState(() => _defaultTradingMode = v),
                    ),
                    _SettingsTile(
                      icon: Icons.receipt_outlined,
                      title: 'Default Order Type',
                      value: _defaultOrderType,
                      showArrow: true,
                      onTap: () => _showDefaultOrderTypeSheet(),
                    ),
                    _SettingsTile(
                      icon: Icons.notifications_active_outlined,
                      title: 'Price Alert Settings',
                      showArrow: true,
                      onTap: () => _showPriceAlertSettingsSheet(),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Notifications
                _SettingsSection(
                  title: 'Notifications',
                  children: [
                    _SettingsToggleTile(
                      icon: Icons.notifications_outlined,
                      title: 'Push Notifications',
                      value: _pushNotifications,
                      onChanged: (v) => setState(() => _pushNotifications = v),
                    ),
                    _SettingsToggleTile(
                      icon: Icons.trending_up,
                      title: 'Price Alerts',
                      value: _priceAlerts,
                      onChanged: (v) => setState(() => _priceAlerts = v),
                    ),
                    _SettingsToggleTile(
                      icon: Icons.payment_outlined,
                      title: 'Payment Notifications',
                      value: _paymentNotifications,
                      onChanged: (v) => setState(() => _paymentNotifications = v),
                    ),
                    _SettingsToggleTile(
                      icon: Icons.shield_outlined,
                      title: 'Security Alerts',
                      value: _securityAlerts,
                      onChanged: (v) => setState(() => _securityAlerts = v),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // App
                _SettingsSection(
                  title: 'App',
                  children: [
                    _SettingsTile(
                      icon: Icons.language,
                      title: 'Language',
                      value: 'English',
                      showArrow: true,
                      onTap: () => _showLanguageSheet(),
                    ),
                    _SettingsTile(
                      icon: Icons.info_outline,
                      title: 'App Version',
                      value: 'SAXO Banking v1.0.0',
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Legal
                _SettingsSection(
                  title: 'Legal',
                  children: [
                    _SettingsTile(
                      icon: Icons.description_outlined,
                      title: 'Terms of Service',
                      showArrow: true,
                      onTap: () => _showLegalSheet('Terms of Service'),
                    ),
                    _SettingsTile(
                      icon: Icons.privacy_tip_outlined,
                      title: 'Privacy Policy',
                      showArrow: true,
                      onTap: () => _showLegalSheet('Privacy Policy'),
                    ),
                    _SettingsTile(
                      icon: Icons.gavel_outlined,
                      title: 'Regulatory Information',
                      showArrow: true,
                      onTap: () => _showLegalSheet('Regulatory Information'),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                // Footer
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      Text(
                        'SAXO',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.white,
                          letterSpacing: 3,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Backed by J. Safra Sarasin',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.accentGold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'J. Safra Sarasin Ltd, Basel, Switzerland',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.white.withValues(alpha: 0.4),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                // Logout button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => _showLogoutConfirmation(),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.danger,
                        side: BorderSide(color: AppColors.danger.withValues(alpha: 0.5)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.logout, size: 20),
                      label: const Text(
                        'Sign Out',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showChangePinSheet() {
    _showGenericSheet('Change PIN', 'Enter your current PIN to set a new one.');
  }

  void _show2FASheet() {
    _showGenericSheet('Two-Factor Authentication', 'Your account is protected with 2FA via SMS.');
  }

  void _showLoginActivitySheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
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
              'Recent Login Activity',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.white,
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _LoginActivityTile(
                    device: 'iPhone 15 Pro',
                    location: 'Zurich, Switzerland',
                    time: 'Now',
                    isCurrent: true,
                  ),
                  _LoginActivityTile(
                    device: 'MacBook Pro',
                    location: 'Geneva, Switzerland',
                    time: '2 hours ago',
                  ),
                  _LoginActivityTile(
                    device: 'iPad Pro',
                    location: 'Basel, Switzerland',
                    time: 'Yesterday',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSubAccountsSheet() {
    _showGenericSheet('Sub-accounts', 'Manage your linked accounts and portfolios.');
  }

  void _showCurrencySheet() {
    _showGenericSheet('Default Currency', 'Change your default display currency.');
  }

  void _showStatementSheet() {
    _showGenericSheet('Statement Preferences', 'Configure your statement delivery options.');
  }

  void _showTaxDocumentsSheet() {
    _showGenericSheet('Tax Documents', 'Access your tax certificates and annual statements.');
  }

  void _showLanguageSheet() {
    _showGenericSheet('Language', 'Choose your preferred language.');
  }

  void _showLegalSheet(String title) {
    _showGenericSheet(title, 'Legal documentation and regulatory information.');
  }

  void _showDefaultOrderTypeSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
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
            const SizedBox(height: 20),
            Text(
              'Default Order Type',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.white,
              ),
            ),
            const SizedBox(height: 16),
            ...['Market', 'Limit', 'Stop'].map((type) => InkWell(
              onTap: () {
                Navigator.pop(context);
                setState(() => _defaultOrderType = type);
                ScaffoldMessenger.of(this.context).showSnackBar(
                  SnackBar(
                    content: Text('Default order type set to $type'),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: const Color(0xFF1A3A5C),
                  ),
                );
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                margin: const EdgeInsets.only(bottom: 4),
                decoration: BoxDecoration(
                  color: _defaultOrderType == type
                      ? AppColors.accentBlue.withValues(alpha: 0.2)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _defaultOrderType == type
                        ? AppColors.accentBlue.withValues(alpha: 0.4)
                        : AppColors.white.withValues(alpha: 0.08),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        type,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                    if (_defaultOrderType == type)
                      Icon(
                        Icons.check_circle,
                        color: AppColors.accentBlue,
                        size: 22,
                      ),
                  ],
                ),
              ),
            )),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showPriceAlertSettingsSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) => StatefulBuilder(
        builder: (builderContext, setSheetState) => Container(
          padding: const EdgeInsets.all(24),
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
              const SizedBox(height: 20),
              Text(
                'Price Alert Settings',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.white,
                ),
              ),
              const SizedBox(height: 24),
              // Push Notifications toggle
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Icon(
                      Icons.notifications_outlined,
                      size: 22,
                      color: AppColors.white.withValues(alpha: 0.7),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        'Push Notifications for Alerts',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                    CupertinoSwitch(
                      value: _priceAlerts,
                      onChanged: (v) {
                        setState(() => _priceAlerts = v);
                        setSheetState(() {});
                      },
                      activeTrackColor: AppColors.accentBlue,
                    ),
                  ],
                ),
              ),
              Container(
                height: 1,
                margin: const EdgeInsets.only(left: 36),
                color: AppColors.white.withValues(alpha: 0.08),
              ),
              // Email Alerts toggle
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Icon(
                      Icons.email_outlined,
                      size: 22,
                      color: AppColors.white.withValues(alpha: 0.7),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        'Email Alerts',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                    CupertinoSwitch(
                      value: _emailAlerts,
                      onChanged: (v) {
                        setState(() => _emailAlerts = v);
                        setSheetState(() {});
                      },
                      activeTrackColor: AppColors.accentBlue,
                    ),
                  ],
                ),
              ),
              Container(
                height: 1,
                margin: const EdgeInsets.only(left: 36),
                color: AppColors.white.withValues(alpha: 0.08),
              ),
              // Alert Cooldown
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Row(
                  children: [
                    Icon(
                      Icons.timer_outlined,
                      size: 22,
                      color: AppColors.white.withValues(alpha: 0.7),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        'Alert Cooldown',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                    Text(
                      '15 minutes',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.white.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Done button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(sheetContext),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accentBlue,
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Done'),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  void _showGenericSheet(String title, String description) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
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
            const SizedBox(height: 20),
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.white,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.white.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accentBlue,
                  foregroundColor: AppColors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Close'),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showLogoutConfirmation() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
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
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.danger.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.logout,
                color: AppColors.danger,
                size: 32,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Sign Out?',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Are you sure you want to sign out of your account?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.white.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.white,
                      side: BorderSide(
                        color: AppColors.white.withValues(alpha: 0.3),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      // Would handle logout here
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.danger,
                      foregroundColor: AppColors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Sign Out'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SettingsSection({
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.white.withValues(alpha: 0.5),
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.white.withValues(alpha: 0.1),
                  ),
                ),
                child: Column(
                  children: children.asMap().entries.map((entry) {
                    final index = entry.key;
                    final child = entry.value;
                    if (index == children.length - 1) return child;
                    return Column(
                      children: [
                        child,
                        Container(
                          height: 1,
                          margin: const EdgeInsets.only(left: 52),
                          color: AppColors.white.withValues(alpha: 0.08),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? value;
  final bool showArrow;
  final bool isSubtitle;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.value,
    this.showArrow = false,
    this.isSubtitle = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(
              icon,
              size: 22,
              color: isSubtitle
                  ? AppColors.white.withValues(alpha: 0.3)
                  : AppColors.white.withValues(alpha: 0.7),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: isSubtitle
                      ? AppColors.white.withValues(alpha: 0.4)
                      : AppColors.white,
                  fontStyle: isSubtitle ? FontStyle.italic : FontStyle.normal,
                ),
              ),
            ),
            if (value != null)
              Text(
                value!,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.white.withValues(alpha: 0.5),
                ),
              ),
            if (showArrow) ...[
              const SizedBox(width: 8),
              Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: AppColors.white.withValues(alpha: 0.4),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _SettingsToggleTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SettingsToggleTile({
    required this.icon,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Icon(
            icon,
            size: 22,
            color: AppColors.white.withValues(alpha: 0.7),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: AppColors.white,
              ),
            ),
          ),
          CupertinoSwitch(
            value: value,
            onChanged: onChanged,
            activeTrackColor: AppColors.accentBlue,
          ),
        ],
      ),
    );
  }
}

class _SettingsDropdownTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final List<String> options;
  final ValueChanged<String> onChanged;

  const _SettingsDropdownTile({
    required this.icon,
    required this.title,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Icon(
            icon,
            size: 22,
            color: AppColors.white.withValues(alpha: 0.7),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: AppColors.white,
              ),
            ),
          ),
          Theme(
            data: ThemeData.dark(),
            child: DropdownButton<String>(
              value: value,
              underline: const SizedBox(),
              dropdownColor: const Color(0xFF1A3A5C),
              icon: Icon(
                Icons.keyboard_arrow_down,
                color: AppColors.white.withValues(alpha: 0.5),
              ),
              style: TextStyle(
                fontSize: 14,
                color: AppColors.white.withValues(alpha: 0.7),
              ),
              items: options.map((option) {
                return DropdownMenuItem(
                  value: option,
                  child: Text(option),
                );
              }).toList(),
              onChanged: (v) => v != null ? onChanged(v) : null,
            ),
          ),
        ],
      ),
    );
  }
}

class _LoginActivityTile extends StatelessWidget {
  final String device;
  final String location;
  final String time;
  final bool isCurrent;

  const _LoginActivityTile({
    required this.device,
    required this.location,
    required this.time,
    this.isCurrent = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCurrent
              ? AppColors.success.withValues(alpha: 0.3)
              : AppColors.white.withValues(alpha: 0.08),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: (isCurrent ? AppColors.success : AppColors.accentBlue)
                  .withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.devices,
              color: isCurrent ? AppColors.success : AppColors.accentBlue,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      device,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: AppColors.white,
                      ),
                    ),
                    if (isCurrent) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.success.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Current',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: AppColors.success,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  '$location • $time',
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
    );
  }
}
