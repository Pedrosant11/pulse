import 'dart:async';

import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pulse/core/extensions/context_extensions.dart';
import 'package:pulse/features/auth/domain/auth_validators.dart';

export 'package:pulse/core/widgets/form_error_text.dart';

/// Password input with show/hide toggle.
class PasswordField extends StatefulWidget {
  const new({
    required this.controller,
    required this.label,
    this.validator,
    this.onChanged,
    this.textInputAction = TextInputAction.next,
    this.onSubmitted,
    this.autofillHints = const [AutofillHints.password],
    super.key,
  });

  final TextEditingController controller;
  final String label;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final TextInputAction textInputAction;
  final ValueChanged<String>? onSubmitted;
  final Iterable<String> autofillHints;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscured = true;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return TextFormField(
      controller: widget.controller,
      obscureText: _obscured,
      autocorrect: false,
      enableSuggestions: false,
      autofillHints: widget.autofillHints,
      textInputAction: widget.textInputAction,
      onFieldSubmitted: widget.onSubmitted,
      onChanged: widget.onChanged,
      validator: widget.validator,
      decoration: InputDecoration(
        labelText: widget.label,
        suffixIcon: IconButton(
          tooltip: _obscured ? l10n.showPassword : l10n.hidePassword,
          icon: Icon(
            _obscured
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
          ),
          onPressed: () => setState(() => _obscured = !_obscured),
        ),
      ),
    );
  }
}

/// Four-segment strength meter under the password field.
class PasswordStrengthMeter extends StatelessWidget {
  const new({required this.password, super.key});

  final String password;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final strength = AuthValidators.passwordStrength(password);
    final (filled, color, label) = switch (strength) {
      PasswordStrength.weak => (1, colors.error, l10n.passwordStrengthWeak),
      PasswordStrength.fair => (2, colors.lime, l10n.passwordStrengthFair),
      PasswordStrength.good => (3, colors.cyan, l10n.passwordStrengthGood),
      PasswordStrength.strong => (
        4,
        colors.success,
        l10n.passwordStrengthStrong,
      ),
    };
    final duration = context.reduceMotion
        ? Duration.zero
        : const Duration(milliseconds: 250);

    return Semantics(
      liveRegion: true,
      label: label,
      child: ExcludeSemantics(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                for (var i = 0; i < 4; i++) ...[
                  if (i > 0) SizedBox(width: context.spacing.xxs),
                  Expanded(
                    child: AnimatedContainer(
                      duration: duration,
                      height: 4,
                      decoration: BoxDecoration(
                        color: password.isNotEmpty && i < filled
                            ? color
                            : colors.surfaceElevated,
                        borderRadius: BorderRadius.circular(context.radii.pill),
                      ),
                    ),
                  ),
                ],
              ],
            ),
            if (password.isNotEmpty) ...[
              SizedBox(height: context.spacing.xxs),
              Text(
                label,
                style: context.textTheme.labelSmall?.copyWith(color: color),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Text button that stays disabled during a cooldown, showing the seconds
/// left. Restart the cooldown by changing [cooldownStartedAt].
class CooldownButton extends StatefulWidget {
  const new({
    required this.label,
    required this.labelWithSeconds,
    required this.cooldown,
    required this.onPressed,
    this.cooldownStartedAt,
    super.key,
  });

  final String label;
  final String Function(int seconds) labelWithSeconds;
  final Duration cooldown;
  final DateTime? cooldownStartedAt;
  final VoidCallback? onPressed;

  @override
  State<CooldownButton> createState() => _CooldownButtonState();
}

class _CooldownButtonState extends State<CooldownButton> {
  Timer? _timer;
  int _remaining = 0;

  @override
  void initState() {
    super.initState();
    _restart();
  }

  @override
  void didUpdateWidget(CooldownButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.cooldownStartedAt != widget.cooldownStartedAt) _restart();
  }

  void _restart() {
    _timer?.cancel();
    _tick();
    if (_remaining > 0) {
      _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
    }
  }

  void _tick() {
    final startedAt = widget.cooldownStartedAt;
    final remaining = startedAt == null
        ? 0
        : (widget.cooldown - DateTime.now().difference(startedAt)).inSeconds;
    if (remaining <= 0) _timer?.cancel();
    if (mounted) setState(() => _remaining = remaining.clamp(0, 9999));
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final coolingDown = _remaining > 0;
    return TextButton(
      onPressed: coolingDown ? null : widget.onPressed,
      child: Text(
        coolingDown ? widget.labelWithSeconds(_remaining) : widget.label,
      ),
    );
  }
}

/// Blocks whitespace in e-mail fields.
final emailInputFormatters = <TextInputFormatter>[
  FilteringTextInputFormatter.deny(RegExp(r'\s')),
];
