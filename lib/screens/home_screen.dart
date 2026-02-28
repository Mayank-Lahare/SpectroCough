// ============================================================
// Home Screen
// ------------------------------------------------------------
// Responsibilities:
// - Display app introduction
// - Allow user to start screening
// - Redirect to Login if not authenticated
// - Protected screening access
// ============================================================

import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'screening_screen.dart';
import 'login_screen.dart';
import '../services/api_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(title: const Text('SpectroCough')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ============================================================
              // App Icon Section
              // ============================================================
              const SizedBox(height: 24),

              Container(
                height: 120,
                width: 120,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.mic,
                  size: 56,
                  color: AppColors.buttonBlue,
                ),
              ),

              const SizedBox(height: 24),

              // ============================================================
              // App Title & Description
              // ============================================================
              const Text('SpectroCough', style: AppTextStyles.headingLarge),

              const SizedBox(height: 8),

              const Text(
                'AI-powered pre-screening for respiratory sounds',
                style: AppTextStyles.bodyText,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 32),

              // ============================================================
              // Start Screening Button (Login Protected)
              // ============================================================
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    // ------------------------------------------------------------
                    // Check authentication before allowing screening
                    // ------------------------------------------------------------

                    final loggedIn = await ApiService.isLoggedIn();

                    if (!context.mounted) return;

                    if (loggedIn) {
                      // ------------------------------------------------------------
                      // User authenticated → Go to Screening
                      // ------------------------------------------------------------

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ScreeningScreen(),
                        ),
                      );
                    } else {
                      // ------------------------------------------------------------
                      // User not authenticated → Redirect to Login
                      // ------------------------------------------------------------

                      await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                      );
                    }
                  },
                  child: const Text(
                    'Start Screening',
                    style: AppTextStyles.buttonText,
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // ============================================================
              // How It Works Section
              // ============================================================
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('How it works', style: AppTextStyles.headingMedium),
                      SizedBox(height: 12),
                      _Step(
                        '1',
                        'Record respiratory sound using your phone mic',
                      ),
                      SizedBox(height: 8),
                      _Step('2', 'AI analyzes acoustic patterns'),
                      SizedBox(height: 8),
                      _Step('3', 'View pre-screening results'),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // ============================================================
              // Disclaimer
              // ============================================================
              const Text(
                'This is a pre-screening tool, not a medical diagnostic device.',
                style: AppTextStyles.smallText,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// Step Widget
// ------------------------------------------------------------
// Displays numbered step with description
// ============================================================

class _Step extends StatelessWidget {
  final String index;
  final String text;

  const _Step(this.index, this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Text(
              index,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(child: Text(text, style: AppTextStyles.bodyText)),
      ],
    );
  }
}
