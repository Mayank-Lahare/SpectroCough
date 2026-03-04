import 'package:flutter/material.dart';
import 'theme/app_colors.dart';
import 'screens/splash_screen.dart';
import 'widgets/responsive_container.dart';

class SpectroCoughApp extends StatelessWidget {
  const SpectroCoughApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SpectroCough',
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return ResponsiveContainer(child: child ?? const SizedBox());
      },

      theme: ThemeData(
        useMaterial3: true,

        // ============================================================
        // Global scaffold background
        // ============================================================
        scaffoldBackgroundColor: AppColors.backgroundLight,

        // ============================================================
        // Material 3 color scheme (Research-Grade Clinical Theme)
        // ============================================================
        colorScheme: const ColorScheme(
          brightness: Brightness.light,

          // Primary (Deep Teal Authority)
          primary: AppColors.primary,
          onPrimary: Colors.white,

          // Accent (Controlled AI Cyan)
          secondary: AppColors.accent,
          onSecondary: Colors.white,

          // Error / Danger
          error: AppColors.danger,
          onError: Colors.white,

          // Surface system (M3 compliant)
          surface: AppColors.surface,
          onSurface: AppColors.textPrimary,
        ),

        // ============================================================
        // AppBar default style
        // ============================================================
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          backgroundColor: AppColors.backgroundLight,
          foregroundColor: AppColors.textPrimary,
          elevation: 0,
        ),

        // ============================================================
        // ElevatedButton (Primary CTA)
        // ============================================================
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),

        // ============================================================
        // OutlinedButton (Secondary actions)
        // ============================================================
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            side: const BorderSide(color: AppColors.primary),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),

        // ============================================================
        // TextButton (Links / small actions)
        // ============================================================
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(foregroundColor: AppColors.primary),
        ),

        // ============================================================
        // Card theme (Soft Clinical Surface)
        // ============================================================
        cardTheme: CardThemeData(
          color: AppColors.surface,
          elevation: 1.5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),

        // ============================================================
        // Input fields (Login, forms later)
        // ============================================================
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.2),
          ),
        ),

        // ============================================================
        // Icon theme
        // ============================================================
        iconTheme: const IconThemeData(color: AppColors.primary),
      ),

      // ============================================================
      // Home
      // ============================================================
      home: const SplashScreen(),
    );
  }
}
