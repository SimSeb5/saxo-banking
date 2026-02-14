import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'dart:ui';
import '../../../theme/app_theme.dart';
import '../../../models/loan_request.dart';
import '../request_tracker.dart';
import 'steps/client_step.dart';
import 'steps/loan_params_step.dart';
import 'steps/collateral_step.dart';
import 'steps/compliance_step.dart';
import 'steps/pricing_step.dart';
import 'steps/review_step.dart';
import 'chat_assistant.dart';

class RequestWizard extends StatefulWidget {
  const RequestWizard({super.key});

  @override
  State<RequestWizard> createState() => _RequestWizardState();
}

class _RequestWizardState extends State<RequestWizard> {
  final _pageController = PageController();
  int _currentStep = 0;
  bool _showChat = false;

  // Wizard state
  double _loanAmount = 500000;
  String _loanCurrency = 'CHF';
  String _loanPurpose = 'Portfolio leverage';
  String _termType = 'Open-ended (revolving)';
  String _drawdownPref = 'Full amount';
  bool _isEntityApplication = false;
  Set<String> _selectedCollateral = {};
  bool _termsAccepted = false;

  void _nextStep() {
    if (_currentStep < 5) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {
        _currentStep++;
      });
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {
        _currentStep--;
      });
    }
  }

  void _confirmClose() async {
    final shouldClose = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A3A5C),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Discard request?',
          style: TextStyle(color: AppColors.white),
        ),
        content: Text(
          'Your progress will be lost.',
          style: TextStyle(color: AppColors.white.withValues(alpha: 0.7)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              'Cancel',
              style: TextStyle(color: AppColors.white.withValues(alpha: 0.6)),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              'Discard',
              style: TextStyle(color: AppColors.danger),
            ),
          ),
        ],
      ),
    );
    if (shouldClose == true && mounted) {
      Navigator.of(context).pop();
    }
  }

  void _navigateToTracker() {
    final mockRequest = LoanRequest(
      id: 'new-001',
      referenceNumber: 'LMB-2026-00142',
      amount: _loanAmount,
      currency: _loanCurrency,
      purpose: _loanPurpose,
      submittedDate: DateTime.now(),
      status: LoanStatus.submitted,
      ltv: 50.0,
      collateralValue: _loanAmount * 2,
    );
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => RequestTracker(request: mockRequest),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          child: Stack(
            children: [
              Column(
                children: [
                  // Custom App Bar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.close, color: AppColors.white),
                          onPressed: _confirmClose,
                        ),
                        Expanded(
                          child: Text(
                            'Lombard Request',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 48),
                      ],
                    ),
                  ),
                  // Progress indicator
                  ClipRRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                        decoration: BoxDecoration(
                          color: AppColors.white.withValues(alpha: 0.05),
                          border: Border(
                            bottom: BorderSide(
                              color: AppColors.white.withValues(alpha: 0.1),
                            ),
                          ),
                        ),
                        child: Column(
                          children: [
                            SmoothPageIndicator(
                              controller: _pageController,
                              count: 6,
                              effect: ExpandingDotsEffect(
                                dotHeight: 8,
                                dotWidth: 8,
                                activeDotColor: AppColors.accentBlue,
                                dotColor: AppColors.white.withValues(alpha: 0.2),
                                expansionFactor: 3,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              _getStepTitle(),
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.white.withValues(alpha: 0.6),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Step content
                  Expanded(
                    child: PageView(
                      controller: _pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        ClientStep(
                          isEntity: _isEntityApplication,
                          onEntityChanged: (v) =>
                              setState(() => _isEntityApplication = v),
                          onNext: _nextStep,
                        ),
                        LoanParamsStep(
                          amount: _loanAmount,
                          currency: _loanCurrency,
                          purpose: _loanPurpose,
                          termType: _termType,
                          drawdownPref: _drawdownPref,
                          onAmountChanged: (v) => setState(() => _loanAmount = v),
                          onCurrencyChanged: (v) =>
                              setState(() => _loanCurrency = v),
                          onPurposeChanged: (v) => setState(() => _loanPurpose = v),
                          onTermTypeChanged: (v) => setState(() => _termType = v),
                          onDrawdownPrefChanged: (v) =>
                              setState(() => _drawdownPref = v),
                          onNext: _nextStep,
                          onBack: _previousStep,
                        ),
                        CollateralStep(
                          loanAmount: _loanAmount,
                          selectedCollateral: _selectedCollateral,
                          onCollateralChanged: (v) =>
                              setState(() => _selectedCollateral = v),
                          onNext: _nextStep,
                          onBack: _previousStep,
                        ),
                        ComplianceStep(
                          onNext: _nextStep,
                          onBack: _previousStep,
                        ),
                        PricingStep(
                          loanAmount: _loanAmount,
                          loanCurrency: _loanCurrency,
                          termsAccepted: _termsAccepted,
                          onTermsChanged: (v) =>
                              setState(() => _termsAccepted = v),
                          onNext: _nextStep,
                          onBack: _previousStep,
                        ),
                        ReviewStep(
                          loanAmount: _loanAmount,
                          loanCurrency: _loanCurrency,
                          loanPurpose: _loanPurpose,
                          termType: _termType,
                          drawdownPref: _drawdownPref,
                          selectedCollateral: _selectedCollateral,
                          onBack: _previousStep,
                          onTrackStatus: _navigateToTracker,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // Chat assistant bubble
              Positioned(
                right: 20,
                bottom: 20,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _showChat = !_showChat;
                    });
                  },
                  child: Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: AppColors.accentBlue,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.accentBlue.withValues(alpha: 0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      _showChat ? Icons.close : Icons.chat_bubble_outline,
                      color: AppColors.white,
                      size: 24,
                    ),
                  ),
                ),
              ),
              // Chat panel
              if (_showChat)
                ChatAssistant(
                  currentStep: _currentStep,
                  onClose: () => setState(() => _showChat = false),
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _getStepTitle() {
    switch (_currentStep) {
      case 0:
        return 'Step 1 of 6 — Client Information';
      case 1:
        return 'Step 2 of 6 — Loan Parameters';
      case 2:
        return 'Step 3 of 6 — Collateral Selection';
      case 3:
        return 'Step 4 of 6 — Compliance Check';
      case 4:
        return 'Step 5 of 6 — Pricing & Terms';
      case 5:
        return 'Step 6 of 6 — Review & Submit';
      default:
        return '';
    }
  }
}
