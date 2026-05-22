import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const _fallbackSeedColor = Colors.indigo;

  static ThemeData lightTheme(ColorScheme? dynamicScheme) {
    final colorScheme =
        dynamicScheme ??
        ColorScheme.fromSeed(
          seedColor: _fallbackSeedColor,
          brightness: Brightness.light,
        );
    return _buildTheme(colorScheme);
  }

  static ThemeData darkTheme(ColorScheme? dynamicScheme) {
    final colorScheme =
        dynamicScheme ??
        ColorScheme.fromSeed(
          seedColor: _fallbackSeedColor,
          brightness: Brightness.dark,
        );
    return _buildTheme(colorScheme);
  }

  static ThemeData _buildTheme(ColorScheme colorScheme) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 1,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: colorScheme.surfaceContainerLow,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
        elevation: 2,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        backgroundColor: colorScheme.surface,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: colorScheme.surfaceContainerLow,
      ),
    );
  }
}
