// ============================================================
// Home Screen
// ------------------------------------------------------------
// Responsibilities:
// - Display app introduction
// - Allow user to start screening
// - Redirect to Login if not authenticated
// - Protected screening access
// - Ultra clean medical minimal UI
// ============================================================

import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'screening_screen.dart';
import 'login_screen.dart';
import '../services/api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

// ============================================================
// State Class
// ------------------------------------------------------------
// Adds subtle CTA animation
// ============================================================

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _scale = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> handleStart(BuildContext context) async {
    final loggedIn = await ApiService.isLoggedIn();
    if (!context.mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            loggedIn ? const ScreeningScreen() : const LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('SpectroCough'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.primary,
        centerTitle: true,
      ),

      // ======================================================
      // Soft Neutral Background
      // ======================================================
      backgroundColor: const Color(0xFFF6F8FA),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // ==================================================
              // TOP SECTION
              // ==================================================
              Column(
                children: [
                  const SizedBox(height: 28),

                  Image.asset("assets/logo/spectro_logo_1.png", width: 90),

                  const SizedBox(height: 18),

                  const Text('SpectroCough', style: AppTextStyles.headingLarge),

                  const SizedBox(height: 8),

                  const Text(
                    'AI-powered respiratory sound pre-screening',
                    style: AppTextStyles.bodyText,
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 28),

                  // ==================================================
                  // Subtle Animated CTA
                  // ==================================================
                  ScaleTransition(
                    scale: _scale,
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => handleStart(context),
                        style: ElevatedButton.styleFrom(
                          elevation: 2,
                          shadowColor: AppColors.primary.withValues(
                            alpha: 0.15,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text(
                          'Start Screening',
                          style: AppTextStyles.buttonText,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // ==================================================
              // How It Works Card (Soft Elevated)
              // ==================================================
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 22,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: const [
                    Text('How it works', style: AppTextStyles.headingMedium),
                    SizedBox(height: 18),
                    _Step('1', 'Upload respiratory sound'),
                    SizedBox(height: 12),
                    _Step('2', 'AI analyzes acoustic patterns'),
                    SizedBox(height: 12),
                    _Step('3', 'View pre-screening results'),
                  ],
                ),
              ),

              // ==================================================
              // Disclaimer
              // ==================================================
              Padding(
                padding: const EdgeInsets.only(bottom: 18),
                child: const Text(
                  'AI-assisted pre-screening only. Not a medical diagnostic device.',
                  style: AppTextStyles.smallText,
                  textAlign: TextAlign.center,
                ),
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
// Displays numbered step in minimal style
// ============================================================

class _Step extends StatelessWidget {
  final String index;
  final String text;

  const _Step(this.index, this.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Text(
            index,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(child: Text(text, style: AppTextStyles.bodyText)),
      ],
    );
  }
}
