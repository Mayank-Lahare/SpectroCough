// ============================================================
// Login / Register Screen
// ------------------------------------------------------------
// Responsibilities:
// - Allow user to login
// - Allow user to register
// - Store JWT token
// - Return to previous screen on success
// ============================================================

import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../services/api_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLogin = true;
  bool _loading = false;
  String _error = "";

  // ============================================================
  // Handle Authentication
  // ============================================================

  Future<void> _handleAuth() async {
    setState(() {
      _loading = true;
      _error = "";
    });

    bool success;

    if (_isLogin) {
      success = await ApiService.login(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
    } else {
      success = await ApiService.register(
        _nameController.text.trim(),
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
    }

    if (!mounted) return;

    setState(() => _loading = false);

    if (success) {
      if (_isLogin) {
        Navigator.pop(context, true);
      } else {
        setState(() {
          _isLogin = true;
          _error = "Registration successful. Please login.";
        });
      }
    } else {
      setState(() => _error = "Authentication failed");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(title: Text(_isLogin ? 'Login' : 'Register')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              if (!_isLogin)
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(hintText: 'Name'),
                ),

              if (!_isLogin) const SizedBox(height: 16),

              TextField(
                controller: _emailController,
                decoration: const InputDecoration(hintText: 'Email'),
              ),

              const SizedBox(height: 16),

              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(hintText: 'Password'),
              ),

              const SizedBox(height: 16),

              if (_error.isNotEmpty)
                Text(_error, style: const TextStyle(color: Colors.red)),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _loading ? null : _handleAuth,
                  child: _loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          _isLogin ? 'Login' : 'Register',
                          style: AppTextStyles.buttonText,
                        ),
                ),
              ),

              const SizedBox(height: 12),

              TextButton(
                onPressed: () {
                  setState(() {
                    _isLogin = !_isLogin;
                    _error = "";
                  });
                },
                child: Text(
                  _isLogin
                      ? "Don't have an account? Register"
                      : "Already have an account? Login",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
