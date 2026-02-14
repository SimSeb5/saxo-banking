import 'package:flutter/material.dart';
import 'dart:ui';
import '../../../../theme/app_theme.dart';
import '../../../../data/mock_data.dart';

class ClientStep extends StatelessWidget {
  final bool isEntity;
  final ValueChanged<bool> onEntityChanged;
  final VoidCallback onNext;

  const ClientStep({
    super.key,
    required this.isEntity,
    required this.onEntityChanged,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final user = MockData.userProfile;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Let's Get Started",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: AppColors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "We'll help you set up your Lombard credit facility. This usually takes about 5 minutes.",
            style: TextStyle(
              fontSize: 15,
              color: AppColors.white.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 32),
          // Pre-filled fields
          _InfoField(
            label: 'Account Holder',
            value: user.fullName,
            icon: Icons.person_outline,
          ),
          const SizedBox(height: 16),
          _InfoField(
            label: 'Client Segment',
            value: user.segment,
            icon: Icons.star_outline,
            badge: 'Premium',
            badgeColor: AppColors.accentGold,
          ),
          const SizedBox(height: 16),
          _InfoField(
            label: 'Relationship Manager',
            value: user.relationshipManager,
            icon: Icons.support_agent_outlined,
          ),
          const SizedBox(height: 16),
          _InfoField(
            label: 'Booking Center',
            value: user.bookingCenter,
            icon: Icons.location_on_outlined,
            isEditable: true,
          ),
          const SizedBox(height: 24),
          // Entity toggle
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
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
                    Icon(
                      Icons.business_outlined,
                      color: AppColors.white.withValues(alpha: 0.6),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Is this for you or a related entity?',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.white,
                            ),
                          ),
                          Text(
                            'You can apply on behalf of a company',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.white.withValues(alpha: 0.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: isEntity,
                      onChanged: onEntityChanged,
                      activeTrackColor:
                          AppColors.accentBlue.withValues(alpha: 0.5),
                      activeThumbColor: AppColors.accentBlue,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),
          // Next button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onNext,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accentBlue,
                foregroundColor: AppColors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Continue',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoField extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final String? badge;
  final Color? badgeColor;
  final bool isEditable;

  const _InfoField({
    required this.label,
    required this.value,
    required this.icon,
    this.badge,
    this.badgeColor,
    this.isEditable = false,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
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
              Icon(
                icon,
                color: AppColors.white.withValues(alpha: 0.6),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.white.withValues(alpha: 0.5),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Text(
                          value,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: AppColors.white,
                          ),
                        ),
                        if (badge != null) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: badgeColor ?? AppColors.accentBlue,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              badge!,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: AppColors.white,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              if (isEditable)
                Icon(
                  Icons.keyboard_arrow_down,
                  color: AppColors.white.withValues(alpha: 0.4),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
