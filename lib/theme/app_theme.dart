import 'package:flutter/material.dart';

class AppColors {
  // Mountain Theme (Primary Visual Identity)
  static const Color mountainBg = Color(0xFFF3F5FC);
  static const Color mountainCard = Color(0xFFFFFFFF);
  static const Color mountainPrimary = Color(0xFF8065F5);
  static const Color mountainSecondary = Color(0xFFB8A8FF);
  static const Color mountainPaleBlue = Color(0xFFDCE8FA);
  static const Color mountainNavy = Color(0xFF14213D);
  static const Color mountainSecondaryText = Color(0xFF6F7895);
  static const Color mountainBorder = Color(0xFFE3E7F2);
  static const Color mountainPillActive = Color(0xFFE11D48);

  // Transition Accents
  static const Color primaryViolet = Color(0xFF8065F5);
  static const Color secondaryLavender = Color(0xFFB8A8FF);
  static const Color accentCyan = Color(0xFF0284C7);
  static const Color accentPink = Color(0xFFDB2777);
  static const Color accentEmerald = Color(0xFF059669);
  static const Color accentAmber = Color(0xFFD97706);

  // Legacy dark palette preserved for deep-contrast demo screens
  static const Color bgPrimary = Color(0xFF0E0E14);
  static const Color bgElevated = Color(0xFF161622);
  static const Color bgCard = Color(0xFF1D1D2C);
  static const Color bgCardHover = Color(0xFF26263A);
  static const Color textPrimary = Color(0xFFF8F7FF);
  static const Color textSecondary = Color(0xFFA5A1BA);
  static const Color textMuted = Color(0xFF6B677F);
  static const Color borderSubtle = Color(0xFF2E2E3E);
}

class AppTheme {
  static ThemeData get mountainTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.mountainBg,
      primaryColor: AppColors.mountainPrimary,
      canvasColor: AppColors.mountainBg,
      fontFamily: 'Roboto',
      colorScheme: const ColorScheme.light(
        primary: AppColors.mountainPrimary,
        secondary: AppColors.mountainSecondary,
        surface: AppColors.mountainCard,
        onPrimary: Colors.white,
        onSurface: AppColors.mountainNavy,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        scrolledUnderElevation: 0,
        titleTextStyle: TextStyle(
          color: AppColors.mountainNavy,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.3,
        ),
        iconTheme: IconThemeData(
          color: AppColors.mountainNavy,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.mountainCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: AppColors.mountainBorder, width: 1),
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 34,
          fontWeight: FontWeight.w900,
          color: AppColors.mountainNavy,
          letterSpacing: -1.0,
          height: 1.15,
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w800,
          color: AppColors.mountainNavy,
          letterSpacing: -0.6,
          height: 1.2,
        ),
        titleLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w800,
          color: AppColors.mountainNavy,
          letterSpacing: -0.3,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: AppColors.mountainNavy,
        ),
        bodyLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColors.mountainSecondaryText,
          height: 1.5,
        ),
        bodyMedium: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: AppColors.mountainSecondaryText,
        ),
      ),
    );
  }
}
