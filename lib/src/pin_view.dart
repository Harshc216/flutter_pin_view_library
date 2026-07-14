import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'pin_theme.dart';
import 'blinking_cursor.dart';
import 'standard_text_field.dart';

class PinView extends StatefulWidget {
  final bool isPinMode;
  final int pinLength;
  final PinStyle pinStyle;
  final PinTheme? pinTheme;
  final ValueChanged<String>? onPinChanged;
  final ValueChanged<String>? onPinCompleted;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? errorText;
  final FormFieldValidator<String>? validator;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType keyboardType;
  final bool obscureText;
  final String obscuringCharacter;
  final bool showPasswordToggle;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final InputDecoration? decoration;
  final TextStyle? style;
  final bool autoFocus;
  final String? hintText;
  final String? labelText;
  final InputBorder? border;
  final InputBorder? focusedBorder;
  final InputBorder? errorBorder;
  final Color? fillColor;
  final bool? filled;

  const PinView({
    super.key,
    this.isPinMode = false,
    this.pinLength = 4,
    this.pinStyle = PinStyle.box,
    this.pinTheme,
    this.onPinChanged,
    this.onPinCompleted,
    this.controller,
    this.focusNode,
    this.errorText,
    this.validator,
    this.inputFormatters,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.obscuringCharacter = '•',
    this.showPasswordToggle = true,
    this.suffixIcon,
    this.prefixIcon,
    this.decoration,
    this.style,
    this.autoFocus = false,
    this.hintText,
    this.labelText,
    this.border,
    this.focusedBorder,
    this.errorBorder,
    this.fillColor,
    this.filled,
  });

  @override
  State<PinView> createState() => PinViewState();
}

class PinViewState extends State<PinView> with SingleTickerProviderStateMixin {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  late final AnimationController _shakeController;
  late final Animation<double> _shakeAnimation;

  bool _obscureText = false;
  bool _hasError = false;

  TextEditingController get _effectiveController => widget.controller ?? _controller;
  FocusNode get _effectiveFocusNode => widget.focusNode ?? _focusNode;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _controller = TextEditingController();
    }
    if (widget.focusNode == null) {
      _focusNode = FocusNode();
    }
    _obscureText = widget.obscureText;

    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 450),
      vsync: this,
    );

    _shakeAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 12.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 12.0, end: -12.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -12.0, end: 10.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 10.0, end: -10.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -10.0, end: 6.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 6.0, end: -6.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -6.0, end: 0.0), weight: 1),
    ]).animate(CurvedAnimation(parent: _shakeController, curve: Curves.easeInOut));

    _effectiveFocusNode.addListener(_onFocusChange);
    _effectiveController.addListener(_onControllerChange);
  }

  void _onFocusChange() {
    setState(() {});
  }

  void _onControllerChange() {
    if (widget.isPinMode) {
      setState(() {});
    }
  }

  @override
  void didUpdateWidget(PinView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.obscureText != oldWidget.obscureText) {
      setState(() {
        _obscureText = widget.obscureText;
      });
    }

    if (widget.errorText != null && widget.errorText != oldWidget.errorText) {
      triggerShake();
    }
  }

  @override
  void dispose() {
    _effectiveFocusNode.removeListener(_onFocusChange);
    _effectiveController.removeListener(_onControllerChange);
    if (widget.controller == null) {
      _controller.dispose();
    }
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    _shakeController.dispose();
    super.dispose();
  }

  void triggerShake() {
    _shakeController.forward(from: 0.0);
  }

  Widget _buildPinCells() {
    final text = _effectiveController.text;
    final length = text.length;
    final theme = widget.pinTheme ?? const PinTheme();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.pinLength, (index) {
        final isFocused = _effectiveFocusNode.hasFocus &&
            (index == length || (index == widget.pinLength - 1 && length == widget.pinLength));
        final isFilled = index < length;

        Color cellColor = theme.emptyColor;
        Color borderColor = theme.emptyBorderColor;

        if (_hasError) {
          cellColor = theme.errorColor;
          borderColor = theme.errorBorderColor;
        } else if (isFocused) {
          cellColor = theme.focusedColor;
          borderColor = theme.focusedBorderColor;
        } else if (isFilled) {
          cellColor = theme.filledColor;
          borderColor = theme.filledBorderColor;
        }

        Widget child;
        if (isFilled) {
          final char = text[index];
          child = Text(
            _obscureText ? widget.obscuringCharacter : char,
            style: theme.textStyle ??
                const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
          );
        } else {
          if (isFocused) {
            child = const BlinkingCursorWidget();
          } else {
            child = const SizedBox.shrink();
          }
        }

        BoxDecoration decoration;
        if (widget.pinStyle == PinStyle.circle) {
          decoration = BoxDecoration(
            shape: BoxShape.circle,
            color: cellColor,
            border: Border.all(
              color: borderColor,
              width: theme.borderWidth,
            ),
          );
        } else if (widget.pinStyle == PinStyle.underline) {
          decoration = BoxDecoration(
            color: cellColor,
            border: Border(
              bottom: BorderSide(
                color: borderColor,
                width: theme.borderWidth,
              ),
            ),
          );
        } else {
          decoration = BoxDecoration(
            color: cellColor,
            border: Border.all(
              color: borderColor,
              width: theme.borderWidth,
            ),
            borderRadius: theme.borderRadius,
          );
        }

        return Container(
          width: theme.cellWidth,
          height: theme.cellHeight,
          margin: EdgeInsets.symmetric(horizontal: theme.spacing / 2),
          alignment: Alignment.center,
          decoration: decoration,
          child: child,
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isPinMode) {
      return FormField<String>(
        validator: widget.validator,
        initialValue: _effectiveController.text,
        builder: (FormFieldState<String> fieldState) {
          final hasValidationError = fieldState.hasError;
          _hasError = hasValidationError || widget.errorText != null;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedBuilder(
                animation: _shakeAnimation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(_shakeAnimation.value, 0),
                    child: child,
                  );
                },
                child: GestureDetector(
                  onTap: () {
                    if (!_effectiveFocusNode.hasFocus) {
                      _effectiveFocusNode.requestFocus();
                    }
                  },
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        _buildPinCells(),
                        Positioned.fill(
                          child: Opacity(
                            opacity: 0.0,
                            child: TextField(
                              controller: _effectiveController,
                              focusNode: _effectiveFocusNode,
                              keyboardType: widget.keyboardType,
                              autofocus: widget.autoFocus,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(widget.pinLength),
                                ...?widget.inputFormatters,
                              ],
                              obscureText: _obscureText,
                              enableInteractiveSelection: false,
                              showCursor: false,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.zero,
                                counterText: '',
                              ),
                              onChanged: (val) {
                                fieldState.didChange(val);
                                if (widget.onPinChanged != null) {
                                  widget.onPinChanged!(val);
                                }
                                if (val.length == widget.pinLength && widget.onPinCompleted != null) {
                                  widget.onPinCompleted!(val);
                                }
                                setState(() {});
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (_hasError) ...[
                const SizedBox(height: 8),
                Text(
                  widget.errorText ?? fieldState.errorText ?? '',
                  style: TextStyle(
                    color: (widget.pinTheme ?? const PinTheme()).errorBorderColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ],
          );
        },
      );
    } else {
      return StandardTextFieldWidget(
        controller: _effectiveController,
        focusNode: _effectiveFocusNode,
        keyboardType: widget.keyboardType,
        obscureText: _obscureText,
        obscuringCharacter: widget.obscuringCharacter,
        inputFormatters: widget.inputFormatters,
        validator: (value) {
          final error = widget.validator?.call(value);
          if (error != null) {
            triggerShake();
          }
          return error;
        },
        autoFocus: widget.autoFocus,
        style: widget.style,
        hintText: widget.hintText,
        labelText: widget.labelText,
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.suffixIcon,
        errorText: widget.errorText,
        fillColor: widget.fillColor,
        filled: widget.filled,
        border: widget.border,
        focusedBorder: widget.focusedBorder,
        errorBorder: widget.errorBorder,
        showPasswordToggle: widget.showPasswordToggle,
        onToggleObscure: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
      );
    }
  }
}
