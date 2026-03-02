// ============================================================
// Animated Authentication Screen
// ------------------------------------------------------------
// Responsibilities:
// - Gradient branded auth screen
// - Frosted glass form container
// - Login & Register with validation
// - Proper keyboard-safe layout
// - Back navigation to previous screen
// ============================================================

import 'dart:ui';
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../services/api_service.dart';
import 'widgets/sign_in_form.dart';
import 'widgets/sign_up_form.dart';
import 'widgets/bubble_indicator.dart';

class AnimatedAuthScreen extends StatefulWidget {
  const AnimatedAuthScreen({super.key});

  @override
  State<AnimatedAuthScreen> createState() => _AnimatedAuthScreenState();
}

class _AnimatedAuthScreenState extends State<AnimatedAuthScreen> {
  // ============================================================
  // Controllers
  // ============================================================

  final _loginEmailController = TextEditingController();
  final _loginPasswordController = TextEditingController();

  final _registerNameController = TextEditingController();
  final _registerEmailController = TextEditingController();
  final _registerPasswordController = TextEditingController();

  final PageController _pageController = PageController();

  int _currentIndex = 0;
  bool _loading = false;
  String _error = "";

  // ============================================================
  // Page Controller Listener (Toggle Active State)
  // ============================================================

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      final page = _pageController.page?.round() ?? 0;
      if (page != _currentIndex) {
        setState(() => _currentIndex = page);
      }
    });
  }

  // ============================================================
  // Validation Helpers
  // ============================================================

  bool _validateEmail(String email) =>
      email.contains("@") && email.contains(".") && email.length > 5;

  bool _validatePassword(String password) => password.length >= 8;

  // ============================================================
  // Login Handler
  // ============================================================

  Future<void> _handleLogin() async {
    final email = _loginEmailController.text.trim();
    final password = _loginPasswordController.text.trim();

    if (!_validateEmail(email)) {
      setState(() => _error = "Enter valid email");
      return;
    }

    if (!_validatePassword(password)) {
      setState(() => _error = "Password must be 8+ characters");
      return;
    }

    setState(() {
      _loading = true;
      _error = "";
    });

    final success = await ApiService.login(email, password);

    if (!mounted) return;
    setState(() => _loading = false);

    if (success) {
      Navigator.pop(context, true);
    } else {
      setState(() => _error = "Authentication failed");
    }
  }

  // ============================================================
  // Register Handler
  // ============================================================

  Future<void> _handleRegister() async {
    final name = _registerNameController.text.trim();
    final email = _registerEmailController.text.trim();
    final password = _registerPasswordController.text.trim();

    if (name.isEmpty) {
      setState(() => _error = "Enter full name");
      return;
    }

    if (!_validateEmail(email)) {
      setState(() => _error = "Enter valid email");
      return;
    }

    if (!_validatePassword(password)) {
      setState(() => _error = "Password must be 8+ characters");
      return;
    }

    setState(() {
      _loading = true;
      _error = "";
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
      setState(() => _error = "Registration successful. Please login.");
    } else {
      setState(() => _error = "Registration failed");
    }
  }

  // ============================================================
  // UI
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.authGradient),
        child: SafeArea(
          child: Stack(
            children: [
              // ====================================================
              // Scrollable Full-Height Content
              // ====================================================
              LayoutBuilder(
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
                            const SizedBox(height: 72),

                            // Logo
                            Image.asset(
                              'assets/logo/spectro_logo_1.png',
                              height: 120,
                            ),

                            const SizedBox(height: 18),

                            // Toggle
                            _buildToggle(),

                            const SizedBox(height: 18),

                            // ====================================================
                            // Frosted Glass Container
                            // ====================================================
                            Align(
                              alignment: Alignment.topCenter,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(28),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(
                                    sigmaX: 15,
                                    sigmaY: 15,
                                  ),
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                    ),
                                    padding: const EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      color: AppColors.white.withValues(
                                        alpha: 0.85,
                                      ),
                                      borderRadius: BorderRadius.circular(28),
                                      border: Border.all(
                                        color: AppColors.white.withValues(
                                          alpha: 0.3,
                                        ),
                                      ),
                                    ),

                                    // Controlled height for form area
                                    child: SizedBox(
                                      height: 360,
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

                            const SizedBox(height: 40),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),

              // ====================================================
              // Back Button
              // ====================================================
              Positioned(
                top: 12,
                left: 12,
                child: InkWell(
                  borderRadius: BorderRadius.circular(30),
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // Toggle Bar UI
  // ============================================================

  Widget _buildToggle() {
    return Container(
      width: 300,
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(30),
      ),
      child: CustomPaint(
        painter: BubbleIndicatorPainter(
          pageController: _pageController,
          color: AppColors.white,
        ),
        child: Row(
          children: [
            Expanded(
              child: TextButton(
                onPressed: () => _pageController.animateToPage(
                  0,
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                ),
                child: Text(
                  "Login",
                  style: TextStyle(
                    color: _currentIndex == 0
                        ? AppColors.primary
                        : Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            Expanded(
              child: TextButton(
                onPressed: () => _pageController.animateToPage(
                  1,
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                ),
                child: Text(
                  "Register",
                  style: TextStyle(
                    color: _currentIndex == 1
                        ? AppColors.primary
                        : Colors.white,
                    fontWeight: FontWeight.w600,
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
