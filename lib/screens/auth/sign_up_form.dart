// ============================================================
// Sign Up Form — Optimized UI
// ============================================================

import 'package:flutter/material.dart';
import 'auth_shared_widgets.dart';
import 'package:spectrocough/theme/app_colors.dart';

class SignUpForm extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool loading;
  final String error;
  final bool isSuccess;
  final VoidCallback onSubmit;

  const SignUpForm({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.loading,
    required this.error,
    required this.isSuccess,
    required this.onSubmit,
  });

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  bool _obscure = true;
  String _passwordError = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Name
        InputField(
          controller: widget.nameController,
          hint: 'Full name',
          icon: Icons.person_outline,
        ),

        const SizedBox(height: 14),

        // Email
        InputField(
          controller: widget.emailController,
          hint: 'Email address',
          icon: Icons.mail_outline,
          keyboardType: TextInputType.emailAddress,
        ),

        const SizedBox(height: 14),

        // Password
        InputField(
          onChanged: (value) {
            setState(() {
              if (value.isEmpty) {
                _passwordError = '';
              } else if (!_validatePassword(value)) {
                _passwordError =
                    'Min 8 characters, include uppercase, number, and symbol';
              } else {
                _passwordError = '';
              }
            });
          },

          controller: widget.passwordController,
          hint: 'Password',
          icon: Icons.lock_outline,
          obscure: _obscure,
          suffixIcon: IconButton(
            icon: Icon(
              _obscure
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
            ),
            onPressed: () => setState(() => _obscure = !_obscure),
          ),
        ),

        if (_passwordError.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              _passwordError,
              style: TextStyle(fontSize: 11, color: AppColors.danger),
            ),
          ),

        const SizedBox(height: 16),

        // Error banner
        if (widget.error.isNotEmpty)
          ErrorBanner(message: widget.error, isSuccess: widget.isSuccess),

        const SizedBox(height: 12),

        // Submit button
        GradientButton(
          label: 'CREATE ACCOUNT',
          loading: widget.loading,
          onTap: widget.onSubmit,
        ),
      ],
    );
  }

  bool _validatePassword(String p) {
    final hasUpper = p.contains(RegExp(r'[A-Z]'));
    final hasLower = p.contains(RegExp(r'[a-z]'));
    final hasSpecial = p.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    final hasLength = p.length >= 8;

    return hasUpper && hasLower && hasSpecial && hasLength;
  }
}
