import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../theme/app_theme.dart';
import '../../widgets/app_card.dart';
import '../../widgets/section_header.dart';

class PromotionsScreen extends StatelessWidget {
  const PromotionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Promotions'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ride credits',
                    style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    'You have \$12 in available credits.',
                    style: textTheme.bodySmall?.copyWith(color: AppTheme.slate),
                  ),
                  SizedBox(height: 2.h),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 6.h),
                      backgroundColor: AppTheme.ink,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Apply to next ride'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 3.h),
            const SectionHeader(title: 'Available offers'),
            SizedBox(height: 1.6.h),
            _PromoTile(
              title: 'Airport saver',
              subtitle: 'Save 15% on rides to JFK, LAX, or ORD.',
              code: 'FLYAIR15',
            ),
            _PromoTile(
              title: 'Late night rides',
              subtitle: 'Up to \$8 off rides after 10 PM.',
              code: 'NIGHT8',
            ),
          ],
        ),
      ),
    );
  }
}

class _PromoTile extends StatelessWidget {
  const _PromoTile({required this.title, required this.subtitle, required this.code});

  final String title;
  final String subtitle;
  final String code;

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
          const Icon(Icons.card_giftcard_outlined),
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.electricGreen.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              code,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppTheme.ink),
            ),
          ),
        ],
      ),
    );
  }
}
