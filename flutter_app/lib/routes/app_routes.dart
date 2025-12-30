import 'package:flutter/material.dart';

import '../presentation/home_screen/home_screen.dart';
import '../presentation/activity_screen/activity_screen.dart';
import '../presentation/account_screen/account_screen.dart';
import '../presentation/messages_screen/messages_screen.dart';
import '../presentation/promotions_screen/promotions_screen.dart';
import '../presentation/safety_screen/safety_screen.dart';
import '../presentation/settings_screen/settings_screen.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/trips_screen/trips_screen.dart';
import '../presentation/wallet_screen/wallet_screen.dart';
import '../presentation/ride_booking_screen/ride_booking_screen.dart';
import '../presentation/ride_selection_screen/ride_selection_screen.dart';
import '../presentation/trip_tracking_screen/trip_tracking_screen.dart';

/// App Routes - Central routing configuration for rUber
class AppRoutes {
  AppRoutes._();

  // Core routes
  static const String initial = '/';
  static const String home = '/home';
  static const String trips = '/trips';
  static const String account = '/account';

  // Feature routes
  static const String activity = '/activity';
  static const String messages = '/messages';
  static const String safety = '/safety';
  static const String wallet = '/wallet';
  static const String promotions = '/promotions';
  static const String settings = '/settings';

  // Ride booking flow routes
  static const String rideBooking = '/ride-booking';
  static const String rideSelection = '/ride-selection';
  static const String tripTracking = '/trip-tracking';

  /// Route map for navigation
  static Map<String, WidgetBuilder> routes = {
    // Core screens
    initial: (context) => const SplashScreen(),
    home: (context) => const HomeScreen(),
    trips: (context) => const TripsScreen(),
    account: (context) => const AccountScreen(),

    // Feature screens
    activity: (context) => const ActivityScreen(),
    messages: (context) => const MessagesScreen(),
    safety: (context) => const SafetyScreen(),
    wallet: (context) => const WalletScreen(),
    promotions: (context) => const PromotionsScreen(),
    settings: (context) => const SettingsScreen(),

    // Ride booking flow
    rideBooking: (context) => const RideBookingScreen(),
    rideSelection: (context) => const RideSelectionScreen(),
    tripTracking: (context) => const TripTrackingScreen(),
  };
}
