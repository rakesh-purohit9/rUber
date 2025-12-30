import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../theme/app_theme.dart';
import '../../widgets/app_card.dart';
import '../../widgets/section_header.dart';

class SafetyScreen extends StatelessWidget {
  const SafetyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Safety'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppCard(
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 28,
                    backgroundColor: AppTheme.ink,
                    child: Icon(Icons.shield_outlined, color: Colors.white),
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ride Check enabled',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        SizedBox(height: 0.8.h),
                        Text(
                          'Automatic checks on unexpected stops or route changes.',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppTheme.slate),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 3.h),
            const SectionHeader(title: 'Safety tools'),
            SizedBox(height: 1.6.h),
            _SafetyToolTile(
              title: 'Trusted contacts',
              subtitle: 'Share trip updates automatically',
              icon: Icons.group_outlined,
            ),
            _SafetyToolTile(
              title: 'Emergency help',
              subtitle: 'Connect to 911 with your ride details',
              icon: Icons.emergency_outlined,
            ),
            _SafetyToolTile(
              title: 'Audio recording',
              subtitle: 'Record audio for added peace of mind',
              icon: Icons.mic_none_outlined,
            ),
          ],
        ),
      ),
    );
  }
}

class _SafetyToolTile extends StatelessWidget {
  const _SafetyToolTile({required this.title, required this.subtitle, required this.icon});

  final String title;
  final String subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(3.5.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppTheme.electricGreen.withOpacity(0.12),
            child: Icon(icon, color: AppTheme.ink),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 0.6.h),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppTheme.slate),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios_rounded, size: 14),
        ],
      ),
    );
  }
}
