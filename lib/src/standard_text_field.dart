import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StandardTextFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final TextInputType keyboardType;
  final bool obscureText;
  final String obscuringCharacter;
  final List<TextInputFormatter>? inputFormatters;
  final FormFieldValidator<String>? validator;
  final bool autoFocus;
  final TextStyle? style;
  final String? hintText;
  final String? labelText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? errorText;
  final Color? fillColor;
  final bool? filled;
  final InputBorder? border;
  final InputBorder? focusedBorder;
  final InputBorder? errorBorder;
  final bool showPasswordToggle;
  final VoidCallback onToggleObscure;

  const StandardTextFieldWidget({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.keyboardType,
    required this.obscureText,
    required this.obscuringCharacter,
    required this.inputFormatters,
    required this.validator,
    required this.autoFocus,
    required this.style,
    required this.hintText,
    required this.labelText,
    required this.prefixIcon,
    required this.suffixIcon,
    required this.errorText,
    required this.fillColor,
    required this.filled,
    required this.border,
    required this.focusedBorder,
    required this.errorBorder,
    required this.showPasswordToggle,
    required this.onToggleObscure,
  });

  @override
  Widget build(BuildContext context) {
    final hasPasswordToggle = obscureText && showPasswordToggle;

    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardType,
      obscureText: obscureText,
      obscuringCharacter: obscuringCharacter,
      inputFormatters: inputFormatters,
      validator: validator,
      autofocus: autoFocus,
      style: style,
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        prefixIcon: prefixIcon,
        errorText: errorText,
        fillColor: fillColor,
        filled: filled,
        border: border ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
            ),
        focusedBorder: focusedBorder ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF1E88E5), width: 2),
            ),
        errorBorder: errorBorder ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE53935), width: 1.5),
            ),
        suffixIcon: hasPasswordToggle
            ? IconButton(
                icon: Icon(
                  obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                  color: Colors.grey,
                ),
                onPressed: onToggleObscure,
              )
            : suffixIcon,
      ),
    );
  }
}
