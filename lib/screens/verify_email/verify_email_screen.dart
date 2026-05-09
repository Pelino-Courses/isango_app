import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:isango_app/core/constants/app_routes.dart';
import 'package:isango_app/core/theme/app_colors.dart';
import 'package:isango_app/core/theme/app_spacing.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  State<EmailVerificationScreen> createState() => _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  static const _codeLength = 6;
  static const _resendCooldownSeconds = 30;

  final _formKey = GlobalKey<FormState>();
  late final List<TextEditingController> _digitControllers;
  late final List<FocusNode> _digitFocusNodes;

  Timer? _timer;
  int _secondsRemaining = _resendCooldownSeconds;

  @override
  void initState() {
    super.initState();
    _digitControllers = List.generate(_codeLength, (_) => TextEditingController());
    _digitFocusNodes = List.generate(_codeLength, (_) => FocusNode());
    _startCooldown();
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final c in _digitControllers) {
      c.dispose();
    }
    for (final n in _digitFocusNodes) {
      n.dispose();
    }
    super.dispose();
  }

  void _startCooldown() {
    _timer?.cancel();
    setState(() {
      _secondsRemaining = _resendCooldownSeconds;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      if (_secondsRemaining <= 1) {
        t.cancel();
        setState(() => _secondsRemaining = 0);
      } else {
        setState(() => _secondsRemaining -= 1);
      }
    });
  }

  String get _code => _digitControllers.map((c) => c.text).join();

  String? _maskedEmail(String? email) {
    final e = (email ?? '').trim();
    if (e.isEmpty || !e.contains('@')) return null;
    final parts = e.split('@');
    if (parts.length != 2) return null;
    final user = parts[0];
    final domain = parts[1];
    if (user.isEmpty) return null;
    final shown = user.length <= 2 ? user[0] : user.substring(0, 2);
    return '$shown***@$domain';
  }

  void _verify() {
    FocusScope.of(context).unfocus();
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Email verified (placeholder).')),
    );

    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.home,
      (route) => false,
    );
  }

  void _resend() {
    if (_secondsRemaining > 0) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Verification email resent (placeholder).')),
    );
    _startCooldown();
  }

  void _onDigitChanged(int index, String value) {
    final v = value.replaceAll(RegExp(r'\D'), '');
    if (v.isEmpty) return;

    // Handle paste of multiple digits into one field.
    if (v.length > 1) {
      var writeIndex = index;
      for (final ch in v.split('')) {
        if (writeIndex >= _codeLength) break;
        _digitControllers[writeIndex].text = ch;
        writeIndex++;
      }
      final next = writeIndex.clamp(0, _codeLength - 1);
      _digitFocusNodes[next].requestFocus();
      setState(() {});
      return;
    }

    if (_digitControllers[index].text != v) {
      _digitControllers[index].text = v;
      _digitControllers[index].selection = TextSelection.fromPosition(
        const TextPosition(offset: 1),
      );
    }

    if (index < _codeLength - 1) {
      _digitFocusNodes[index + 1].requestFocus();
    } else {
      _digitFocusNodes[index].unfocus();
    }
    setState(() {});
  }

  KeyEventResult _onDigitKey(int index, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    if (event.logicalKey == LogicalKeyboardKey.backspace) {
      if (_digitControllers[index].text.isNotEmpty) {
        _digitControllers[index].clear();
        setState(() {});
        return KeyEventResult.handled;
      }
      if (index > 0) {
        _digitControllers[index - 1].clear();
        _digitFocusNodes[index - 1].requestFocus();
        setState(() {});
        return KeyEventResult.handled;
      }
    }
    if (event.logicalKey == LogicalKeyboardKey.arrowLeft && index > 0) {
      _digitFocusNodes[index - 1].requestFocus();
      return KeyEventResult.handled;
    }
    if (event.logicalKey == LogicalKeyboardKey.arrowRight && index < _codeLength - 1) {
      _digitFocusNodes[index + 1].requestFocus();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final emailArg = ModalRoute.of(context)?.settings.arguments;
    final email = emailArg is String ? emailArg.trim() : null;
    final masked = _maskedEmail(email);

    final resendEnabled = _secondsRemaining == 0;
    const background = Color(0xFF0F172A);
    const surface = Color(0xFF13131B);
    const surfaceContainerHighest = Color(0xFF34343D);
    const surfaceContainerLow = Color(0xFF1B1B23);
    const outlineVariant = Color(0xFF464554);
    const primary = Color(0xFFC0C1FF);
    const onPrimary = Color(0xFF1000A9);
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
        actions: [
          IconButton(
            tooltip: 'Close',
            onPressed: () {
              Navigator.popUntil(context, (route) => route.isFirst);
            },
            icon: const Icon(Icons.close, color: onSurfaceVariant),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.page,
                  AppSpacing.lg,
                  AppSpacing.page,
                  AppSpacing.lg,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 480),
                    child: Form(
                      key: _formKey,
                      child: _GlassPanel(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(height: 4),
                            Center(
                              child: SizedBox(
                                width: 128,
                                height: 128,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Container(
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color(0x1AC0C1FF),
                                      ),
                                    ),
                                    Container(
                                      width: 96,
                                      height: 96,
                                      decoration: BoxDecoration(
                                        color: surfaceContainerHighest,
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(color: outlineVariant),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Color(0x66000000),
                                            blurRadius: 24,
                                            offset: Offset(0, 12),
                                          ),
                                        ],
                                      ),
                                      child: Stack(
                                        children: [
                                          const Center(
                                            child: Icon(
                                              Icons.mail_outline,
                                              color: primary,
                                              size: 44,
                                            ),
                                          ),
                                          Positioned(
                                            top: 8,
                                            right: 8,
                                            child: Container(
                                              padding: const EdgeInsets.all(4),
                                              decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: primaryContainer,
                                              ),
                                              child: const Icon(
                                                Icons.lock,
                                                size: 16,
                                                color: onPrimaryContainer,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Verify your email',
                              textAlign: TextAlign.center,
                              style: theme.textTheme.headlineSmall?.copyWith(
                                color: onSurface,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.2,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text.rich(
                              TextSpan(
                                text: "We've sent a 6-digit security code to ",
                                style: const TextStyle(
                                  color: onSurfaceVariant,
                                  fontSize: 14,
                                  height: 1.4,
                                ),
                                children: [
                                  TextSpan(
                                    text: masked ?? (email?.isNotEmpty == true ? email : 'your email'),
                                    style: const TextStyle(
                                      color: primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const TextSpan(
                                    text: '. Please enter it below to secure your session.',
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 18),
                            Center(
                              child: Wrap(
                                spacing: 8,
                                children: List.generate(_codeLength, (i) {
                                  return SizedBox(
                                    width: 44,
                                    height: 56,
                                    child: Focus(
                                      focusNode: _digitFocusNodes[i],
                                      onKeyEvent: (node, event) => _onDigitKey(i, event),
                                      child: TextFormField(
                                        controller: _digitControllers[i],
                                        keyboardType: TextInputType.number,
                                        textAlign: TextAlign.center,
                                        maxLength: 1,
                                        style: const TextStyle(
                                          color: primary,
                                          fontSize: 24,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: 0.2,
                                        ),
                                        decoration: _otpDecoration(
                                          fill: const Color(0xFF1F1F27),
                                          border: outlineVariant,
                                          focusColor: primary,
                                        ),
                                        onChanged: (v) => _onDigitChanged(i, v),
                                        textInputAction:
                                            i == _codeLength - 1 ? TextInputAction.done : TextInputAction.next,
                                        onFieldSubmitted: (_) {
                                          if (i == _codeLength - 1) _verify();
                                        },
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Builder(
                              builder: (context) {
                                // Invisible field gives us a single form validator/error message for the code.
                                return TextFormField(
                                  key: const ValueKey('otp_form_field'),
                                  enabled: false,
                                  decoration: const InputDecoration(
                                    isDense: true,
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                  validator: (_) {
                                    final v = _code.trim();
                                    if (v.isEmpty) return 'Verification code is required';
                                    if (v.length != _codeLength) return 'Code must be $_codeLength digits';
                                    if (!RegExp(r'^\d+$').hasMatch(v)) return 'Code must contain only numbers';
                                    return null;
                                  },
                                );
                              },
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              height: 56,
                              child: FilledButton(
                                onPressed: _verify,
                                style: FilledButton.styleFrom(
                                  backgroundColor: primary,
                                  foregroundColor: onPrimary,
                                  shape: const StadiumBorder(),
                                  elevation: 0,
                                ),
                                child: const Text(
                                  'Verify',
                                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                                ),
                              ),
                            ),
                            const SizedBox(height: 18),
                            const Text(
                              "Didn't receive the code?",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: onSurfaceVariant,
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.0,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextButton(
                              onPressed: resendEnabled ? _resend : null,
                              style: TextButton.styleFrom(foregroundColor: primary),
                              child: Text(
                                resendEnabled ? 'Resend Code' : 'Resend Code in $_secondsRemaining s',
                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                              ),
                            ),
                            const SizedBox(height: 4),
                            TextButton(
                              onPressed: () {
                                Navigator.pushReplacementNamed(context, AppRoutes.signUp);
                              },
                              style: TextButton.styleFrom(foregroundColor: onSurfaceVariant),
                              child: const Text('Change email'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(AppSpacing.page, 0, AppSpacing.page, AppSpacing.lg),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: surfaceContainerLow,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: outlineVariant),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.enhanced_encryption_outlined, size: 16, color: primary),
                      SizedBox(width: 8),
                      Text(
                        'End-to-end encrypted session',
                        style: TextStyle(
                          color: onSurfaceVariant,
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.6,
                        ),
                      ),
                    ],
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

InputDecoration _otpDecoration({
  required Color fill,
  required Color border,
  required Color focusColor,
}) {
  return InputDecoration(
    counterText: '',
    filled: true,
    fillColor: fill,
    contentPadding: const EdgeInsets.symmetric(vertical: 14),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: border),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: focusColor, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: AppColors.criticalRed),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: AppColors.criticalRed, width: 2),
    ),
  );
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
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xB31E293B),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF334155)),
          ),
          child: child,
        ),
      ),
    );
  }
}

