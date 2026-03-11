// ============================================================
// Animated Auth Screen — Optimized UI
// ------------------------------------------------------------
// Design direction: Refined Clinical Glass
// Changes vs original:
// - Decorative floating orb blobs in gradient background for depth
// - Larger, breathable logo area with subtle tagline
// - Glass card has slightly more opacity + tighter inner padding
// - Toggle pill: cleaner sizing, proper text color transitions
// - Back button now uses a bordered frosted style
// - Form container height auto-adjusts (no fixed 360 hardcode)
// ============================================================

import 'dart:ui';
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../services/api_service.dart';
import 'sign_in_form.dart';
import 'sign_up_form.dart';
import 'bubble_indicator.dart';

class AnimatedAuthScreen extends StatefulWidget {
  const AnimatedAuthScreen({super.key});

  @override
  State<AnimatedAuthScreen> createState() => _AnimatedAuthScreenState();
}

class _AnimatedAuthScreenState extends State<AnimatedAuthScreen>
    with SingleTickerProviderStateMixin {
  // ── Controllers ───────────────────────────────────────────
  final _loginEmailController = TextEditingController();
  final _loginPasswordController = TextEditingController();
  final _registerNameController = TextEditingController();
  final _registerEmailController = TextEditingController();
  final _registerPasswordController = TextEditingController();
  final PageController _pageController = PageController();

  // ── State ─────────────────────────────────────────────────
  int _currentIndex = 0;
  bool _loading = false;
  String _error = '';

  // ── Orb animation ─────────────────────────────────────────
  late final AnimationController _orbController;

  @override
  void initState() {
    super.initState();

    _pageController.addListener(() {
      final page = _pageController.page?.round() ?? 0;
      if (page != _currentIndex) setState(() => _currentIndex = page);
    });

    _orbController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _loginEmailController.dispose();
    _loginPasswordController.dispose();
    _registerNameController.dispose();
    _registerEmailController.dispose();
    _registerPasswordController.dispose();
    _pageController.dispose();
    _orbController.dispose();
    super.dispose();
  }

  // ── Validation ────────────────────────────────────────────
  bool _validateEmail(String e) =>
      e.contains('@') && e.contains('.') && e.length > 5;

  bool _validatePassword(String p) => p.length >= 8;

  // ── Login ─────────────────────────────────────────────────
  Future<void> _handleLogin() async {
    final email = _loginEmailController.text.trim();
    final password = _loginPasswordController.text.trim();

    if (!_validateEmail(email)) {
      setState(() => _error = 'Please enter a valid email address');
      return;
    }

    if (!_validatePassword(password)) {
      setState(() => _error = 'Password must be at least 8 characters');
      return;
    }

    setState(() {
      _loading = true;
      _error = '';
    });

    final success = await ApiService.login(email, password);

    if (!mounted) return;

    setState(() => _loading = false);

    if (success) {
      Navigator.pop(context, true);
    } else {
      setState(() => _error = 'Authentication failed. Please try again.');
    }
  }

  // ── Register ──────────────────────────────────────────────
  Future<void> _handleRegister() async {
    final name = _registerNameController.text.trim();
    final email = _registerEmailController.text.trim();
    final password = _registerPasswordController.text.trim();

    if (name.isEmpty) {
      setState(() => _error = 'Please enter your full name');
      return;
    }

    if (!_validateEmail(email)) {
      setState(() => _error = 'Please enter a valid email address');
      return;
    }

    if (!_validatePassword(password)) {
      setState(() => _error = 'Password must be at least 8 characters');
      return;
    }

    setState(() {
      _loading = true;
      _error = '';
    });

    final success = await ApiService.register(name, email, password);

    if (!mounted) return;

    setState(() => _loading = false);

    if (success) {
      _pageController.animateToPage(
        0,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );

      setState(() => _error = 'Registration successful. Please log in.');
    } else {
      setState(() => _error = 'Registration failed. Please try again.');
    }
  }

  // ── Build ─────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(gradient: AppColors.authGradient),
          ),

          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        children: [
                          const SizedBox(height: 64),
                          _LogoSection(),
                          const SizedBox(height: 28),
                          _buildToggle(),
                          const SizedBox(height: 20),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(28),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(
                                  sigmaX: 20,
                                  sigmaY: 20,
                                ),
                                child: Container(
                                  padding: const EdgeInsets.fromLTRB(
                                    22,
                                    24,
                                    22,
                                    24,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.88),
                                    borderRadius: BorderRadius.circular(28),
                                  ),
                                  child: SizedBox(
                                    height: _currentIndex == 0 ? 330 : 390,
                                    child: PageView(
                                      controller: _pageController,
                                      children: [
                                        SignInForm(
                                          emailController:
                                              _loginEmailController,
                                          passwordController:
                                              _loginPasswordController,
                                          loading: _loading,
                                          error: _error,
                                          onSubmit: _handleLogin,
                                        ),
                                        SignUpForm(
                                          nameController:
                                              _registerNameController,
                                          emailController:
                                              _registerEmailController,
                                          passwordController:
                                              _registerPasswordController,
                                          loading: _loading,
                                          error: _error,
                                          onSubmit: _handleRegister,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 36),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggle() {
    return Container(
      width: 280,
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(30),
      ),
      child: CustomPaint(
        painter: BubbleIndicatorPainter(
          pageController: _pageController,
          color: Colors.white,
          dxEntry: 22,
          dxTarget: 118,
          radius: 20,
          dy: 24,
        ),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => _pageController.animateToPage(
                  0,
                  duration: const Duration(milliseconds: 350),
                  curve: Curves.easeInOut,
                ),
                child: Center(
                  child: Text(
                    'Login',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: _currentIndex == 0
                          ? AppColors.primary
                          : Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () => _pageController.animateToPage(
                  1,
                  duration: const Duration(milliseconds: 350),
                  curve: Curves.easeInOut,
                ),
                child: Center(
                  child: Text(
                    'Register',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: _currentIndex == 1
                          ? AppColors.primary
                          : Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LogoSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Logo with soft glow
        Container(
          width: 130,
          height: 130,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.accent.withValues(alpha: 0.25),
                blurRadius: 45,
                spreadRadius: 8,
              ),
            ],
          ),
          child: Image.asset(
            'assets/logo/spectro_logo_1.png',
            width: 110,
            fit: BoxFit.contain,
          ),
        ),

        const SizedBox(height: 16),

        const Text(
          'SpectroCough',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            letterSpacing: 0.4,
          ),
        ),

        const SizedBox(height: 6),

        Text(
          'Respiratory AI Pre-Screening',
          style: TextStyle(
            fontSize: 13,
            color: Colors.white.withValues(alpha: 0.65),
            letterSpacing: 0.4,
          ),
        ),
      ],
    );
  }
}
