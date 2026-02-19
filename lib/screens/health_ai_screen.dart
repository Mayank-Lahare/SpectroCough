import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class HealthAiScreen extends StatelessWidget {
  const HealthAiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(title: const Text('Health & AI')),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              // =========================
              // INTRO
              // =========================
              Text('About SpectroCough', style: AppTextStyles.headingMedium),
              SizedBox(height: 12),
              Text(
                'SpectroCough is an AI-powered pre-screening tool designed to '
                    'analyze respiratory sounds such as cough and breathing patterns. '
                    'It helps users get an early indication of possible respiratory conditions.',
                style: AppTextStyles.bodyText,
              ),

              SizedBox(height: 24),

              // =========================
              // HOW AI WORKS
              // =========================
              Text('How the AI works', style: AppTextStyles.headingMedium),
              SizedBox(height: 12),
              Text(
                'The system extracts acoustic features from recorded respiratory sounds '
                    'and feeds them into a trained machine learning model. '
                    'The model compares patterns against known respiratory conditions '
                    'to estimate the most likely class and confidence level.',
                style: AppTextStyles.bodyText,
              ),

              SizedBox(height: 24),

              // =========================
              // HOW TO USE
              // =========================
              Text('How to use the app', style: AppTextStyles.headingMedium),
              SizedBox(height: 12),
              Text(
                '1. Go to the Screening section.\n'
                    '2. Record your respiratory sound in a quiet environment.\n'
                    '3. Wait while the AI analyzes the sound.\n'
                    '4. View the pre-screening result and confidence.\n',
                style: AppTextStyles.bodyText,
              ),

              SizedBox(height: 24),

              // =========================
              // SAFETY DISCLAIMER
              // =========================
              Text('Important Disclaimer', style: AppTextStyles.headingMedium),
              SizedBox(height: 12),
              Text(
                'This application is intended for educational and pre-screening purposes only. '
                    'It is not a medical diagnostic tool. '
                    'Always consult a qualified healthcare professional for medical advice and diagnosis.',
                style: AppTextStyles.smallText,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
