import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:isango_app/core/constants/app_routes.dart';
import 'package:isango_app/core/theme/app_colors.dart';
import 'package:isango_app/core/theme/app_spacing.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _agreeTerms = false;
  bool _hidePassword = true;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool _isValidEmail(String value) {
    final trimmed = value.trim();
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(trimmed);
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    if (!_agreeTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please accept Terms of Service and Privacy Policy.')),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sign up submitted (placeholder).')),
    );

    Navigator.pushReplacementNamed(
      context,
      AppRoutes.verifyEmail,
      arguments: _emailController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const background = Color(0xFF0F172A);
    const surface = Color(0xFF13131B);
    const outlineVariant = Color(0xFF464554);
    const primary = Color(0xFFC0C1FF);
    const primaryContainer = Color(0xFF8083FF);
    const onPrimaryContainer = Color(0xFF0D0096);
    const onSurface = Color(0xFFE4E1ED);
    const onSurfaceVariant = Color(0xFFC7C4D7);

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: surface,
        foregroundColor: onSurface,
        elevation: 0,
        centerTitle: false,
        title: Row(
          children: const [
            Icon(Icons.shield_outlined, color: primary),
            SizedBox(width: 8),
            Text(
              'AuthSecure',
              style: TextStyle(
                color: onSurface,
                fontSize: 20,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.2,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Positioned(
                right: -140,
                top: -140,
                child: Container(
                  width: 600,
                  height: 600,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0x338083FF),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.page,
                  AppSpacing.xl,
                  AppSpacing.page,
                  AppSpacing.xl,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 480),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: AppSpacing.lg),
                        Text(
                          'Create Account',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.displaySmall?.copyWith(
                            color: onSurface,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.8,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          'Start your secure journey today',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 40),
                        Form(
                          key: _formKey,
                          child: AutofillGroup(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const _CapsLabel(text: 'FULL NAME'),
                                const SizedBox(height: 8),
                                TextFormField(
                                  controller: _fullNameController,
                                  textInputAction: TextInputAction.next,
                                  autofillHints: const [AutofillHints.name],
                                  style: const TextStyle(color: onSurface),
                                  decoration: _pillDecoration(
                                    hint: 'John Doe',
                                    fill: const Color(0xFF1E293B),
                                    border: const Color(0xFF334155),
                                    hintColor: const Color(0xFF908FA0),
                                    focusColor: primary,
                                  ),
                                  validator: (value) {
                                    final v = (value ?? '').trim();
                                    if (v.isEmpty) return 'Full name is required';
                                    if (v.length < 2) return 'Please enter your full name';
                                    return null;
                                  },
                                ),
                                const SizedBox(height: AppSpacing.lg),
                                const _CapsLabel(text: 'EMAIL ADDRESS'),
                                const SizedBox(height: 8),
                                TextFormField(
                                  controller: _emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  autofillHints: const [AutofillHints.email],
                                  textInputAction: TextInputAction.next,
                                  style: const TextStyle(color: onSurface),
                                  decoration: _pillDecoration(
                                    hint: 'name@company.com',
                                    fill: const Color(0xFF1E293B),
                                    border: const Color(0xFF334155),
                                    hintColor: const Color(0xFF908FA0),
                                    focusColor: primary,
                                  ),
                                  validator: (value) {
                                    final v = (value ?? '').trim();
                                    if (v.isEmpty) return 'Email is required';
                                    if (!_isValidEmail(v)) return 'Enter a valid email';
                                    return null;
                                  },
                                ),
                                const SizedBox(height: AppSpacing.lg),
                                const _CapsLabel(text: 'PASSWORD'),
                                const SizedBox(height: 8),
                                TextFormField(
                                  controller: _passwordController,
                                  obscureText: _hidePassword,
                                  textInputAction: TextInputAction.done,
                                  autofillHints: const [AutofillHints.newPassword],
                                  style: const TextStyle(color: onSurface),
                                  decoration: _pillDecoration(
                                    hint: '••••••••',
                                    fill: const Color(0xFF1E293B),
                                    border: const Color(0xFF334155),
                                    hintColor: const Color(0xFF908FA0),
                                    focusColor: primary,
                                  ).copyWith(
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() => _hidePassword = !_hidePassword);
                                      },
                                      icon: Icon(
                                        _hidePassword
                                            ? Icons.visibility_outlined
                                            : Icons.visibility_off_outlined,
                                        color: onSurfaceVariant,
                                      ),
                                    ),
                                  ),
                                  onFieldSubmitted: (_) => _submit(),
                                  validator: (value) {
                                    final v = value ?? '';
                                    if (v.isEmpty) return 'Password is required';
                                    if (v.length < 6) return 'Password must be at least 6 characters';
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Transform.translate(
                                      offset: const Offset(0, -4),
                                      child: Checkbox(
                                        value: _agreeTerms,
                                        onChanged: (v) {
                                          setState(() => _agreeTerms = v ?? false);
                                        },
                                        activeColor: primary,
                                        checkColor: onPrimaryContainer,
                                        side: const BorderSide(color: Color(0xFF334155)),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 2),
                                        child: Text.rich(
                                          TextSpan(
                                            text: 'I agree to the ',
                                            style: const TextStyle(
                                              color: onSurfaceVariant,
                                              fontSize: 14,
                                              height: 1.4,
                                            ),
                                            children: [
                                              WidgetSpan(
                                                alignment: PlaceholderAlignment.baseline,
                                                baseline: TextBaseline.alphabetic,
                                                child: GestureDetector(
                                                  onTap: () {
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      const SnackBar(
                                                        content: Text('Terms of Service (placeholder).'),
                                                      ),
                                                    );
                                                  },
                                                  child: const Text(
                                                    'Terms of Service',
                                                    style: TextStyle(
                                                      color: primary,
                                                      fontWeight: FontWeight.w700,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const TextSpan(text: ' and '),
                                              WidgetSpan(
                                                alignment: PlaceholderAlignment.baseline,
                                                baseline: TextBaseline.alphabetic,
                                                child: GestureDetector(
                                                  onTap: () {
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      const SnackBar(
                                                        content: Text('Privacy Policy (placeholder).'),
                                                      ),
                                                    );
                                                  },
                                                  child: const Text(
                                                    'Privacy Policy',
                                                    style: TextStyle(
                                                      color: primary,
                                                      fontWeight: FontWeight.w700,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                SizedBox(
                                  height: 56,
                                  child: FilledButton(
                                    onPressed: _submit,
                                    style: FilledButton.styleFrom(
                                      backgroundColor: primaryContainer,
                                      foregroundColor: onPrimaryContainer,
                                      shape: const StadiumBorder(),
                                      elevation: 0,
                                      shadowColor: primaryContainer.withValues(alpha: 0.2),
                                    ),
                                    child: const Text(
                                      'Sign Up',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, AppRoutes.login);
                          },
                          child: Text.rich(
                            TextSpan(
                              text: 'Already have an account? ',
                              style: const TextStyle(color: onSurfaceVariant),
                              children: const [
                                TextSpan(
                                  text: 'Sign in',
                                  style: TextStyle(
                                    color: primary,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        _GlassPanel(
                          child: Row(
                            children: const [
                              _IconBadge(
                                background: Color(0x1AC0C1FF),
                                foreground: primary,
                                icon: Icons.lock_open_outlined,
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'SECURE PROTOCOL ACTIVE',
                                      style: TextStyle(
                                        color: primary,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 0.6,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      'Enterprise-Grade Security',
                                      style: TextStyle(
                                        color: onSurface,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        const Divider(color: outlineVariant, height: 1),
                        const SizedBox(height: AppSpacing.lg),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

InputDecoration _pillDecoration({
  required String hint,
  required Color fill,
  required Color border,
  required Color hintColor,
  required Color focusColor,
}) {
  return InputDecoration(
    hintText: hint,
    hintStyle: TextStyle(color: hintColor),
    filled: true,
    fillColor: fill,
    contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(999),
      borderSide: BorderSide(color: border),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(999),
      borderSide: BorderSide(color: border),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(999),
      borderSide: BorderSide(color: focusColor, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(999),
      borderSide: const BorderSide(color: AppColors.criticalRed),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(999),
      borderSide: const BorderSide(color: AppColors.criticalRed, width: 2),
    ),
  );
}

class _CapsLabel extends StatelessWidget {
  const _CapsLabel({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.6,
          color: Color(0xFFC7C4D7),
        ),
      ),
    );
  }
}

class _GlassPanel extends StatelessWidget {
  const _GlassPanel({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xB31E293B),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0x80334555)),
          ),
          child: child,
        ),
      ),
    );
  }
}

class _IconBadge extends StatelessWidget {
  const _IconBadge({
    required this.background,
    required this.foreground,
    required this.icon,
  });

  final Color background;
  final Color foreground;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: background,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Icon(icon, color: foreground, size: 20),
    );
  }
}