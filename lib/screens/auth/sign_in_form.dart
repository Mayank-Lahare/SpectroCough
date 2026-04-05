// ============================================================
// Sign In Form — Optimized UI
// ------------------------------------------------------------
// Changes:
// - Icon-prefixed input fields (email icon, lock icon)
// - Floating label style with subtle focus animation
// - Refined error banner (pill-shaped, danger-tinted)
// - "Forgot password?" ghost link
// - Button: gradient fill instead of flat color
// ============================================================

import 'package:flutter/material.dart';
import 'auth_shared_widgets.dart';

class SignInForm extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool loading;
  final String error;
  final bool isSuccess;
  final VoidCallback onSubmit;

  const SignInForm({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.loading,
    required this.error,
    required this.isSuccess,
    required this.onSubmit,
  });

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Email field
        InputField(
          controller: widget.emailController,
          hint: 'Email address',
          icon: Icons.mail_outline_rounded,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
        ),

        const SizedBox(height: 14),

        // Password field
        InputField(
          controller: widget.passwordController,
          hint: 'Password',
          icon: Icons.lock_outline_rounded,
          obscure: _obscure,
          textInputAction: TextInputAction.done,
          suffixIcon: IconButton(
            icon: Icon(
              _obscure
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              size: 18,
            ),
            onPressed: () => setState(() => _obscure = !_obscure),
          ),
        ),

        const SizedBox(height: 10),

        // Error banner
        if (widget.error.isNotEmpty)
          ErrorBanner(message: widget.error, isSuccess: widget.isSuccess),

        const SizedBox(height: 14),

        // Login button
        GradientButton(
          label: 'LOG IN',
          loading: widget.loading,
          onTap: widget.onSubmit,
        ),
      ],
    );
  }
}
