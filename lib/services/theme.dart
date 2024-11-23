import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color primaryColor = Color(0xFF0C54BE);
  static const Color accentColor = Color(0xFF303F60);
  static const Color backgroundColor = Color(0xFFF5F9FD);
  static const Color borderColor = Color(0xFFCED3DC);
}

class AppTextTheme {
  static TextTheme buildTextTheme() {
    return TextTheme(
      displayLarge: GoogleFonts.poppins(fontWeight: FontWeight.bold),
      displayMedium: GoogleFonts.poppins(fontWeight: FontWeight.w500),
      bodyLarge: GoogleFonts.poppins(fontWeight: FontWeight.w400),
    );
  }
}

class AppTheme {
  static ThemeData buildTheme() {
    return ThemeData(
      primaryColor: AppColors.primaryColor,
      hintColor: AppColors.accentColor,
      scaffoldBackgroundColor: AppColors.backgroundColor,
      textTheme: AppTextTheme.buildTextTheme(),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.borderColor),
        ),
      ),
    );
  }
}