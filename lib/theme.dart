import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Warna & tema Hadirku (putih dominan + aksen teal).
class C {
  static const teal = Color(0xFF0B7F78);
  static const teal2 = Color(0xFF0C8A80);
  static const teal3 = Color(0xFF12A094);
  static const tealDark = Color(0xFF08635F);
  static const inkTeal = Color(0xFF043B3A);
  static const ink = Color(0xFF10302E);
  static const muted = Color(0xFF5A6B6A);
  static const coral = Color(0xFFF2552C);
  static const amber = Color(0xFFFFC857);
  static const green = Color(0xFF168A47);
  static const bg = Color(0xFFF0F8F6);
  static const tint = Color(0xFFEAF5F2);
  static const tint2 = Color(0xFFF3FAF8);
  static const field = Color(0xFFEEF4F3);
  static const line = Color(0xFFE3EFEC);
  static const frame = Color(0xFF0A1A19);

  static const headerGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFE6F4F1), Color(0xFFF3FAF8)],
  );
  static const buttonGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0C8A80), Color(0xFF08635F)],
  );
  static const fabGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF12A094), Color(0xFF08635F)],
  );
  static const shadow = Color(0x240A504C);
}

ThemeData buildTheme() {
  final base = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: C.teal, primary: C.teal),
    scaffoldBackgroundColor: Colors.white,
  );
  return base.copyWith(
    textTheme: GoogleFonts.plusJakartaSansTextTheme(base.textTheme)
        .apply(bodyColor: C.ink, displayColor: C.ink),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: C.teal),
    ),
  );
}