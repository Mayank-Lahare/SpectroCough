import 'package:flutter/material.dart';
import 'theme/app_colors.dart';
import 'screens/home_screen.dart';

class SpectroCoughApp extends StatelessWidget {
  const SpectroCoughApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SpectroCough',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,

        // Global scaffold background
        scaffoldBackgroundColor: AppColors.backgroundLight,

        // Material 3 color scheme
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.buttonBlue,
          surface: AppColors.backgroundLight,
        ),

        // AppBar default style
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          backgroundColor: AppColors.backgroundLight,
          foregroundColor: AppColors.textPrimary,
          elevation: 0,
        ),

        // ElevatedButton (Primary CTA)
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.buttonBlue,
            foregroundColor: AppColors.buttonText,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),

        // OutlinedButton (Secondary actions)
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.buttonBlue,
            side: const BorderSide(color: AppColors.buttonBlue),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),

        // TextButton (Links / small actions)
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(foregroundColor: AppColors.buttonBlue),
        ),

        // Card theme
        cardTheme: CardThemeData(
          color: AppColors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),

        // Input fields (Login, forms later)
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: AppColors.buttonBlue,
              width: 1.5,
            ),
          ),
        ),

        // Icon theme
        iconTheme: const IconThemeData(color: AppColors.buttonBlue),
      ),

      home: const HomeScreen(),
    );
  }
}
