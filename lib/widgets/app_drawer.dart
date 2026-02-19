import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../screens/home_screen.dart';
import '../screens/screening_screen.dart';
import '../screens/result_screen.dart';
import '../screens/reports_screen.dart';
import '../screens/health_ai_screen.dart';
import '../screens/about_screen.dart';
import '../screens/login_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  void _go(BuildContext context, Widget screen) {
    Navigator.pop(context);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.white,
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: const [
                  Icon(Icons.mic, size: 48, color: AppColors.buttonBlue),
                  SizedBox(height: 8),
                  Text('SpectroCough', style: AppTextStyles.headingMedium),
                ],
              ),
            ),
            const Divider(),

            _Item(
              icon: Icons.home,
              label: 'Home',
              onTap: () => _go(context, const HomeScreen()),
            ),
            _Item(
              icon: Icons.graphic_eq,
              label: 'Screening',
              onTap: () => _go(context, const ScreeningScreen()),
            ),
            _Item(
              icon: Icons.bar_chart,
              label: 'Result',
              onTap: () => _go(context, const ResultScreen()),
            ),
            _Item(
              icon: Icons.history,
              label: 'Reports',
              onTap: () => _go(context, const ReportsScreen()),
            ),
            _Item(
              icon: Icons.health_and_safety,
              label: 'Health & AI',
              onTap: () => _go(context, const HealthAiScreen()),
            ),
            _Item(
              icon: Icons.info_outline,
              label: 'About Us',
              onTap: () => _go(context, const AboutScreen()),
            ),

            const Spacer(),
            const Divider(),

            _Item(
              icon: Icons.login,
              label: 'Login',
              onTap: () => _go(context, const LoginScreen()),
            ),
          ],
        ),
      ),
    );
  }
}

class _Item extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _Item({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.buttonBlue),
      title: Text(label, style: AppTextStyles.bodyText),
      onTap: onTap,
    );
  }
}
