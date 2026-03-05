// ============================================================
// App Drawer — SpectroCough Themed Edition
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

class _AppDrawerState extends State<AppDrawer>
    with SingleTickerProviderStateMixin {
  bool _loggedIn = false;
  String? _username;
  String? _userEmail;

  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _checkLogin();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Future<void> _checkLogin() async {
    final status = await ApiService.isLoggedIn();

    String? username;
    String? email;

    if (status) {
      final user = await ApiService.getCurrentUser();
      username = user?["name"];
      email = user?["email"];
    }

    if (!mounted) return;

    setState(() {
      _loggedIn = status;
      _username = username;
      _userEmail = email;
    });

    _animController.forward(from: 0);
  }

  void _go(Widget screen) {
    Navigator.of(context).pop();
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen)).then((
      _,
    ) {
      if (!mounted) return;
      _checkLogin();
    });
  }

  void _showLoginRequired() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(
              Icons.lock_outline_rounded,
              color: AppColors.primary,
              size: 20,
            ),
            const SizedBox(width: 8),
            const Text('Login Required'),
          ],
        ),
        content: const Text('You must be logged in to access this feature.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
            onPressed: () async {
              Navigator.of(context).pop();

              await Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const LoginScreen()));

              if (!mounted) return;
              _checkLogin();
            },
            child: const Text('Login'),
          ),
        ],
      ),
    );
  }

  Future<void> _logout() async {
    await ApiService.logout();

    if (!mounted) return;

    Navigator.of(context).pop();

    setState(() {
      _loggedIn = false;
      _username = null;
      _userEmail = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.white,
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Column(
          children: [
            _DrawerHeader(
              loggedIn: _loggedIn,
              username: _username,
              email: _userEmail,
              fadeAnim: _fadeAnim,
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                children: [
                  const _SectionLabel('Main'),
                  _NavItem(
                    icon: Icons.home_rounded,
                    label: 'Home',
                    onTap: () => _go(const HomeScreen()),
                  ),
                  const _SectionLabel('Health'),
                  _NavItem(
                    icon: Icons.graphic_eq_rounded,
                    label: 'Screening',
                    locked: !_loggedIn,
                    onTap: () => _loggedIn
                        ? _go(const ScreeningScreen())
                        : _showLoginRequired(),
                  ),
                  _NavItem(
                    icon: Icons.history_rounded,
                    label: 'Reports',
                    locked: !_loggedIn,
                    onTap: () => _loggedIn
                        ? _go(const ReportsScreen())
                        : _showLoginRequired(),
                  ),
                  _NavItem(
                    icon: Icons.health_and_safety_rounded,
                    label: 'Health & AI',
                    onTap: () => _go(const HealthAiScreen()),
                  ),
                  const _SectionLabel('Info'),
                  _NavItem(
                    icon: Icons.info_outline_rounded,
                    label: 'About Us',
                    onTap: () => _go(const AboutScreen()),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
              child: _loggedIn
                  ? _NavItem(
                      icon: Icons.logout_rounded,
                      label: 'Logout',
                      isDestructive: true,
                      onTap: _logout,
                    )
                  : _NavItem(
                      icon: Icons.login_rounded,
                      label: 'Login',
                      onTap: () async {
                        Navigator.of(context).pop();

                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const LoginScreen(),
                          ),
                        );

                        if (!mounted) return;
                        _checkLogin();
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
// HEADER
// ─────────────────────────────────────────

class _DrawerHeader extends StatelessWidget {
  final bool loggedIn;
  final String? username;
  final String? email;
  final Animation<double> fadeAnim;

  const _DrawerHeader({
    required this.loggedIn,
    required this.username,
    required this.email,
    required this.fadeAnim,
  });

  String get _initials {
    if (username == null || username!.isEmpty) return '?';
    final parts = username!.trim().split(' ');
    return parts.length >= 2
        ? '${parts[0][0]}${parts[1][0]}'.toUpperCase()
        : username![0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 24),
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(6),
          bottomRight: Radius.circular(6),
        ),
      ),
      child: FadeTransition(
        opacity: fadeAnim,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 50,
                  width: 50,
                  child: Image.asset(
                    "assets/logo/logo_2.PNG",
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  'SpectroCough',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),
            if (loggedIn) ...[
              Row(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: AppColors.accent.withValues(alpha: 0.3),
                    child: Text(
                      _initials,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          username ?? 'User',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (email != null && email!.isNotEmpty)
                          Text(
                            email!,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.75),
                              fontSize: 12,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ] else
              Text(
                'Welcome, Guest',
                style: TextStyle(color: Colors.white.withValues(alpha: 0.8)),
              ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
// SECTION LABEL
// ─────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String text;

  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 16, 12, 4),
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(
          fontSize: 10.5,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.1,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
// NAV ITEM
// ─────────────────────────────────────────

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool locked;
  final bool isDestructive;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.locked = false,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final iconColor = isDestructive
        ? AppColors.danger
        : locked
        ? AppColors.textSecondary
        : AppColors.primary;

    final textColor = isDestructive ? AppColors.danger : AppColors.textPrimary;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
          child: Row(
            children: [
              Icon(icon, size: 22, color: iconColor),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  label,
                  style: AppTextStyles.bodyText.copyWith(
                    color: textColor,
                    fontSize: 14.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (locked)
                Icon(
                  Icons.lock_outline_rounded,
                  size: 15,
                  color: AppColors.textSecondary,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
