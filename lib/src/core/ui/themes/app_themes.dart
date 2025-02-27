import 'package:flutter/material.dart';
import 'package:overlays_workshop/src/core/ui/constants/app_colors.dart';

class AppThemes {
  static ThemeData get defaultTheme => ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.orangeAccent,
          primary: AppColors.primary,
          onPrimary: AppColors.onPrimary,
          secondary: AppColors.secondary,
          surface: AppColors.surface,
          onSurface: AppColors.onSurface,
          onSurfaceVariant: AppColors.onSurfaceVariant,
          tertiary: AppColors.tertiary,
        ),
        sliderTheme: SliderThemeData(
          trackHeight: 30,
          thumbColor: AppColors.surface,
          trackShape: RoundedRectSliderTrackShape(),
          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 15),
        ),
        scaffoldBackgroundColor: Colors.black87,
      );
}
