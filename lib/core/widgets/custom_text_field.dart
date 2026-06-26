import 'package:flutter/material.dart';

import '../config/theme/app_colors.dart';
import 'custom_animated_container.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final IconData? icon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final int maxLines;
  final String? Function(String?)? validator;
  final void Function(String)? onFieldSubmitted;
  final bool isRequired;
  final bool enabled;
  final Widget? suffix;
  final Iterable<String>? autofillHints;
  final TextCapitalization textCapitalization;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.icon,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.maxLines = 1,
    this.validator,
    this.onFieldSubmitted,
    this.isRequired = true,
    this.enabled = true,
    this.suffix,
    this.autofillHints,
    this.textCapitalization = TextCapitalization.none,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late final FocusNode _focusNode;
  bool _hasFocus = false;
  bool _obscured = true;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode()
      ..addListener(() {
        if (mounted) setState(() => _hasFocus = _focusNode.hasFocus);
      });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final borderColor = _hasFocus ? AppColors.primary : AppColors.outline;
    final iconColor = _hasFocus ? AppColors.primary : AppColors.textMuted;

    return CustomAnimatedContainer(
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: widget.enabled ? 0.96 : 0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: _hasFocus ? 1.4 : 1),
        boxShadow: [
          if (_hasFocus)
            BoxShadow(
              blurRadius: 18,
              offset: const Offset(0, 8),
              color: AppColors.primary.withValues(alpha: 0.12),
            ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              children: [
                if (widget.isRequired)
                  const TextSpan(
                    text: '* ',
                    style: TextStyle(
                      color: AppColors.error,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                TextSpan(
                  text: widget.label,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: _hasFocus ? AppColors.primary : AppColors.text,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: widget.controller,
            focusNode: _focusNode,
            enabled: widget.enabled,
            obscureText: widget.obscureText && _obscured,
            keyboardType: widget.keyboardType,
            textInputAction: widget.textInputAction,
            autofillHints: widget.autofillHints,
            textCapitalization: widget.textCapitalization,
            enableSuggestions: !widget.obscureText,
            autocorrect: !widget.obscureText,
            maxLines: widget.obscureText ? 1 : widget.maxLines,
            validator: widget.validator,
            onFieldSubmitted: widget.onFieldSubmitted,
            cursorColor: AppColors.primary,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.text,
              fontWeight: FontWeight.w600,
            ),
            decoration: InputDecoration(
              isDense: true,
              filled: false,
              hintText: widget.hint,
              hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textMuted.withValues(alpha: 0.72),
              ),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              focusedErrorBorder: InputBorder.none,
              contentPadding: const EdgeInsets.only(bottom: 8),
              errorStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: AppColors.error,
                fontWeight: FontWeight.w600,
              ),
              prefixIcon: widget.icon == null
                  ? null
                  : Padding(
                      padding: const EdgeInsetsDirectional.only(end: 10),
                      child: Icon(widget.icon, color: iconColor, size: 20),
                    ),
              prefixIconConstraints: const BoxConstraints(
                minWidth: 30,
                minHeight: 24,
              ),
              suffixIcon: _buildSuffix(iconColor),
              suffixIconConstraints: const BoxConstraints(
                minWidth: 38,
                minHeight: 34,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget? _buildSuffix(Color iconColor) {
    if (widget.suffix != null) return widget.suffix;
    if (!widget.obscureText) return null;
    return IconButton(
      visualDensity: VisualDensity.compact,
      padding: EdgeInsets.zero,
      tooltip: _obscured ? 'Show password' : 'Hide password',
      onPressed: () => setState(() => _obscured = !_obscured),
      icon: Icon(
        _obscured ? Icons.visibility_outlined : Icons.visibility_off_outlined,
        color: iconColor,
        size: 20,
      ),
    );
  }
}
