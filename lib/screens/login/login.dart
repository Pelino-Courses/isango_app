import 'package:flutter/material.dart';
import 'package:isango_app/core/constants/app_routes.dart';
import 'package:isango_app/core/theme/app_colors.dart';
import 'package:isango_app/core/theme/app_spacing.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _hidePassword = true;

  @override
  void dispose() {
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

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Login submitted (placeholder).')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const background = Color(0xFF0F172A);
    const surface = Color(0xFF13131B);
    const surfaceContainer = Color(0xFF1F1F27);
    const outlineVariant = Color(0xFF464554);
    const primary = Color(0xFFC0C1FF);
    const onPrimary = Color(0xFF1000A9);
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
                right: -120,
                top: -120,
                child: Container(
                  width: 500,
                  height: 500,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0x1AC0C1FF),
                  ),
                ),
              ),
              Positioned(
                left: -120,
                bottom: -120,
                child: Container(
                  width: 500,
                  height: 500,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0x0DFFB783),
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
                          'Welcome Back',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.displaySmall?.copyWith(
                            color: onSurface,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.6,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          'Enter your credentials to access your secure vault.',
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
                                const _CapsLabel(text: 'EMAIL ADDRESS'),
                                const SizedBox(height: 8),
                                TextFormField(
                                  controller: _emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  autofillHints: const [AutofillHints.email],
                                  textInputAction: TextInputAction.next,
                                  style: const TextStyle(color: onSurface),
                                  decoration: _pillDecoration(
                                    label: null,
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
                                Row(
                                  children: [
                                    const Expanded(child: _CapsLabel(text: 'PASSWORD')),
                                    TextButton(
                                      onPressed: () {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text('Forgot password (placeholder).'),
                                          ),
                                        );
                                      },
                                      style: TextButton.styleFrom(
                                        foregroundColor: primary,
                                        padding: const EdgeInsets.symmetric(horizontal: 12),
                                      ),
                                      child: const Text(
                                        'Forgot Password?',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 0.6,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                TextFormField(
                                  controller: _passwordController,
                                  obscureText: _hidePassword,
                                  autofillHints: const [AutofillHints.password],
                                  textInputAction: TextInputAction.done,
                                  style: const TextStyle(color: onSurface),
                                  decoration: _pillDecoration(
                                    label: null,
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
                                const SizedBox(height: AppSpacing.lg),
                                SizedBox(
                                  height: 56,
                                  child: FilledButton(
                                    onPressed: _submit,
                                    style: FilledButton.styleFrom(
                                      backgroundColor: primary,
                                      foregroundColor: onPrimary,
                                      shape: const StadiumBorder(),
                                      elevation: 0,
                                    ),
                                    child: const Text(
                                      'Sign In',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: const [
                            Expanded(child: Divider(color: outlineVariant, height: 1)),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              child: Text(
                                'OR CONTINUE WITH',
                                style: TextStyle(
                                  color: onSurfaceVariant,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.6,
                                ),
                              ),
                            ),
                            Expanded(child: Divider(color: outlineVariant, height: 1)),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(
                              child: _SocialButton(
                                label: 'Google',
                                background: surfaceContainer,
                                border: outlineVariant,
                                foreground: onSurface,
                                icon: Icons.g_mobiledata,
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Google sign-in (placeholder).')),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 24),
                            Expanded(
                              child: _SocialButton(
                                label: 'Apple',
                                background: surfaceContainer,
                                border: outlineVariant,
                                foreground: onSurface,
                                icon: Icons.apple,
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Apple sign-in (placeholder).')),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, AppRoutes.signUp);
                          },
                          child: Text.rich(
                            TextSpan(
                              text: "Don't have an account? ",
                              style: const TextStyle(color: onSurfaceVariant),
                              children: const [
                                TextSpan(
                                  text: 'Sign up',
                                  style: TextStyle(
                                    color: primary,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
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
  required String? label,
  required String hint,
  required Color fill,
  required Color border,
  required Color hintColor,
  required Color focusColor,
}) {
  return InputDecoration(
    labelText: label,
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
          fontWeight: FontWeight.w700,
          letterSpacing: 0.6,
          color: Color(0xFFC7C4D7),
        ),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({
    required this.label,
    required this.background,
    required this.border,
    required this.foreground,
    required this.icon,
    required this.onPressed,
  });

  final String label;
  final Color background;
  final Color border;
  final Color foreground;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: background,
          foregroundColor: foreground,
          side: BorderSide(color: border),
          shape: const StadiumBorder(),
        ),
        icon: Icon(icon),
        label: Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}