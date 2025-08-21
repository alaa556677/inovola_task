import 'package:flutter/material.dart';

class AppColors {

  static const Color whiteColor = Colors.white;
  static const Color blackColor = Colors.black;
  // Primary Colors
  static const Color primary = Color(0xFF6C63FF);
  static const Color secondary = Color(0xFFFF6B6B);

  // Status Colors
  static const Color success = Color(0xFF4ECDC4);
  static const Color warning = Color(0xFFFFD93D);
  static const Color error = Color(0xFFFF4757);

  // Background Colors
  static const Color background = Color(0xFFF8F9FA);
  static const Color surface = Color(0xFFFFFFFF);

  // Text Colors
  static const Color textPrimary = Color(0xFF2C3E50);
  static const Color textSecondary = Color(0xFF7F8C8D);

  // Additional Colors
  static const Color income = Color(0xFF4ECDC4);
  static const Color expense = Color(0xFFFF6B6B);
  static const Color neutral = Color(0xFF95A5A6);

  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, Color(0xFF8B7FF9)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient successGradient = LinearGradient(
    colors: [success, Color(0xFF6EE7B7)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient errorGradient = LinearGradient(
    colors: [error, Color(0xFFFF6B6B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
