// ============================================================
// Screening Screen
// ------------------------------------------------------------
// Responsibilities:
// - Educate user about supported audio types
// - Provide entry point to UploadScreen
// - Maintain clinical clarity and simplicity
// ============================================================

import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'upload_screen.dart';

class ScreeningScreen extends StatelessWidget {
  const ScreeningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Respiratory Screening'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.primary,
        centerTitle: true,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16),

              // ============================================================
              // INTRODUCTION CARD
              // ============================================================
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Supported Audio Types',
                        style: AppTextStyles.headingMedium,
                      ),
                      SizedBox(height: 12),
                      _BulletPoint(
                        'Normal cough recordings (mobile microphone)',
                      ),
                      SizedBox(height: 8),
                      _BulletPoint('Stethoscopic respiratory sounds'),
                      SizedBox(height: 8),
                      _BulletPoint('WAV format recommended (16kHz preferred)'),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // ============================================================
              // NORMAL AUDIO BUTTON
              // ============================================================
              _UploadOptionCard(
                title: "Upload Normal Audio",
                subtitle: "Mobile-recorded cough or respiratory sound",
                icon: Icons.graphic_eq,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const UploadScreen(initialAudioType: "normal"),
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),

              // ============================================================
              // STETHOSCOPIC AUDIO BUTTON
              // ============================================================
              _UploadOptionCard(
                title: "Upload Stethoscopic Audio",
                subtitle: "Digital stethoscope respiratory recording",
                icon: Icons.health_and_safety,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const UploadScreen(initialAudioType: "stethoscopic"),
                    ),
                  );
                },
              ),

              const SizedBox(height: 40),

              const Text(
                'This system provides AI-based pre-screening assistance only. '
                'It does not replace professional medical diagnosis.',
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
// Upload Option Card Widget
// ============================================================

class _UploadOptionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const _UploadOptionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, size: 36, color: AppColors.primary),
            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.headingSmall),
                  const SizedBox(height: 4),
                  Text(subtitle, style: AppTextStyles.smallText),
                ],
              ),
            ),

            const Icon(Icons.arrow_forward_ios, size: 18),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// Bullet Point Widget
// ============================================================

class _BulletPoint extends StatelessWidget {
  final String text;

  const _BulletPoint(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.check_circle, size: 18, color: AppColors.primary),
        const SizedBox(width: 8),
        Expanded(child: Text(text, style: AppTextStyles.bodyText)),
      ],
    );
  }
}
