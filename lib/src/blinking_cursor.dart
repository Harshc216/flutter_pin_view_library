import 'package:flutter/material.dart';

class BlinkingCursorWidget extends StatefulWidget {
  const BlinkingCursorWidget({super.key});

  @override
  State<BlinkingCursorWidget> createState() => _BlinkingCursorWidgetState();
}

class _BlinkingCursorWidgetState extends State<BlinkingCursorWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animationController,
      child: Container(
        width: 2.0,
        height: 24.0,
        color: Theme.of(context).primaryColor,
      ),
    );
  }
}
