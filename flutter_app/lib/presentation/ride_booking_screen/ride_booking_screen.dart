import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../routes/app_routes.dart';
import '../../theme/app_theme.dart';

/// Ride Booking Screen - Uber-style destination picker with map
class RideBookingScreen extends StatefulWidget {
  const RideBookingScreen({super.key});

  @override
  State<RideBookingScreen> createState() => _RideBookingScreenState();
}

class _RideBookingScreenState extends State<RideBookingScreen> {
  final TextEditingController _pickupController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  final FocusNode _pickupFocus = FocusNode();
  final FocusNode _destinationFocus = FocusNode();

  bool _isPickupFocused = false;
  bool _isDestinationFocused = true;

  // Sample saved places
  final List<Map<String, dynamic>> _savedPlaces = [
    {
      'icon': Icons.home_rounded,
      'title': 'Home',
      'subtitle': '1234 Oak Street, San Francisco, CA',
      'type': 'saved',
    },
    {
      'icon': Icons.work_rounded,
      'title': 'Work',
      'subtitle': '500 Market Street, San Francisco, CA',
      'type': 'saved',
    },
  ];

  // Sample recent places
  final List<Map<String, dynamic>> _recentPlaces = [
    {
      'icon': Icons.access_time_rounded,
      'title': 'San Francisco International Airport',
      'subtitle': 'SFO, San Francisco, CA 94128',
      'type': 'recent',
    },
    {
      'icon': Icons.access_time_rounded,
      'title': 'Golden Gate Park',
      'subtitle': '501 Stanyan St, San Francisco, CA',
      'type': 'recent',
    },
    {
      'icon': Icons.access_time_rounded,
      'title': 'Union Square',
      'subtitle': '333 Post St, San Francisco, CA 94108',
      'type': 'recent',
    },
    {
      'icon': Icons.access_time_rounded,
      'title': 'Fisherman\'s Wharf',
      'subtitle': 'Beach St & The Embarcadero, SF',
      'type': 'recent',
    },
  ];

  @override
  void initState() {
    super.initState();
    _pickupController.text = 'Current location';

    _pickupFocus.addListener(() {
      setState(() => _isPickupFocused = _pickupFocus.hasFocus);
    });

    _destinationFocus.addListener(() {
      setState(() => _isDestinationFocused = _destinationFocus.hasFocus);
    });

    // Auto-focus destination field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _destinationFocus.requestFocus();
    });
  }

  @override
  void dispose() {
    _pickupController.dispose();
    _destinationController.dispose();
    _pickupFocus.dispose();
    _destinationFocus.dispose();
    super.dispose();
  }

  void _selectPlace(Map<String, dynamic> place) {
    setState(() {
      _destinationController.text = place['title'];
    });

    // Navigate to ride selection
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        Navigator.pushNamed(context, AppRoutes.rideSelection);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppTheme.black : AppTheme.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header with back button and input fields
            _buildHeader(isDark),

            // Divider
            Container(
              height: 1,
              color: isDark ? AppTheme.gray800 : AppTheme.gray200,
            ),

            // Places list
            Expanded(
              child: _buildPlacesList(isDark),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Container(
      padding: EdgeInsets.fromLTRB(4.w, 1.h, 4.w, 2.h),
      child: Column(
        children: [
          // Top row with back button
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Icons.arrow_back,
                  color: isDark ? AppTheme.white : AppTheme.black,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 12),
              Text(
                'Plan your ride',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppTheme.white : AppTheme.black,
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Location inputs
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Timeline indicator
              _buildTimelineIndicator(isDark),

              SizedBox(width: 3.w),

              // Input fields
              Expanded(
                child: Column(
                  children: [
                    // Pickup input
                    _buildLocationInput(
                      controller: _pickupController,
                      focusNode: _pickupFocus,
                      hint: 'Pickup location',
                      isFocused: _isPickupFocused,
                      isDark: isDark,
                      isPickup: true,
                    ),

                    SizedBox(height: 1.2.h),

                    // Destination input
                    _buildLocationInput(
                      controller: _destinationController,
                      focusNode: _destinationFocus,
                      hint: 'Where to?',
                      isFocused: _isDestinationFocused,
                      isDark: isDark,
                      isPickup: false,
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 1.5.h),

          // Quick action chips
          _buildQuickActions(isDark),
        ],
      ),
    );
  }

  Widget _buildTimelineIndicator(bool isDark) {
    return Padding(
      padding: EdgeInsets.only(top: 1.5.h),
      child: Column(
        children: [
          // Pickup dot (green)
          Container(
            width: 10,
            height: 10,
            decoration: const BoxDecoration(
              color: AppTheme.uberGreen,
              shape: BoxShape.circle,
            ),
          ),

          // Connecting line
          Container(
            width: 2,
            height: 4.5.h,
            margin: const EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(
              color: isDark ? AppTheme.gray600 : AppTheme.gray300,
              borderRadius: BorderRadius.circular(1),
            ),
          ),

          // Destination dot (black/white)
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: isDark ? AppTheme.white : AppTheme.black,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationInput({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String hint,
    required bool isFocused,
    required bool isDark,
    required bool isPickup,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppTheme.gray800 : AppTheme.gray100,
        borderRadius: BorderRadius.circular(8),
        border: isFocused
            ? Border.all(
                color: isDark ? AppTheme.white : AppTheme.black,
                width: 2,
              )
            : null,
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: isDark ? AppTheme.white : AppTheme.black,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: AppTheme.gray500,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
                  onPressed: () {
                    controller.clear();
                    setState(() {});
                  },
                  icon: Icon(
                    Icons.close_rounded,
                    color: AppTheme.gray500,
                    size: 20,
                  ),
                )
              : null,
        ),
        onChanged: (value) => setState(() {}),
      ),
    );
  }

  Widget _buildQuickActions(bool isDark) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildChip(
            icon: Icons.schedule_rounded,
            label: 'Leave now',
            isDark: isDark,
            isSelected: true,
          ),
          SizedBox(width: 2.w),
          _buildChip(
            icon: Icons.person_outline_rounded,
            label: 'For me',
            isDark: isDark,
          ),
          SizedBox(width: 2.w),
          _buildChip(
            icon: Icons.map_outlined,
            label: 'Set on map',
            isDark: isDark,
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildChip({
    required IconData icon,
    required String label,
    required bool isDark,
    bool isSelected = false,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? AppTheme.white : AppTheme.black)
              : (isDark ? AppTheme.gray800 : AppTheme.gray100),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected
                  ? (isDark ? AppTheme.black : AppTheme.white)
                  : (isDark ? AppTheme.white : AppTheme.black),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isSelected
                    ? (isDark ? AppTheme.black : AppTheme.white)
                    : (isDark ? AppTheme.white : AppTheme.black),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlacesList(bool isDark) {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      children: [
        // Saved places section
        if (_savedPlaces.isNotEmpty) ...[
          _buildSectionTitle('Saved places', isDark),
          SizedBox(height: 1.h),
          ..._savedPlaces.map((place) => _buildPlaceItem(place, isDark)),
          SizedBox(height: 2.h),
        ],

        // Add saved place button
        _buildAddPlaceButton(isDark),
        SizedBox(height: 3.h),

        // Recent places section
        if (_recentPlaces.isNotEmpty) ...[
          _buildSectionTitle('Recent', isDark),
          SizedBox(height: 1.h),
          ..._recentPlaces.map((place) => _buildPlaceItem(place, isDark)),
        ],
      ],
    );
  }

  Widget _buildSectionTitle(String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: isDark ? AppTheme.gray400 : AppTheme.gray600,
        ),
      ),
    );
  }

  Widget _buildPlaceItem(Map<String, dynamic> place, bool isDark) {
    final bool isSaved = place['type'] == 'saved';

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _selectPlace(place),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
          child: Row(
            children: [
              // Icon
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: isDark ? AppTheme.gray800 : AppTheme.gray100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  place['icon'],
                  color: isSaved
                      ? AppTheme.uberGreen
                      : (isDark ? AppTheme.gray400 : AppTheme.gray600),
                  size: 22,
                ),
              ),

              const SizedBox(width: 14),

              // Text content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      place['title'],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: isDark ? AppTheme.white : AppTheme.black,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      place['subtitle'],
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
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
    );
  }

  Widget _buildAddPlaceButton(bool isDark) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: isDark ? AppTheme.gray800 : AppTheme.gray100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.add_rounded,
                  color: isDark ? AppTheme.white : AppTheme.black,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              Text(
                'Add a new place',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: isDark ? AppTheme.white : AppTheme.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
