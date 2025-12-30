import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../routes/app_routes.dart';
import '../../theme/app_theme.dart';

/// Home Screen - Uber-style main dashboard with map and services
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedNavIndex = 0;

  // Recent locations
  final List<Map<String, dynamic>> _recentLocations = [
    {
      'icon': Icons.access_time_rounded,
      'title': 'San Francisco International Airport',
      'subtitle': 'SFO, California',
    },
    {
      'icon': Icons.access_time_rounded,
      'title': 'Golden Gate Park',
      'subtitle': 'San Francisco, CA',
    },
  ];

  // Saved places
  final List<Map<String, dynamic>> _savedPlaces = [
    {
      'icon': Icons.home_rounded,
      'title': 'Home',
      'subtitle': 'Add home address',
      'hasAddress': false,
    },
    {
      'icon': Icons.work_rounded,
      'title': 'Work',
      'subtitle': 'Add work address',
      'hasAddress': false,
    },
  ];

  // Service options
  final List<Map<String, dynamic>> _services = [
    {
      'icon': Icons.directions_car_filled_rounded,
      'title': 'Ride',
      'color': AppTheme.black,
    },
    {
      'icon': Icons.schedule_rounded,
      'title': 'Reserve',
      'color': AppTheme.black,
    },
    {
      'icon': Icons.two_wheeler_rounded,
      'title': 'Rentals',
      'color': AppTheme.black,
    },
  ];

  // Promotions
  final List<Map<String, dynamic>> _promotions = [
    {
      'title': 'Get 20% off your next 3 rides',
      'subtitle': 'Use code SAVE20 at checkout',
      'color': AppTheme.uberGreen,
      'icon': Icons.local_offer_rounded,
    },
    {
      'title': 'Refer friends, get \$15',
      'subtitle': 'Share your code and earn credits',
      'color': AppTheme.uberBlue,
      'icon': Icons.people_rounded,
    },
  ];

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppTheme.black : AppTheme.white,
      body: Stack(
        children: [
          // Map background (top portion)
          _buildMapBackground(isDark),

          // Main content
          SafeArea(
            child: Column(
              children: [
                // Top section with search and actions
                _buildTopSection(isDark),

                // Scrollable content
                Expanded(
                  child: _buildScrollableContent(isDark),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavBar(isDark),
    );
  }

  Widget _buildMapBackground(bool isDark) {
    return Container(
      height: 32.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? AppTheme.gray900 : AppTheme.mapBackground,
      ),
      child: Stack(
        children: [
          // Grid pattern
          CustomPaint(
            size: Size(100.w, 32.h),
            painter: _MapGridPainter(isDark: isDark),
          ),

          // Gradient overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  (isDark ? AppTheme.black : AppTheme.white).withOpacity(0.8),
                  isDark ? AppTheme.black : AppTheme.white,
                ],
                stops: const [0.0, 0.7, 1.0],
              ),
            ),
          ),

          // Current location marker
          Positioned(
            top: 15.h,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.uberBlue.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: const BoxDecoration(
                    color: AppTheme.uberBlue,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopSection(bool isDark) {
    return Padding(
      padding: EdgeInsets.fromLTRB(4.w, 1.h, 4.w, 0),
      child: Column(
        children: [
          // Top row with greeting and profile
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Greeting
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getGreeting(),
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? AppTheme.gray400 : AppTheme.gray600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Maya',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppTheme.white : AppTheme.black,
                    ),
                  ),
                ],
              ),

              // Profile button
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, AppRoutes.account),
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: isDark ? AppTheme.gray800 : AppTheme.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.black.withOpacity(0.1),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.person_rounded,
                    color: isDark ? AppTheme.white : AppTheme.black,
                    size: 24,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Search bar
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, AppRoutes.rideBooking),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: isDark ? AppTheme.gray800 : AppTheme.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.black.withOpacity(0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppTheme.uberGreen,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      'Where to?',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppTheme.white : AppTheme.black,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isDark ? AppTheme.gray700 : AppTheme.gray100,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.schedule_rounded,
                          size: 16,
                          color: isDark ? AppTheme.white : AppTheme.black,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Now',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: isDark ? AppTheme.white : AppTheme.black,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: 18,
                          color: isDark ? AppTheme.gray400 : AppTheme.gray600,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScrollableContent(bool isDark) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 2.h),

          // Services row
          _buildServicesRow(isDark),

          SizedBox(height: 3.h),

          // Saved places
          _buildSavedPlaces(isDark),

          SizedBox(height: 3.h),

          // Recent locations
          _buildRecentLocations(isDark),

          SizedBox(height: 3.h),

          // Promotions
          _buildPromotions(isDark),

          SizedBox(height: 3.h),

          // Safety banner
          _buildSafetyBanner(isDark),

          SizedBox(height: 3.h),

          // Quick links
          _buildQuickLinks(isDark),

          SizedBox(height: 10.h),
        ],
      ),
    );
  }

  Widget _buildServicesRow(bool isDark) {
    return Container(
      height: 110,
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Row(
        children: _services.asMap().entries.map((entry) {
          final index = entry.key;
          final service = entry.value;
          final isLast = index == _services.length - 1;

          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: isLast ? 0 : 3.w),
              child: GestureDetector(
                onTap: () {
                  if (service['title'] == 'Ride') {
                    Navigator.pushNamed(context, AppRoutes.rideBooking);
                  } else if (service['title'] == 'Reserve') {
                    Navigator.pushNamed(context, AppRoutes.trips);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isDark ? AppTheme.gray800 : AppTheme.gray100,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppTheme.gray700
                              : AppTheme.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          service['icon'],
                          color: isDark ? AppTheme.white : service['color'],
                          size: 26,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        service['title'],
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isDark ? AppTheme.white : AppTheme.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSavedPlaces(bool isDark) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Saved places', isDark),
          SizedBox(height: 1.5.h),
          Row(
            children: _savedPlaces.map((place) {
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: place == _savedPlaces.last ? 0 : 3.w,
                  ),
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark ? AppTheme.gray800 : AppTheme.gray100,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? AppTheme.gray700
                                  : AppTheme.white,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              place['icon'],
                              color: isDark
                                  ? AppTheme.white
                                  : AppTheme.black,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  place['title'],
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: isDark
                                        ? AppTheme.white
                                        : AppTheme.black,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  place['subtitle'],
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppTheme.gray500,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentLocations(bool isDark) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Recent', isDark),
          SizedBox(height: 1.h),
          ..._recentLocations.map((location) {
            return Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => Navigator.pushNamed(context, AppRoutes.rideBooking),
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
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
                          location['icon'],
                          color: isDark ? AppTheme.gray400 : AppTheme.gray600,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              location['title'],
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: isDark
                                    ? AppTheme.white
                                    : AppTheme.black,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              location['subtitle'],
                              style: TextStyle(
                                fontSize: 13,
                                color: AppTheme.gray500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.chevron_right_rounded,
                        color: AppTheme.gray400,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildPromotions(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: _buildSectionHeader('Offers for you', isDark),
        ),
        SizedBox(height: 1.5.h),
        SizedBox(
          height: 130,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            itemCount: _promotions.length,
            itemBuilder: (context, index) {
              final promo = _promotions[index];
              return Container(
                width: 75.w,
                margin: EdgeInsets.only(
                  right: index < _promotions.length - 1 ? 3.w : 0,
                ),
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      promo['color'].withOpacity(isDark ? 0.3 : 0.15),
                      promo['color'].withOpacity(isDark ? 0.1 : 0.05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: promo['color'].withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            promo['title'],
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: isDark ? AppTheme.white : AppTheme.black,
                            ),
                            maxLines: 2,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            promo['subtitle'],
                            style: TextStyle(
                              fontSize: 13,
                              color: AppTheme.gray500,
                            ),
                            maxLines: 2,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 14),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: promo['color'].withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        promo['icon'],
                        color: promo['color'],
                        size: 28,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSafetyBanner(bool isDark) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: GestureDetector(
        onTap: () => Navigator.pushNamed(context, AppRoutes.safety),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: isDark ? AppTheme.gray800 : AppTheme.gray100,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.uberBlue.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.shield_rounded,
                  color: AppTheme.uberBlue,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Safety Center',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppTheme.white : AppTheme.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Share your trip, emergency help, and more',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppTheme.gray500,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: AppTheme.gray400,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickLinks(bool isDark) {
    final links = [
      {'icon': Icons.history_rounded, 'title': 'Activity', 'route': AppRoutes.activity},
      {'icon': Icons.account_balance_wallet_rounded, 'title': 'Wallet', 'route': AppRoutes.wallet},
      {'icon': Icons.local_offer_rounded, 'title': 'Promos', 'route': AppRoutes.promotions},
      {'icon': Icons.help_outline_rounded, 'title': 'Help', 'route': AppRoutes.messages},
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('More', isDark),
          SizedBox(height: 1.5.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: links.map((link) {
              return GestureDetector(
                onTap: () => Navigator.pushNamed(context, link['route'] as String),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: isDark ? AppTheme.gray800 : AppTheme.gray100,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        link['icon'] as IconData,
                        color: isDark ? AppTheme.white : AppTheme.black,
                        size: 24,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      link['title'] as String,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: isDark ? AppTheme.gray400 : AppTheme.gray600,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, bool isDark) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: isDark ? AppTheme.white : AppTheme.black,
      ),
    );
  }

  Widget _buildBottomNavBar(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppTheme.gray900 : AppTheme.white,
        boxShadow: [
          BoxShadow(
            color: AppTheme.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Container(
          height: 65,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                icon: Icons.home_rounded,
                label: 'Home',
                index: 0,
                isDark: isDark,
              ),
              _buildNavItem(
                icon: Icons.receipt_long_rounded,
                label: 'Activity',
                index: 1,
                isDark: isDark,
              ),
              _buildNavItem(
                icon: Icons.account_circle_rounded,
                label: 'Account',
                index: 2,
                isDark: isDark,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
    required bool isDark,
  }) {
    final isSelected = _selectedNavIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() => _selectedNavIndex = index);
        if (index == 1) {
          Navigator.pushNamed(context, AppRoutes.activity);
        } else if (index == 2) {
          Navigator.pushNamed(context, AppRoutes.account);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected
                  ? (isDark ? AppTheme.white : AppTheme.black)
                  : AppTheme.gray500,
              size: 26,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected
                    ? (isDark ? AppTheme.white : AppTheme.black)
                    : AppTheme.gray500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }
}

class _MapGridPainter extends CustomPainter {
  final bool isDark;

  _MapGridPainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = (isDark ? AppTheme.gray700 : AppTheme.gray300).withOpacity(0.4)
      ..strokeWidth = 0.5;

    for (double y = 0; y < size.height; y += 25) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    for (double x = 0; x < size.width; x += 25) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
