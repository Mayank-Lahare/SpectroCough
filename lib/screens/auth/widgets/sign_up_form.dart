// ============================================================
// Sign Up Form
// ------------------------------------------------------------
// Responsibilities:
// - Collect name, email, password
// - Explicit focus control (Name → Email → Password)
// - Prevent overflow when keyboard opens
// - Provide password visibility toggle
// - Trigger register callback
// ============================================================

import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';

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

  final FocusNode _nameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  @override
  void dispose() {
    _nameFocus.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ========================================================
                  // Name Field
                  // ========================================================
                  _inputField(
                    controller: widget.nameController,
                    hint: "Full Name",
                    focusNode: _nameFocus,
                    textInputAction: TextInputAction.next,
                    onSubmitted: (_) => _emailFocus.requestFocus(),
                  ),

                  const SizedBox(height: 20),

                  // ========================================================
                  // Email Field
                  // ========================================================
                  _inputField(
                    controller: widget.emailController,
                    hint: "Email",
                    focusNode: _emailFocus,
                    textInputAction: TextInputAction.next,
                    onSubmitted: (_) => _passwordFocus.requestFocus(),
                  ),

                  const SizedBox(height: 20),

                  // ========================================================
                  // Password Field
                  // ========================================================
                  _inputField(
                    controller: widget.passwordController,
                    hint: "Password",
                    focusNode: _passwordFocus,
                    obscure: _obscure,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => widget.onSubmit(),
                  ),

                  const SizedBox(height: 24),

                  // ========================================================
                  // Error / Success Message
                  // ========================================================
                  if (widget.error.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: SizedBox(
                        width: double.infinity,
                        child: Text(
                          widget.error,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: widget.error.contains("successful")
                                ? Colors.green
                                : AppColors.danger,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),

                  // ========================================================
                  // Register Button
                  // ========================================================
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: widget.loading ? null : widget.onSubmit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        elevation: 2,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: const StadiumBorder(),
                      ),
                      child: widget.loading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text("REGISTER", style: AppTextStyles.buttonText),
                    ),
                  ),

                  const Spacer(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  // Reusable Input Field
  // ============================================================

  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    required FocusNode focusNode,
    bool obscure = false,
    TextInputAction textInputAction = TextInputAction.next,
    Function(String)? onSubmitted,
  }) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      obscureText: obscure,
      textInputAction: textInputAction,
      onSubmitted: onSubmitted,
      style: const TextStyle(color: AppColors.textPrimary, fontSize: 16),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: AppColors.textSecondary.withValues(alpha: 0.7),
        ),
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        suffixIcon: hint == "Password"
            ? IconButton(
                icon: Icon(
                  _obscure ? Icons.visibility : Icons.visibility_off,
                  color: AppColors.textSecondary,
                ),
                onPressed: () => setState(() => _obscure = !_obscure),
              )
            : null,
      ),
    );
  }
}
