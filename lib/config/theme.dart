import 'package:flutter/material.dart';

class AppColors {
  // Vibrant primary palette
  static const hotPink = Color(0xFFFF2D87);
  static const deepPink = Color(0xFFE91E8C);
  static const magenta = Color(0xFFD500F9);
  static const purple = Color(0xFF7C4DFF);
  static const deepPurple = Color(0xFF651FFF);
  static const royalBlue = Color(0xFF2979FF);
  static const skyBlue = Color(0xFF00B0FF);
  static const cyan = Color(0xFF00E5FF);
  static const teal = Color(0xFF1DE9B6);
  static const green = Color(0xFF00E676);
  static const lime = Color(0xFF76FF03);
  static const yellow = Color(0xFFFFEA00);
  static const amber = Color(0xFFFFAB00);
  static const orange = Color(0xFFFF6D00);
  static const deepOrange = Color(0xFFFF3D00);
  static const coral = Color(0xFFFF6B6B);

  // Grid cell colors for found words (cycling)
  static const foundColors = [
    Color(0xFFFF2D87), // hot pink
    Color(0xFF7C4DFF), // purple
    Color(0xFF00B0FF), // sky blue
    Color(0xFFFF6D00), // orange
    Color(0xFF00E676), // green
    Color(0xFFFFEA00), // yellow
    Color(0xFFD500F9), // magenta
    Color(0xFF1DE9B6), // teal
    Color(0xFFFF3D00), // deep orange
    Color(0xFF2979FF), // royal blue
  ];

  // Category card gradient pairs
  static const categoryGradients = [
    [Color(0xFFFF2D87), Color(0xFFFF6B6B)],  // pink to coral
    [Color(0xFF7C4DFF), Color(0xFFD500F9)],  // purple to magenta
    [Color(0xFF2979FF), Color(0xFF00B0FF)],  // blue to sky blue
    [Color(0xFFFF6D00), Color(0xFFFFAB00)],  // orange to amber
    [Color(0xFF00E676), Color(0xFF1DE9B6)],  // green to teal
    [Color(0xFFE91E8C), Color(0xFF651FFF)],  // deep pink to deep purple
    [Color(0xFF00B0FF), Color(0xFF00E5FF)],  // sky blue to cyan
    [Color(0xFFFF3D00), Color(0xFFFF6D00)],  // deep orange to orange
    [Color(0xFFD500F9), Color(0xFF7C4DFF)],  // magenta to purple
    [Color(0xFF1DE9B6), Color(0xFF00E676)],  // teal to green
  ];

  // Background gradient
  static const bgGradientStart = Color(0xFFF8F0FF);
  static const bgGradientEnd = Color(0xFFE8F4FD);

  // Selection line color
  static const selectionPink = Color(0xFFFF2D87);
  static const selectionBlue = Color(0xFF2979FF);
  static const selectionYellow = Color(0xFFFFEA00);
  static const selectionOrange = Color(0xFFFF6D00);
}

class AppTheme {
  static final light = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.hotPink,
      brightness: Brightness.light,
      primary: AppColors.hotPink,
      secondary: AppColors.purple,
      tertiary: AppColors.skyBlue,
    ),
    scaffoldBackgroundColor: const Color(0xFFF5F0FF),
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
      foregroundColor: Color(0xFF2D1B69),
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w800,
        color: Color(0xFF2D1B69),
      ),
    ),
    cardTheme: CardThemeData(
      elevation: 4,
      shadowColor: AppColors.hotPink.withValues(alpha: 0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.hotPink,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.hotPink,
        side: const BorderSide(color: AppColors.hotPink, width: 2),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
      filled: true,
      fillColor: Colors.white,
    ),
  );

  static final dark = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.hotPink,
      brightness: Brightness.dark,
      primary: AppColors.hotPink,
      secondary: AppColors.purple,
      tertiary: AppColors.skyBlue,
    ),
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
    ),
    cardTheme: CardThemeData(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.hotPink,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
      filled: true,
    ),
  );

  static Color difficultyColor(String difficulty) {
    switch (difficulty) {
      case 'easy':
        return AppColors.green;
      case 'medium':
        return AppColors.orange;
      case 'hard':
        return AppColors.hotPink;
      default:
        return AppColors.purple;
    }
  }

  static List<Color> difficultyGradient(String difficulty) {
    switch (difficulty) {
      case 'easy':
        return [AppColors.green, AppColors.teal];
      case 'medium':
        return [AppColors.orange, AppColors.amber];
      case 'hard':
        return [AppColors.hotPink, AppColors.deepOrange];
      default:
        return [AppColors.purple, AppColors.skyBlue];
    }
  }

  static List<Color> categoryGradient(int index) {
    return AppColors.categoryGradients[index % AppColors.categoryGradients.length];
  }

  static IconData categoryIcon(String icon) {
    switch (icon) {
      case 'tv': return Icons.tv;
      case 'comedy': return Icons.sentiment_very_satisfied;
      case 'movie': return Icons.movie;
      case 'star': return Icons.star;
      case 'pets': return Icons.pets;
      case 'target': return Icons.track_changes;
      case 'child': return Icons.child_care;
      case 'castle': return Icons.castle;
      case 'food': return Icons.restaurant;
      case 'science': return Icons.science;
      case 'music': return Icons.music_note;
      case 'sports': return Icons.sports_soccer;
      case 'globe': return Icons.public;
      case 'map': return Icons.map;
      case 'city': return Icons.location_city;
      case 'history': return Icons.history_edu;
      case 'book': return Icons.menu_book;
      case 'health': return Icons.health_and_safety;
      case 'church': return Icons.church;
      case 'edit': return Icons.edit_note;
      case 'abc': return Icons.abc;
      case 'school': return Icons.school;
      case 'holiday': return Icons.celebration;
      case 'language': return Icons.language;
      default: return Icons.category;
    }
  }
}
