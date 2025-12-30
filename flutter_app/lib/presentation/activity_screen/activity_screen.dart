import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../theme/app_theme.dart';
import '../../widgets/app_card.dart';
import '../../widgets/section_header.dart';

class ActivityScreen extends StatelessWidget {
  const ActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity'),
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
                    'Weekly ride summary',
                    style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    'You completed 8 trips this week across 3 cities.',
                    style: textTheme.bodySmall?.copyWith(color: AppTheme.slate),
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    children: [
                      _ActivityStat(label: 'Miles', value: '126'),
                      SizedBox(width: 6.w),
                      _ActivityStat(label: 'Savings', value: '\$34'),
                      SizedBox(width: 6.w),
                      _ActivityStat(label: 'Rating', value: '4.97'),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 3.h),
            const SectionHeader(title: 'Recent trips'),
            SizedBox(height: 1.6.h),
            _ActivityTripTile(
              title: 'Brooklyn → Midtown',
              time: 'Today · 2:10 PM',
              price: '\$18.40',
            ),
            _ActivityTripTile(
              title: 'JFK Airport',
              time: 'Mon · 8:30 AM',
              price: '\$36.20',
            ),
            _ActivityTripTile(
              title: 'Union Square',
              time: 'Sun · 6:05 PM',
              price: '\$12.95',
            ),
          ],
        ),
      ),
    );
  }
}

class _ActivityStat extends StatelessWidget {
  const _ActivityStat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppTheme.slate),
        ),
      ],
    );
  }
}

class _ActivityTripTile extends StatelessWidget {
  const _ActivityTripTile({required this.title, required this.time, required this.price});

  final String title;
  final String time;
  final String price;

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
          const Icon(Icons.route_outlined),
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
                  time,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppTheme.slate),
                ),
              ],
            ),
          ),
          Text(
            price,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
