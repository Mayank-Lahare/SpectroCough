import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'recording_screen.dart';

class ScreeningScreen extends StatelessWidget {
  const ScreeningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Drawer navigation
      drawer: const AppDrawer(),

      // App background
      backgroundColor: AppColors.backgroundLight,

      // App bar title
      appBar: AppBar(title: const Text('Screening')),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 24),

              // =========================
              // INSTRUCTIONS CARD
              // =========================
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Before you start',
                        style: AppTextStyles.headingMedium,
                      ),
                      SizedBox(height: 12),

                      _BulletPoint('Sit in a quiet environment'),
                      SizedBox(height: 8),

                      _BulletPoint('Hold your phone near your mouth/chest'),
                      SizedBox(height: 8),

                      _BulletPoint('Record for at least 5–10 seconds'),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // =========================
              // PRIMARY RECORD BUTTON
              // =========================
              // Big, clear CTA
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const RecordingScreen(),
                    ),
                  );
                },
                child: Container(
                  height: 96,
                  width: 96,
                  decoration: BoxDecoration(
                    color: AppColors.buttonBlue,
                    shape: BoxShape.circle,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.mic,
                    color: AppColors.white,
                    size: 40,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              const Text(
                'Tap to start recording',
                style: AppTextStyles.bodyText,
              ),

              const SizedBox(height: 32),

              // =========================
              // DISCLAIMER
              // =========================
              const Text(
                'This tool provides pre-screening only. '
                    'It does not replace professional medical advice.',
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

// =========================
// SMALL BULLET POINT WIDGET
// =========================
class _BulletPoint extends StatelessWidget {
  final String text;

  const _BulletPoint(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(
          Icons.check_circle,
          size: 18,
          color: AppColors.buttonBlue,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(text, style: AppTextStyles.bodyText),
        ),
      ],
    );
  }
}
