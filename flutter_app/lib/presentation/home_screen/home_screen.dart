import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../theme/app_theme.dart';
import '../../widgets/section_header.dart';
import '../../widgets/quick_action_card.dart';
import '../../widgets/ride_option_tile.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Where to?'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded),
            onPressed: () {},
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: CircleAvatar(
              backgroundColor: AppTheme.electricGreen.withOpacity(0.12),
              child: const Icon(Icons.person_outline, color: AppTheme.ink),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Good afternoon, Maya',
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    'Verified for U.S. riders only',
                    style: textTheme.bodyMedium?.copyWith(
                      color: AppTheme.slate,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  TextField(
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      hintText: 'Enter pickup or destination',
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Container(
                    height: 24.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.electricGreen.withOpacity(0.15),
                          AppTheme.ink.withOpacity(0.08),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.map_outlined, size: 48),
                          SizedBox(height: 1.h),
                          Text(
                            'Live city map preview',
                            style: textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 3.h),
            const SectionHeader(title: 'Quick actions'),
            SizedBox(height: 1.6.h),
            Row(
              children: [
                Expanded(
                  child: QuickActionCard(
                    title: 'Ride now',
                    subtitle: 'Fast pickup in minutes',
                    icon: Icons.flash_on_outlined,
                    accent: AppTheme.electricGreen,
                    onTap: () {},
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: QuickActionCard(
                    title: 'Reserve',
                    subtitle: 'Plan rides up to 30 days',
                    icon: Icons.event_available_outlined,
                    accent: AppTheme.ink,
                    onTap: () {},
                  ),
                ),
              ],
            ),
            SizedBox(height: 3.h),
            const SectionHeader(title: 'Choose your ride'),
            SizedBox(height: 1.6.h),
            const RideOptionTile(
              title: 'rUber Black',
              subtitle: 'Premium SUVs, top-rated drivers',
              eta: '3 min',
              price: '\$26 - \$32',
              tag: 'Best match',
            ),
            const RideOptionTile(
              title: 'rUber Comfort',
              subtitle: 'Newer cars, extra legroom',
              eta: '5 min',
              price: '\$18 - \$23',
            ),
            const RideOptionTile(
              title: 'rUber XL',
              subtitle: 'Fits groups up to 6 riders',
              eta: '7 min',
              price: '\$22 - \$27',
            ),
            SizedBox(height: 3.h),
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(24),
              ),
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
                          'Safety center',
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 0.8.h),
                        Text(
                          'Share trip status with trusted contacts anytime.',
                          style: textTheme.bodyMedium?.copyWith(
                            color: AppTheme.slate,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: AppTheme.ink,
        unselectedItemColor: AppTheme.slate,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_taxi_outlined),
            label: 'Trips',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_outlined),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}
