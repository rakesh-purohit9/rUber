import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../routes/app_routes.dart';
import '../../theme/app_theme.dart';

/// Trip Tracking Screen - Live ride tracking with driver info
class TripTrackingScreen extends StatefulWidget {
  const TripTrackingScreen({super.key});

  @override
  State<TripTrackingScreen> createState() => _TripTrackingScreenState();
}

class _TripTrackingScreenState extends State<TripTrackingScreen>
    with TickerProviderStateMixin {
  // Trip states
  TripState _tripState = TripState.searching;
  int _searchDots = 0;
  Timer? _searchTimer;
  Timer? _etaTimer;
  int _etaMinutes = 4;

  // Animation controllers
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  // Driver info
  final Map<String, dynamic> _driverInfo = {
    'name': 'Michael',
    'rating': 4.92,
    'trips': 2847,
    'car': 'Tesla Model 3',
    'color': 'White',
    'plate': '7ABC123',
    'photo': null,
  };

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _startSearching();
  }

  void _initAnimations() {
    // Pulse animation for searching
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _pulseController.repeat(reverse: true);

    // Slide animation for bottom sheet
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
    );

    _slideController.forward();
  }

  void _startSearching() {
    // Animate search dots
    _searchTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (mounted) {
        setState(() {
          _searchDots = (_searchDots + 1) % 4;
        });
      }
    });

    // Simulate finding a driver
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        _searchTimer?.cancel();
        _pulseController.stop();
        setState(() => _tripState = TripState.driverAssigned);

        // Start ETA countdown
        _startEtaCountdown();
      }
    });
  }

  void _startEtaCountdown() {
    _etaTimer = Timer.periodic(const Duration(seconds: 15), (timer) {
      if (mounted && _etaMinutes > 1) {
        setState(() => _etaMinutes--);
      } else {
        timer.cancel();
        if (mounted) {
          setState(() => _tripState = TripState.arriving);
        }
      }
    });
  }

  @override
  void dispose() {
    _searchTimer?.cancel();
    _etaTimer?.cancel();
    _pulseController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppTheme.black : AppTheme.gray50,
      body: Stack(
        children: [
          // Map view
          _buildMapView(isDark),

          // Top bar
          _buildTopBar(isDark),

          // Bottom sheet
          _buildBottomSheet(isDark),
        ],
      ),
    );
  }

  Widget _buildMapView(bool isDark) {
    return Container(
      height: 55.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? AppTheme.gray900 : AppTheme.mapBackground,
      ),
      child: Stack(
        children: [
          // Grid lines
          CustomPaint(
            size: Size(100.w, 55.h),
            painter: _MapGridPainter(isDark: isDark),
          ),

          // Route visualization
          if (_tripState != TripState.searching)
            Center(
              child: CustomPaint(
                size: Size(70.w, 40.h),
                painter: _RoutePainter(progress: _getRouteProgress()),
              ),
            ),

          // Pickup point
          Positioned(
            top: 15.h,
            left: 30.w,
            child: _buildLocationPin(
              color: AppTheme.uberGreen,
              label: 'Pickup',
              isDark: isDark,
            ),
          ),

          // Destination point
          Positioned(
            bottom: 10.h,
            right: 25.w,
            child: _buildLocationPin(
              color: isDark ? AppTheme.white : AppTheme.black,
              label: 'Drop-off',
              isDark: isDark,
            ),
          ),

          // Driver car (animated)
          if (_tripState != TripState.searching) _buildAnimatedCar(isDark),

          // Searching pulse effect
          if (_tripState == TripState.searching) _buildSearchingOverlay(isDark),
        ],
      ),
    );
  }

  Widget _buildSearchingOverlay(bool isDark) {
    return Center(
      child: AnimatedBuilder(
        animation: _pulseController,
        builder: (context, child) {
          return Container(
            width: 30.w * _pulseAnimation.value,
            height: 30.w * _pulseAnimation.value,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.uberGreen.withOpacity(0.2),
              border: Border.all(
                color: AppTheme.uberGreen.withOpacity(0.5),
                width: 2,
              ),
            ),
            child: Center(
              child: Container(
                width: 15.w,
                height: 15.w,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.uberGreen,
                ),
                child: const Icon(
                  Icons.search_rounded,
                  color: AppTheme.white,
                  size: 28,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAnimatedCar(bool isDark) {
    final progress = _getRouteProgress();
    final topPosition = 15.h + (30.h * progress);
    final leftPosition = 30.w + (15.w * progress);

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 500),
      top: topPosition,
      left: leftPosition,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isDark ? AppTheme.gray800 : AppTheme.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppTheme.black.withOpacity(0.2),
              blurRadius: 8,
            ),
          ],
        ),
        child: Icon(
          Icons.directions_car_rounded,
          color: isDark ? AppTheme.white : AppTheme.black,
          size: 24,
        ),
      ),
    );
  }

  double _getRouteProgress() {
    switch (_tripState) {
      case TripState.searching:
        return 0.0;
      case TripState.driverAssigned:
        return 0.3;
      case TripState.arriving:
        return 0.7;
      case TripState.inProgress:
        return 1.0;
    }
  }

  Widget _buildLocationPin({
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
          ),
        ),
      ],
    );
  }

  Widget _buildTopBar(bool isDark) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Back/Cancel button
            GestureDetector(
              onTap: () => _showCancelDialog(isDark),
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
                  Icons.close_rounded,
                  color: isDark ? AppTheme.white : AppTheme.black,
                  size: 22,
                ),
              ),
            ),

            // Share trip button
            if (_tripState != TripState.searching)
              GestureDetector(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
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
                        Icons.share_outlined,
                        size: 18,
                        color: isDark ? AppTheme.white : AppTheme.black,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Share trip',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: isDark ? AppTheme.white : AppTheme.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomSheet(bool isDark) {
    return SlideTransition(
      position: _slideAnimation,
      child: DraggableScrollableSheet(
        initialChildSize: 0.48,
        minChildSize: 0.35,
        maxChildSize: 0.75,
        builder: (context, scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: isDark ? AppTheme.gray900 : AppTheme.white,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.black.withOpacity(0.15),
                  blurRadius: 20,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: ListView(
              controller: scrollController,
              padding: EdgeInsets.zero,
              children: [
                // Drag handle
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(top: 12, bottom: 8),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: isDark ? AppTheme.gray600 : AppTheme.gray300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),

                // Content based on state
                if (_tripState == TripState.searching)
                  _buildSearchingContent(isDark)
                else
                  _buildDriverContent(isDark),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSearchingContent(bool isDark) {
    final dots = '.' * _searchDots;
    final spaces = ' ' * (3 - _searchDots);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
      child: Column(
        children: [
          // Searching animation
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: AppTheme.uberGreen.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(
                  color: AppTheme.uberGreen,
                  strokeWidth: 3,
                ),
              ),
            ),
          ),

          SizedBox(height: 2.h),

          Text(
            'Finding your driver$dots$spaces',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: isDark ? AppTheme.white : AppTheme.black,
            ),
          ),

          SizedBox(height: 1.h),

          Text(
            'We\'re looking for nearby drivers',
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.gray500,
            ),
          ),

          SizedBox(height: 3.h),

          // Trip summary
          _buildTripSummary(isDark),

          SizedBox(height: 3.h),

          // Cancel button
          TextButton(
            onPressed: () => _showCancelDialog(isDark),
            child: Text(
              'Cancel search',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppTheme.error,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDriverContent(bool isDark) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: Column(
        children: [
          // ETA Header
          _buildEtaHeader(isDark),

          SizedBox(height: 2.h),

          // Driver info card
          _buildDriverCard(isDark),

          SizedBox(height: 2.h),

          // Action buttons
          _buildActionButtons(isDark),

          SizedBox(height: 2.h),

          // Trip summary
          _buildTripSummary(isDark),

          SizedBox(height: 2.h),

          // Safety features
          _buildSafetySection(isDark),
        ],
      ),
    );
  }

  Widget _buildEtaHeader(bool isDark) {
    String statusText;
    String etaText;

    switch (_tripState) {
      case TripState.driverAssigned:
        statusText = 'Driver is on the way';
        etaText = '$_etaMinutes min';
        break;
      case TripState.arriving:
        statusText = 'Driver is arriving';
        etaText = 'Now';
        break;
      case TripState.inProgress:
        statusText = 'Enjoy your ride';
        etaText = '12 min';
        break;
      default:
        statusText = '';
        etaText = '';
    }

    return Column(
      children: [
        Text(
          statusText,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: isDark ? AppTheme.white : AppTheme.black,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppTheme.uberGreen.withOpacity(0.15),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            etaText,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.uberGreen,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDriverCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.gray800 : AppTheme.gray100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Driver photo
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: isDark ? AppTheme.gray700 : AppTheme.gray300,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.person_rounded,
                  size: 32,
                  color: isDark ? AppTheme.gray400 : AppTheme.gray500,
                ),
              ),

              const SizedBox(width: 14),

              // Driver info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          _driverInfo['name'],
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: isDark ? AppTheme.white : AppTheme.black,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.star_rounded,
                          size: 16,
                          color: AppTheme.warning,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          '${_driverInfo['rating']}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: isDark ? AppTheme.white : AppTheme.black,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${_driverInfo['trips']} trips',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppTheme.gray500,
                      ),
                    ),
                  ],
                ),
              ),

              // Message icon
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isDark ? AppTheme.gray700 : AppTheme.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.chat_bubble_outline_rounded,
                  color: isDark ? AppTheme.white : AppTheme.black,
                  size: 22,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Car info
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? AppTheme.gray700 : AppTheme.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.directions_car_rounded,
                  color: isDark ? AppTheme.white : AppTheme.black,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${_driverInfo['color']} ${_driverInfo['car']}',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: isDark ? AppTheme.white : AppTheme.black,
                        ),
                      ),
                      Text(
                        _driverInfo['plate'],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: isDark ? AppTheme.white : AppTheme.black,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(bool isDark) {
    return Row(
      children: [
        Expanded(
          child: _buildActionButton(
            icon: Icons.phone_outlined,
            label: 'Call',
            isDark: isDark,
            onTap: () {},
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildActionButton(
            icon: Icons.chat_bubble_outline_rounded,
            label: 'Message',
            isDark: isDark,
            onTap: () {},
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildActionButton(
            icon: Icons.shield_outlined,
            label: 'Safety',
            isDark: isDark,
            onTap: () {},
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isDark ? AppTheme.gray800 : AppTheme.gray100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isDark ? AppTheme.white : AppTheme.black,
              size: 24,
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isDark ? AppTheme.white : AppTheme.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTripSummary(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.gray800 : AppTheme.gray100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _buildSummaryRow(
            icon: Icons.circle,
            iconColor: AppTheme.uberGreen,
            iconSize: 10,
            text: '1234 Oak Street',
            isDark: isDark,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Container(
              width: 2,
              height: 24,
              color: isDark ? AppTheme.gray600 : AppTheme.gray300,
            ),
          ),
          _buildSummaryRow(
            icon: Icons.circle,
            iconColor: isDark ? AppTheme.white : AppTheme.black,
            iconSize: 10,
            text: 'San Francisco International Airport',
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow({
    required IconData icon,
    required Color iconColor,
    required double iconSize,
    required String text,
    required bool isDark,
  }) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: iconSize),
        const SizedBox(width: 14),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: isDark ? AppTheme.white : AppTheme.black,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildSafetySection(bool isDark) {
    return Container(
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
              color: AppTheme.uberBlue.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.shield_rounded,
              color: AppTheme.uberBlue,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Share your trip status',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppTheme.white : AppTheme.black,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Let friends and family track your ride',
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
            color: AppTheme.gray500,
          ),
        ],
      ),
    );
  }

  void _showCancelDialog(bool isDark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppTheme.gray900 : AppTheme.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.all(5.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Cancel ride?',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppTheme.white : AppTheme.black,
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  _tripState == TripState.searching
                      ? 'Are you sure you want to cancel your search?'
                      : 'You may be charged a cancellation fee.',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.gray500,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 3.h),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Keep ride'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.popUntil(
                            context,
                            (route) => route.settings.name == AppRoutes.home,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.error,
                        ),
                        child: const Text('Cancel ride'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

enum TripState {
  searching,
  driverAssigned,
  arriving,
  inProgress,
}

class _MapGridPainter extends CustomPainter {
  final bool isDark;

  _MapGridPainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = (isDark ? AppTheme.gray700 : AppTheme.gray300).withOpacity(0.5)
      ..strokeWidth = 0.5;

    for (double y = 0; y < size.height; y += 30) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    for (double x = 0; x < size.width; x += 30) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _RoutePainter extends CustomPainter {
  final double progress;

  _RoutePainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.routeBlue
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(size.width * 0.15, size.height * 0.1);
    path.quadraticBezierTo(
      size.width * 0.5,
      size.height * 0.5,
      size.width * 0.85,
      size.height * 0.9,
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _RoutePainter oldDelegate) =>
      oldDelegate.progress != progress;
}
