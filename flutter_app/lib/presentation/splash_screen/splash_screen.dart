import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../routes/app_routes.dart';
import '../../theme/app_theme.dart';

/// rUber Splash Screen - Uber-inspired animated launch experience
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // Animation Controllers
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _pulseController;
  late AnimationController _fadeController;

  // Animations
  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;
  late Animation<Offset> _textSlide;
  late Animation<double> _textOpacity;
  late Animation<double> _pulseAnimation;
  late Animation<double> _fadeOut;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimationSequence();
  }

  void _initializeAnimations() {
    // Logo animation (scale + fade in)
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _logoScale = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: Curves.easeOutBack,
      ),
    );

    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    // Text animation (slide up + fade in)
    _textController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _textSlide = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _textController,
        curve: Curves.easeOutCubic,
      ),
    );

    _textOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _textController,
        curve: Curves.easeOut,
      ),
    );

    // Pulse animation for loading indicator
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );

    // Fade out animation
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _fadeOut = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _fadeController,
        curve: Curves.easeOut,
      ),
    );
  }

  void _startAnimationSequence() async {
    // Set status bar style
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    // Start logo animation
    await Future.delayed(const Duration(milliseconds: 200));
    _logoController.forward();

    // Start text animation after logo
    await Future.delayed(const Duration(milliseconds: 400));
    _textController.forward();

    // Start pulse animation
    await Future.delayed(const Duration(milliseconds: 300));
    _pulseController.repeat(reverse: true);

    // Wait and then navigate
    await Future.delayed(const Duration(milliseconds: 1800));
    _pulseController.stop();

    // Fade out and navigate
    await _fadeController.forward();

    if (mounted) {
      Navigator.of(context).pushReplacementNamed(AppRoutes.home);
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _pulseController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _fadeController,
        builder: (context, child) {
          return Opacity(
            opacity: _fadeOut.value,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                color: AppTheme.black,
              ),
              child: Stack(
                children: [
                  // Animated gradient background
                  _buildAnimatedBackground(),

                  // Main content
                  SafeArea(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      child: Column(
                        children: [
                          const Spacer(flex: 3),

                          // Logo Section
                          _buildLogoSection(),

                          SizedBox(height: 4.h),

                          // App Name and Tagline
                          _buildTextSection(),

                          const Spacer(flex: 2),

                          // Loading indicator
                          _buildLoadingIndicator(),

                          SizedBox(height: 6.h),

                          // Footer
                          _buildFooter(),

                          SizedBox(height: 3.h),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAnimatedBackground() {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.center,
              radius: 1.5 + (_pulseAnimation.value * 0.3),
              colors: [
                AppTheme.gray900.withOpacity(0.8),
                AppTheme.black,
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLogoSection() {
    return AnimatedBuilder(
      animation: _logoController,
      builder: (context, child) {
        return Opacity(
          opacity: _logoOpacity.value,
          child: Transform.scale(
            scale: _logoScale.value,
            child: Container(
              width: 28.w,
              height: 28.w,
              decoration: BoxDecoration(
                color: AppTheme.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.white.withOpacity(0.1),
                    blurRadius: 40,
                    spreadRadius: 10,
                  ),
                ],
              ),
              child: Center(
                child: _buildUberLogo(),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildUberLogo() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Custom Uber-style "r" logo
        Text(
          'r',
          style: TextStyle(
            fontSize: 14.w,
            fontWeight: FontWeight.w800,
            color: AppTheme.black,
            height: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildTextSection() {
    return SlideTransition(
      position: _textSlide,
      child: FadeTransition(
        opacity: _textOpacity,
        child: Column(
          children: [
            // App Name
            const Text(
              'rUber',
              style: TextStyle(
                fontSize: 42,
                fontWeight: FontWeight.w700,
                color: AppTheme.white,
                letterSpacing: -1,
              ),
            ),
            SizedBox(height: 1.5.h),
            // Tagline
            const Text(
              'Premium rides for U.S. travelers',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: AppTheme.gray400,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return Column(
          children: [
            // Animated loading dots
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                final delay = index * 0.2;
                final value = ((_pulseAnimation.value + delay) % 1.0);
                final opacity = (1 - (value - 0.5).abs() * 2).clamp(0.3, 1.0);

                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: AppTheme.uberGreen.withOpacity(opacity),
                      shape: BoxShape.circle,
                    ),
                  ),
                );
              }),
            ),
            SizedBox(height: 2.h),
            const Text(
              'Setting up your ride experience...',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: AppTheme.gray500,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        // US Only Badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppTheme.gray800,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppTheme.gray700,
              width: 1,
            ),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '🇺🇸',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(width: 8),
              Text(
                'Available in United States',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.gray300,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 2.h),
        // Copyright
        const Text(
          '© 2024 rUber Technologies Inc.',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: AppTheme.gray600,
          ),
        ),
      ],
    );
  }
}
