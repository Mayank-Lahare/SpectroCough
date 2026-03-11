// ============================================================
// Sign Up Form — Optimized UI
// ============================================================

import 'package:flutter/material.dart';
import 'auth_shared_widgets.dart';

class SignUpForm extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool loading;
  final String error;
  final VoidCallback onSubmit;

  const SignUpForm({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.loading,
    required this.error,
    required this.onSubmit,
  });

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  bool _obscure = true;

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

        const SizedBox(height: 16),

        // Error banner
        if (widget.error.isNotEmpty)
          ErrorBanner(message: widget.error),

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
}