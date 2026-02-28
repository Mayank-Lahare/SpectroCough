// ============================================================
// App Drawer
// ------------------------------------------------------------
// Responsibilities:
// - Navigate between screens
// - Restrict protected routes
// - Show Login / Logout based on JWT state
// ============================================================

import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../screens/home_screen.dart';
import '../screens/screening_screen.dart';
import '../screens/reports_screen.dart';
import '../screens/health_ai_screen.dart';
import '../screens/about_screen.dart';
import '../screens/login_screen.dart';
import '../services/api_service.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  bool _loggedIn = false;

  // ============================================================
  // Check Login Status
  // ============================================================

  Future<void> _checkLogin() async {
    final status = await ApiService.isLoggedIn();

    if (!mounted) return;

    setState(() => _loggedIn = status);
  }

  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  // ============================================================
  // Navigation Helper
  // ============================================================

  void _go(BuildContext context, Widget screen) {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => screen),
    ).then((_) => _checkLogin());
  }

  // ============================================================
  // Login Required Dialog
  // ============================================================

  void _showLoginRequired(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Login Required'),
        content: const Text('You must login to access this feature.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);

              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );

              _checkLogin();
            },
            child: const Text('Login'),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // Logout
  // ============================================================

  Future<void> _logout(BuildContext context) async {
    await ApiService.logout();

    if (!mounted) return;

    Navigator.pop(context);

    setState(() => _loggedIn = false);
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

            Expanded(
              child: ListView(
                children: [
                  _Item(
                    icon: Icons.home,
                    label: 'Home',
                    onTap: () => _go(context, const HomeScreen()),
                  ),

                  // ====================================================
                  // Screening (Protected)
                  // ====================================================
                  _Item(
                    icon: Icons.graphic_eq,
                    label: 'Screening',
                    onTap: () {
                      if (_loggedIn) {
                        _go(context, const ScreeningScreen());
                      } else {
                        _showLoginRequired(context);
                      }
                    },
                  ),

                  // ====================================================
                  // Reports (Protected)
                  // ====================================================
                  _Item(
                    icon: Icons.history,
                    label: 'Reports',
                    onTap: () {
                      if (_loggedIn) {
                        _go(context, const ReportsScreen());
                      } else {
                        _showLoginRequired(context);
                      }
                    },
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
                ],
              ),
            ),

            const Divider(),

            _loggedIn
                ? _Item(
                    icon: Icons.logout,
                    label: 'Logout',
                    onTap: () => _logout(context),
                  )
                : _Item(
                    icon: Icons.login,
                    label: 'Login',
                    onTap: () async {
                      Navigator.pop(context);

                      await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                      );

                      _checkLogin();
                    },
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
