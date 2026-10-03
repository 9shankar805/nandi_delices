import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Brand Color Tokens (From UI_SPEC.md & Logo)
  static const Color primaryGreen = Color(0xFF087A3D);
  static const Color deepGreen = Color(0xFF075B2F);
  static const Color gold = Color(0xFFF4C400);
  static const Color goldDark = Color(0xFFDCA800);
  static const Color warmRed = Color(0xFFD71920);
  static const Color black = Color(0xFF111111);
  static const Color cream = Color(0xFFFFF9EC);
  static const Color creamDark = Color(0xFFF5EEDB);
  static const Color white = Color(0xFFFFFFFF);
  static const Color mutedText = Color(0xFF6B6B6B);
  static const Color border = Color(0xFFE4DDCC);
  static const Color cardBg = Color(0xFFFFFFFF);
  static const Color whatsappGreen = Color(0xFF25D366);
  static const Color whatsappDark = Color(0xFF128C7E);

  // Surface gradients
  static const LinearGradient greenGradient = LinearGradient(
    colors: [primaryGreen, deepGreen],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient goldGradient = LinearGradient(
    colors: [Color(0xFFFFD54F), gold],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient redGradient = LinearGradient(
    colors: [Color(0xFFE53935), warmRed],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient whatsappGradient = LinearGradient(
    colors: [Color(0xFF25D366), Color(0xFF128C7E)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient heroGradient = LinearGradient(
    colors: [
      Color(0xFF075B2F),
      Color(0xFF087A3D),
      Color(0xFF064724),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Soft Shadows
  static List<BoxShadow> softShadow = [
    BoxShadow(
      color: Colors.black.withAlpha(12),
      blurRadius: 16,
      offset: const Offset(0, 6),
    ),
  ];

  static List<BoxShadow> greenShadow = [
    BoxShadow(
      color: primaryGreen.withAlpha(70),
      blurRadius: 18,
      offset: const Offset(0, 6),
    ),
  ];

  static List<BoxShadow> whatsappShadow = [
    BoxShadow(
      color: whatsappGreen.withAlpha(90),
      blurRadius: 18,
      offset: const Offset(0, 6),
    ),
  ];

  static ThemeData get theme {
    final baseTextTheme = GoogleFonts.outfitTextTheme();

    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: cream,
      primaryColor: primaryGreen,
      colorScheme: const ColorScheme.light(
        primary: primaryGreen,
        secondary: gold,
        tertiary: warmRed,
        surface: white,
        onPrimary: white,
        onSecondary: black,
        onSurface: black,
        outline: border,
      ),
      textTheme: baseTextTheme.copyWith(
        displayLarge: GoogleFonts.outfit(
          fontSize: 32,
          fontWeight: FontWeight.w800,
          color: black,
          letterSpacing: -0.5,
        ),
        displayMedium: GoogleFonts.outfit(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: black,
        ),
        titleLarge: GoogleFonts.outfit(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: black,
        ),
        titleMedium: GoogleFonts.outfit(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: black,
        ),
        bodyLarge: GoogleFonts.plusJakartaSans(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: black,
        ),
        bodyMedium: GoogleFonts.plusJakartaSans(
          fontSize: 13,
          fontWeight: FontWeight.w400,
          color: mutedText,
        ),
        labelLarge: GoogleFonts.outfit(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.2,
        ),
      ),
      cardTheme: CardThemeData(
        color: cardBg,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: border, width: 1),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: cream,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: black),
        titleTextStyle: GoogleFonts.outfit(
          color: black,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryGreen,
          foregroundColor: white,
          elevation: 0,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.outfit(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: border, width: 1.2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: border, width: 1.2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: primaryGreen, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: warmRed, width: 1.5),
        ),
        labelStyle: GoogleFonts.plusJakartaSans(
          color: mutedText,
          fontSize: 14,
        ),
        hintStyle: GoogleFonts.plusJakartaSans(
          color: mutedText.withAlpha(150),
          fontSize: 14,
        ),
      ),
    );
  }
}
