import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(title: const Text('About Us')),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              // =========================
              // PROJECT INFO
              // =========================
              Text('About the Project', style: AppTextStyles.headingMedium),
              SizedBox(height: 12),
              Text(
                'SpectroCough is a student-led project focused on exploring the use of '
                    'machine learning for respiratory sound analysis. '
                    'The goal is to demonstrate how AI can assist in pre-screening and '
                    'early indication of potential respiratory conditions.',
                style: AppTextStyles.bodyText,
              ),

              SizedBox(height: 24),

              // =========================
              // TEAM INFO
              // =========================
              Text('Team', style: AppTextStyles.headingMedium),
              SizedBox(height: 12),
              Text(
                'This project is developed by students as part of an academic initiative. '
                    'Team members include:\n'
                    '• Mayank Lahare\n'
                    '• Harshal Jadhav\n'
                    '• Aryan Gaikwad\n'
                    '\n(You can update this list as needed)',
                style: AppTextStyles.bodyText,
              ),

              SizedBox(height: 24),

              // =========================
              // PURPOSE & ETHICS
              // =========================
              Text('Purpose & Ethics', style: AppTextStyles.headingMedium),
              SizedBox(height: 12),
              Text(
                'The application is designed strictly for educational and research purposes. '
                    'It does not claim to diagnose any medical condition. '
                    'All results are indicative and should not be used for self-diagnosis.',
                style: AppTextStyles.bodyText,
              ),

              SizedBox(height: 24),

              // =========================
              // CONTACT / ATTRIBUTION
              // =========================
              Text('Contact & Attribution', style: AppTextStyles.headingMedium),
              SizedBox(height: 12),
              Text(
                'For academic references, feedback, or collaboration, '
                    'please contact the project team through your institution or repository.',
                style: AppTextStyles.smallText,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
