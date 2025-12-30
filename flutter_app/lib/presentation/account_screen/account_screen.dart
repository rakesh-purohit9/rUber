import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../routes/app_routes.dart';
import '../../theme/app_theme.dart';

/// Account Screen - Uber-style profile and settings hub
class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppTheme.black : AppTheme.gray50,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Profile header
              _buildProfileHeader(context, isDark),

              SizedBox(height: 2.h),

              // Stats row
              _buildStatsRow(isDark),

              SizedBox(height: 3.h),

              // Menu sections
              _buildMenuSection(context, isDark),

              SizedBox(height: 3.h),

              // Sign out button
              _buildSignOutButton(isDark),

              SizedBox(height: 5.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, bool isDark) {
    return Container(
      padding: EdgeInsets.fromLTRB(5.w, 2.h, 5.w, 3.h),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.gray900 : AppTheme.white,
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          // Top bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Icon(
                  Icons.arrow_back,
                  color: isDark ? AppTheme.white : AppTheme.black,
                ),
              ),
              Text(
                'Account',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppTheme.white : AppTheme.black,
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, AppRoutes.settings),
                child: Icon(
                  Icons.settings_outlined,
                  color: isDark ? AppTheme.white : AppTheme.black,
                ),
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // Profile info
          Row(
            children: [
              // Avatar
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: isDark ? AppTheme.gray700 : AppTheme.gray200,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.person_rounded,
                  size: 40,
                  color: isDark ? AppTheme.gray400 : AppTheme.gray500,
                ),
              ),

              SizedBox(width: 4.w),

              // Name and rating
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Maya Henderson',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppTheme.white : AppTheme.black,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppTheme.gray700
                                : AppTheme.gray100,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.star_rounded,
                                size: 16,
                                color: AppTheme.warning,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '4.97',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: isDark
                                      ? AppTheme.white
                                      : AppTheme.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.uberGreen.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '🇺🇸',
                                style: TextStyle(fontSize: 12),
                              ),
                              SizedBox(width: 4),
                              Text(
                                'Verified',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.uberGreen,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Edit button
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isDark ? AppTheme.gray700 : AppTheme.gray100,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.edit_outlined,
                  size: 20,
                  color: isDark ? AppTheme.white : AppTheme.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(bool isDark) {
    final stats = [
      {'value': '247', 'label': 'Trips'},
      {'value': '\$1,234', 'label': 'Spent'},
      {'value': '18', 'label': 'Saved places'},
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? AppTheme.gray900 : AppTheme.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: stats.map((stat) {
            return Column(
              children: [
                Text(
                  stat['value']!,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppTheme.white : AppTheme.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  stat['label']!,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppTheme.gray500,
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildMenuSection(BuildContext context, bool isDark) {
    final menuItems = [
      {
        'icon': Icons.account_balance_wallet_rounded,
        'title': 'Wallet',
        'subtitle': 'Payment methods, Uber Cash',
        'route': AppRoutes.wallet,
        'badge': '\$24.50',
      },
      {
        'icon': Icons.history_rounded,
        'title': 'Activity',
        'subtitle': 'Your trip history',
        'route': AppRoutes.activity,
        'badge': null,
      },
      {
        'icon': Icons.local_offer_rounded,
        'title': 'Promotions',
        'subtitle': 'Promo codes and offers',
        'route': AppRoutes.promotions,
        'badge': '2 new',
      },
      {
        'icon': Icons.shield_rounded,
        'title': 'Safety',
        'subtitle': 'Trusted contacts, emergency help',
        'route': AppRoutes.safety,
        'badge': null,
      },
      {
        'icon': Icons.chat_bubble_outline_rounded,
        'title': 'Messages',
        'subtitle': 'Support and driver messages',
        'route': AppRoutes.messages,
        'badge': '3',
      },
      {
        'icon': Icons.help_outline_rounded,
        'title': 'Help',
        'subtitle': 'Get support, report issues',
        'route': AppRoutes.messages,
        'badge': null,
      },
      {
        'icon': Icons.settings_outlined,
        'title': 'Settings',
        'subtitle': 'Privacy, notifications, accessibility',
        'route': AppRoutes.settings,
        'badge': null,
      },
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppTheme.gray900 : AppTheme.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: menuItems.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            final isLast = index == menuItems.length - 1;

            return Column(
              children: [
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => Navigator.pushNamed(
                      context,
                      item['route'] as String,
                    ),
                    borderRadius: BorderRadius.vertical(
                      top: index == 0 ? const Radius.circular(20) : Radius.zero,
                      bottom: isLast ? const Radius.circular(20) : Radius.zero,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 16,
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? AppTheme.gray800
                                  : AppTheme.gray100,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              item['icon'] as IconData,
                              color: isDark ? AppTheme.white : AppTheme.black,
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['title'] as String,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: isDark
                                        ? AppTheme.white
                                        : AppTheme.black,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  item['subtitle'] as String,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: AppTheme.gray500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (item['badge'] != null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.uberGreen.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                item['badge'] as String,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.uberGreen,
                                ),
                              ),
                            ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.chevron_right_rounded,
                            color: AppTheme.gray400,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (!isLast)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Divider(
                      height: 1,
                      color: isDark ? AppTheme.gray800 : AppTheme.gray100,
                    ),
                  ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildSignOutButton(bool isDark) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: TextButton(
        onPressed: () {},
        child: Text(
          'Sign out',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppTheme.error,
          ),
        ),
      ),
    );
  }
}
