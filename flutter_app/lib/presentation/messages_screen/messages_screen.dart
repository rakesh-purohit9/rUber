import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../theme/app_theme.dart';
import '../../widgets/app_card.dart';
import '../../widgets/section_header.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppCard(
              child: Row(
                children: [
                  const Icon(Icons.chat_bubble_outline, size: 36),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Your inbox is organized',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        SizedBox(height: 0.8.h),
                        Text(
                          'Priority updates from drivers and support appear here.',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppTheme.slate),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 3.h),
            const SectionHeader(title: 'Recent conversations'),
            SizedBox(height: 1.6.h),
            _MessageTile(
              name: 'Support team',
              message: 'Your lost item request was received.',
              time: '5m',
            ),
            _MessageTile(
              name: 'Driver Alex',
              message: 'I\'m arriving at the pickup spot now.',
              time: '1h',
            ),
            _MessageTile(
              name: 'Safety Center',
              message: 'Safety check: confirm you feel safe on your trip.',
              time: '1d',
            ),
          ],
        ),
      ),
    );
  }
}

class _MessageTile extends StatelessWidget {
  const _MessageTile({required this.name, required this.message, required this.time});

  final String name;
  final String message;
  final String time;

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
            child: const Icon(Icons.person_outline, color: AppTheme.ink),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 0.6.h),
                Text(
                  message,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppTheme.slate),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppTheme.slate),
          ),
        ],
      ),
    );
  }
}
