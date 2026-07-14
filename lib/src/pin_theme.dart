import 'package:flutter/material.dart';

enum PinStyle {
  box,
  underline,
  circle,
}

class PinTheme {
  final double cellWidth;
  final double cellHeight;
  final double spacing;
  final BorderRadius borderRadius;
  final Color emptyColor;
  final Color filledColor;
  final Color focusedColor;
  final Color errorColor;
  final Color emptyBorderColor;
  final Color filledBorderColor;
  final Color focusedBorderColor;
  final Color errorBorderColor;
  final double borderWidth;
  final TextStyle? textStyle;

  const PinTheme({
    this.cellWidth = 55.0,
    this.cellHeight = 60.0,
    this.spacing = 12.0,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
    this.emptyColor = Colors.transparent,
    this.filledColor = Colors.transparent,
    this.focusedColor = Colors.transparent,
    this.errorColor = Colors.transparent,
    this.emptyBorderColor = const Color(0xFFE0E0E0),
    this.filledBorderColor = const Color(0xFF42A5F5),
    this.focusedBorderColor = const Color(0xFF1E88E5),
    this.errorBorderColor = const Color(0xFFE53935),
    this.borderWidth = 1.5,
    this.textStyle,
  });
}
