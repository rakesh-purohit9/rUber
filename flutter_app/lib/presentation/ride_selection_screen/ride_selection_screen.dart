import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../routes/app_routes.dart';
import '../../theme/app_theme.dart';

/// Ride Selection Screen - Uber-style vehicle picker with map preview
class RideSelectionScreen extends StatefulWidget {
  const RideSelectionScreen({super.key});

  @override
  State<RideSelectionScreen> createState() => _RideSelectionScreenState();
}

class _RideSelectionScreenState extends State<RideSelectionScreen> {
  int _selectedRideIndex = 0;

  // Ride options with Uber-like data
  final List<Map<String, dynamic>> _rideOptions = [
    {
      'name': 'UberX',
      'description': 'Affordable, everyday rides',
      'eta': '4 min',
      'price': '\$12.50',
      'priceRange': '\$12-15',
      'capacity': 4,
      'icon': Icons.directions_car_filled_rounded,
      'color': AppTheme.black,
      'promotion': null,
    },
    {
      'name': 'Comfort',
      'description': 'Newer cars with extra legroom',
      'eta': '6 min',
      'price': '\$18.75',
      'priceRange': '\$17-21',
      'capacity': 4,
      'icon': Icons.airline_seat_legroom_extra_rounded,
      'color': AppTheme.comfortColor,
      'promotion': 'Popular',
    },
    {
      'name': 'UberXL',
      'description': 'Affordable rides for groups up to 6',
      'eta': '8 min',
      'price': '\$24.00',
      'priceRange': '\$22-28',
      'capacity': 6,
      'icon': Icons.airport_shuttle_rounded,
      'color': AppTheme.uberXLColor,
      'promotion': null,
    },
    {
      'name': 'Black',
      'description': 'Premium rides in luxury cars',
      'eta': '5 min',
      'price': '\$35.00',
      'priceRange': '\$32-40',
      'capacity': 4,
      'icon': Icons.local_taxi_rounded,
      'color': AppTheme.blackColor,
      'promotion': null,
    },
    {
      'name': 'Black SUV',
      'description': 'Premium SUVs for up to 6',
      'eta': '7 min',
      'price': '\$48.00',
      'priceRange': '\$45-55',
      'capacity': 6,
      'icon': Icons.directions_car_filled_rounded,
      'color': AppTheme.blackColor,
      'promotion': null,
    },
    {
      'name': 'Green',
      'description': 'Eco-friendly hybrid & electric',
      'eta': '9 min',
      'price': '\$14.00',
      'priceRange': '\$13-16',
      'capacity': 4,
      'icon': Icons.eco_rounded,
      'color': AppTheme.uberGreen,
      'promotion': 'Eco',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final selectedRide = _rideOptions[_selectedRideIndex];

    return Scaffold(
      backgroundColor: isDark ? AppTheme.black : AppTheme.gray50,
      body: Stack(
        children: [
          // Map placeholder (top half)
          _buildMapPlaceholder(isDark),

          // Bottom sheet with ride options
          _buildBottomSheet(isDark, selectedRide),

          // Top navigation bar
          _buildTopBar(isDark),
        ],
      ),
    );
  }

  Widget _buildMapPlaceholder(bool isDark) {
    return Container(
      height: 45.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? AppTheme.gray900 : AppTheme.mapBackground,
      ),
      child: Stack(
        children: [
          // Simulated map grid
          CustomPaint(
            size: Size(100.w, 45.h),
            painter: _MapGridPainter(isDark: isDark),
          ),

          // Route line
          Center(
            child: CustomPaint(
              size: Size(60.w, 30.h),
              painter: _RoutePainter(),
            ),
          ),

          // Pickup marker
          Positioned(
            top: 12.h,
            left: 25.w,
            child: _buildMarker(
              color: AppTheme.uberGreen,
              label: 'Pickup',
              isDark: isDark,
            ),
          ),

          // Destination marker
          Positioned(
            bottom: 8.h,
            right: 20.w,
            child: _buildMarker(
              color: isDark ? AppTheme.white : AppTheme.black,
              label: 'Drop-off',
              isDark: isDark,
            ),
          ),

          // Car icons on route
          Positioned(
            top: 20.h,
            left: 35.w,
            child: _buildCarMarker(isDark),
          ),
          Positioned(
            top: 18.h,
            left: 55.w,
            child: _buildCarMarker(isDark),
          ),
          Positioned(
            top: 25.h,
            left: 45.w,
            child: _buildCarMarker(isDark),
          ),
        ],
      ),
    );
  }

  Widget _buildMarker({
    required Color color,
    required String label,
    required bool isDark,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: isDark ? AppTheme.gray800 : AppTheme.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: AppTheme.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isDark ? AppTheme.white : AppTheme.black,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(
              color: isDark ? AppTheme.gray800 : AppTheme.white,
              width: 3,
            ),
            boxShadow: [
              BoxShadow(
                color: AppTheme.black.withOpacity(0.2),
                blurRadius: 4,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCarMarker(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.gray700 : AppTheme.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: AppTheme.black.withOpacity(0.1),
            blurRadius: 4,
          ),
        ],
      ),
      child: Icon(
        Icons.directions_car_rounded,
        size: 16,
        color: isDark ? AppTheme.white : AppTheme.black,
      ),
    );
  }

  Widget _buildTopBar(bool isDark) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        child: Row(
          children: [
            // Back button
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(10),
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
                  Icons.arrow_back,
                  color: isDark ? AppTheme.white : AppTheme.black,
                  size: 22,
                ),
              ),
            ),

            const Spacer(),

            // Trip info pill
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isDark ? AppTheme.gray800 : AppTheme.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.black.withOpacity(0.1),
                    blurRadius: 8,
                  ),
                ],
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
                    '12 min • 3.2 mi',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppTheme.white : AppTheme.black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomSheet(bool isDark, Map<String, dynamic> selectedRide) {
    return DraggableScrollableSheet(
      initialChildSize: 0.58,
      minChildSize: 0.45,
      maxChildSize: 0.85,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: isDark ? AppTheme.gray900 : AppTheme.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: AppTheme.black.withOpacity(0.15),
                blurRadius: 20,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: Column(
            children: [
              // Drag handle
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? AppTheme.gray600 : AppTheme.gray300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Header
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Choose a ride',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppTheme.white : AppTheme.black,
                      ),
                    ),
                    // Payment method
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isDark ? AppTheme.gray800 : AppTheme.gray100,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.credit_card_rounded,
                            size: 16,
                            color: isDark ? AppTheme.white : AppTheme.black,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '•••• 2481',
                            style: TextStyle(
                              fontSize: 13,
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

              SizedBox(height: 1.5.h),

              // Ride options list
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  itemCount: _rideOptions.length,
                  itemBuilder: (context, index) {
                    return _buildRideOption(
                      index: index,
                      ride: _rideOptions[index],
                      isSelected: index == _selectedRideIndex,
                      isDark: isDark,
                    );
                  },
                ),
              ),

              // Bottom action area
              _buildBottomAction(isDark, selectedRide),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRideOption({
    required int index,
    required Map<String, dynamic> ride,
    required bool isSelected,
    required bool isDark,
  }) {
    return GestureDetector(
      onTap: () => setState(() => _selectedRideIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? AppTheme.gray800 : AppTheme.gray100)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: isSelected
              ? Border.all(
                  color: isDark ? AppTheme.white : AppTheme.black,
                  width: 2,
                )
              : null,
        ),
        child: Row(
          children: [
            // Vehicle icon
            Container(
              width: 60,
              height: 50,
              decoration: BoxDecoration(
                color: ride['color'].withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                ride['icon'],
                color: ride['color'],
                size: 28,
              ),
            ),

            const SizedBox(width: 14),

            // Ride details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        ride['name'],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isDark ? AppTheme.white : AppTheme.black,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Icon(
                        Icons.person_outline_rounded,
                        size: 14,
                        color: AppTheme.gray500,
                      ),
                      Text(
                        '${ride['capacity']}',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppTheme.gray500,
                        ),
                      ),
                      if (ride['promotion'] != null) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: ride['promotion'] == 'Eco'
                                ? AppTheme.uberGreen.withOpacity(0.15)
                                : AppTheme.uberBlue.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            ride['promotion'],
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: ride['promotion'] == 'Eco'
                                  ? AppTheme.uberGreen
                                  : AppTheme.uberBlue,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${ride['eta']} away • ${ride['description']}',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppTheme.gray500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Price
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  ride['price'],
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppTheme.white : AppTheme.black,
                  ),
                ),
                Text(
                  ride['priceRange'],
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.gray500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomAction(bool isDark, Map<String, dynamic> selectedRide) {
    return Container(
      padding: EdgeInsets.fromLTRB(5.w, 2.h, 5.w, 3.h),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.gray900 : AppTheme.white,
        border: Border(
          top: BorderSide(
            color: isDark ? AppTheme.gray800 : AppTheme.gray200,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            // Promo code row
            GestureDetector(
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: isDark ? AppTheme.gray800 : AppTheme.gray100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.local_offer_outlined,
                      size: 20,
                      color: AppTheme.uberGreen,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Add promo code',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: isDark ? AppTheme.white : AppTheme.black,
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.chevron_right_rounded,
                      color: AppTheme.gray500,
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 1.5.h),

            // Request button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.tripTracking);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDark ? AppTheme.white : AppTheme.black,
                  foregroundColor: isDark ? AppTheme.black : AppTheme.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Request ${selectedRide['name']} • ${selectedRide['price']}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom painter for map grid
class _MapGridPainter extends CustomPainter {
  final bool isDark;

  _MapGridPainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = (isDark ? AppTheme.gray700 : AppTheme.gray300).withOpacity(0.5)
      ..strokeWidth = 0.5;

    // Draw horizontal lines
    for (double y = 0; y < size.height; y += 30) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    // Draw vertical lines
    for (double x = 0; x < size.width; x += 30) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Custom painter for route line
class _RoutePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.routeBlue
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(size.width * 0.2, size.height * 0.1);
    path.quadraticBezierTo(
      size.width * 0.5,
      size.height * 0.4,
      size.width * 0.8,
      size.height * 0.9,
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
