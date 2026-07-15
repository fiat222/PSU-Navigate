import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Noto Sans Thai',
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.campus,
        primary: AppColors.campus,
        surface: Colors.white,
      ),
      scaffoldBackgroundColor: AppColors.paper,
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppLayout.radiusMd),
          ),
        ),
      ),
    );
  }
}

class AppLayout {
  AppLayout._();

  static const double mobileBreakpoint = 600;
  static const double desktopBreakpoint = 900;

  static const double radiusSm = 6;
  static const double radiusMd = 8;
  static const double radiusLg = 12;
  static const double radiusPill = 999;

  static const double spaceXs = 4;
  static const double spaceSm = 8;
  static const double spaceMd = 12;
  static const double spaceLg = 16;
  static const double spaceXl = 22;
  static const double spaceXxl = 28;

  static const double navItemHeightMobile = 52;
  static const double navItemHeightDesktop = 68;
  static const double navRailWidth = 92;

  static DeviceType deviceFor(double width) {
    if (width >= desktopBreakpoint) return DeviceType.desktop;
    if (width >= mobileBreakpoint) return DeviceType.tablet;
    return DeviceType.phone;
  }
}

enum DeviceType { phone, tablet, desktop }
