import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Enum to specify the display shape of PIN/OTP cells.
enum PinStyle {
  /// Rounded box shape.
  box,

  /// Underline shape.
  underline,

  /// Circular shape.
  circle,
}

/// Theme class to customize the visual representation of PIN cells.
class PinTheme {
  /// Width of each PIN cell.
  final double cellWidth;

  /// Height of each PIN cell.
  final double cellHeight;

  /// Spacing between PIN cells.
  final double spacing;

  /// Border radius of the cell (only applies to [PinStyle.box]).
  final BorderRadius borderRadius;

  /// Background color of the cell in empty state.
  final Color emptyColor;

  /// Background color of the cell when a character is entered.
  final Color filledColor;

  /// Background color of the cell when focused.
  final Color focusedColor;

  /// Background color of the cell when in error state.
  final Color errorColor;

  /// Border color of the cell in empty state.
  final Color emptyBorderColor;

  /// Border color of the cell when filled.
  final Color filledBorderColor;

  /// Border color of the cell when focused.
  final Color focusedBorderColor;

  /// Border color of the cell in error state.
  final Color errorBorderColor;

  /// Thickness of the cell borders.
  final double borderWidth;

  /// Font style for characters inside the cell.
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

/// A highly customizable PIN/OTP input field component (supporting box/underline/circle styles,
/// error shake, and auto-submit) that can also function as a premium standard text field.
class PinView extends StatefulWidget {
  /// Whether this input is configured as a PIN/OTP field.
  final bool isPinMode;

  /// Length of the PIN/OTP (only applies if [isPinMode] is true).
  final int pinLength;

  /// The styling template for the PIN cells (Box, Underline, or Circle).
  final PinStyle pinStyle;

  /// Theme customization for the PIN cells.
  final PinTheme? pinTheme;

  /// Callback when the entered PIN changes.
  final ValueChanged<String>? onPinChanged;

  /// Callback triggered automatically when all PIN characters have been entered.
  final ValueChanged<String>? onPinCompleted;

  /// Controller to control the text value of the input.
  final TextEditingController? controller;

  /// Focus node to manage focus state.
  final FocusNode? focusNode;

  /// Force an error text to display, highlighting the field in error state.
  final String? errorText;

  /// Custom validation logic.
  final FormFieldValidator<String>? validator;

  /// List of formatters to apply to text changes.
  final List<TextInputFormatter>? inputFormatters;

  /// The type of keyboard to display.
  final TextInputType keyboardType;

  /// Whether the input text should be masked (e.g. for passwords or PINs).
  final bool obscureText;

  /// The character used to mask obscured text (defaults to '•').
  final String obscuringCharacter;

  /// Whether to show the standard eye icon to toggle masking (standard text input mode only).
  final bool showPasswordToggle;

  /// Suffix widget (standard text input mode only).
  final Widget? suffixIcon;

  /// Prefix widget (standard text input mode only).
  final Widget? prefixIcon;

  /// Input decoration to override default appearance (standard text input mode only).
  final InputDecoration? decoration;

  /// Style of the text field's input text (standard text input mode only).
  final TextStyle? style;

  /// Whether the field should automatically request focus when rendered.
  final bool autoFocus;

  /// Hint text shown when input is empty (standard text input mode only).
  final String? hintText;

  /// Label text shown as floating label (standard text input mode only).
  final String? labelText;

  /// Border customization for standard text input mode (e.g. OutlineInputBorder, UnderlineInputBorder).
  final InputBorder? border;

  /// Border customization when standard field is focused.
  final InputBorder? focusedBorder;

  /// Border customization when standard field has an error.
  final InputBorder? errorBorder;

  /// Background color of the text field container (standard text input mode only).
  final Color? fillColor;

  /// Whether the text field container should be filled with [fillColor].
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

  /// Convenient email validator helper.
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email address is required';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  /// Convenient required field validator helper.
  static String? validateRequired(String? value, {String fieldName = 'Field'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

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

    // Set up horizontal shake animation for errors
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

    // Trigger shake animation when error status is activated or error text changes
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

  /// Public method to trigger the error shake animation programmatically.
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
        // Highlight active cell if it's the next character to be entered
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

        // Contents of this PIN box/circle
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
            child = const _BlinkingCursorWidget();
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
          // Box style
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

          // Listen to changes to run validation sync
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
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Render Pin Cells
                      _buildPinCells(),
                      // Completely transparent overlay TextField
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
      // Standard Text Field mode
      final hasPasswordToggle = widget.obscureText && widget.showPasswordToggle;

      return TextFormField(
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
        autofocus: widget.autoFocus,
        style: widget.style,
        decoration: widget.decoration ??
            InputDecoration(
              hintText: widget.hintText,
              labelText: widget.labelText,
              prefixIcon: widget.prefixIcon,
              errorText: widget.errorText,
              fillColor: widget.fillColor,
              filled: widget.filled,
              border: widget.border ??
                  OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                  ),
              focusedBorder: widget.focusedBorder ??
                  OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF1E88E5), width: 2),
                  ),
              errorBorder: widget.errorBorder ??
                  OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE53935), width: 1.5),
                  ),
              suffixIcon: hasPasswordToggle
                  ? IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    )
                  : widget.suffixIcon,
            ),
      );
    }
  }
}

/// Blinking cursor animation widget for PIN inputs.
class _BlinkingCursorWidget extends StatefulWidget {
  const _BlinkingCursorWidget();

  @override
  State<_BlinkingCursorWidget> createState() => _BlinkingCursorWidgetState();
}

class _BlinkingCursorWidgetState extends State<_BlinkingCursorWidget>
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
