import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../routes/app_routes.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_card.dart';
import '../../widgets/feature_tile.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
        child: Column(
          children: [
            AppCard(
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: AppTheme.electricGreen.withOpacity(0.12),
                    child: const Icon(Icons.person_outline, color: AppTheme.ink),
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Maya Henderson',
                          style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        SizedBox(height: 0.8.h),
                        Text(
                          'Verified U.S. rider · 4.97 rating',
                          style: textTheme.bodySmall?.copyWith(color: AppTheme.slate),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.edit_outlined),
                ],
              ),
            ),
            SizedBox(height: 2.4.h),
            FeatureTile(
              title: 'Wallet',
              subtitle: 'Manage cards, passes, and credits',
              icon: Icons.account_balance_wallet_outlined,
              onTap: () => Navigator.pushNamed(context, AppRoutes.wallet),
            ),
            SizedBox(height: 1.6.h),
            FeatureTile(
              title: 'Promotions',
              subtitle: 'Apply promo codes and ride perks',
              icon: Icons.local_offer_outlined,
              onTap: () => Navigator.pushNamed(context, AppRoutes.promotions),
            ),
            SizedBox(height: 1.6.h),
            FeatureTile(
              title: 'Safety center',
              subtitle: 'Trusted contacts and ride check',
              icon: Icons.shield_outlined,
              onTap: () => Navigator.pushNamed(context, AppRoutes.safety),
            ),
            SizedBox(height: 1.6.h),
            FeatureTile(
              title: 'Settings',
              subtitle: 'Privacy, notifications, and preferences',
              icon: Icons.settings_outlined,
              onTap: () => Navigator.pushNamed(context, AppRoutes.settings),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
        selectedItemColor: AppTheme.ink,
        unselectedItemColor: AppTheme.slate,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushNamed(context, AppRoutes.home);
          } else if (index == 1) {
            Navigator.pushNamed(context, AppRoutes.trips);
          }
        },
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
