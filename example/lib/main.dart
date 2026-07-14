import 'package:flutter/material.dart';
import 'package:flutter_pin_view_library/flutter_pin_view_library.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PinView Library Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1E88E5),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const PinDemoScreen(),
    );
  }
}

class PinDemoScreen extends StatefulWidget {
  const PinDemoScreen({super.key});

  @override
  State<PinDemoScreen> createState() => _PinDemoScreenState();
}

class _PinDemoScreenState extends State<PinDemoScreen> {
  final TextEditingController _pinController = TextEditingController();
  final GlobalKey<PinViewState> _pinFieldKey = GlobalKey<PinViewState>();

  String? _errorMessage;
  String? _successMessage;

  void _verifyPin() {
    final enteredPin = _pinController.text;

    setState(() {
      _errorMessage = null;
      _successMessage = null;
    });

    if (enteredPin.length < 4) {
      setState(() {
        _errorMessage = 'Please enter all 4 digits';
      });
      _pinFieldKey.currentState?.triggerShake();
      return;
    }

    if (enteredPin == '1234') {
      setState(() {
        _successMessage = 'Access Granted! PIN is correct.';
      });
      // Show a premium snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: const [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 12),
              Text('Verification Successful!', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    } else {
      setState(() {
        _errorMessage = 'Incorrect PIN. Try again!';
      });
      // Trigger the premium shake animation on our widget
      _pinFieldKey.currentState?.triggerShake();
      // Show error snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: const [
              Icon(Icons.error_outline, color: Colors.white),
              SizedBox(width: 12),
              Text('Incorrect PIN. Please try again.', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  void _clearPin() {
    _pinController.clear();
    setState(() {
      _errorMessage = null;
      _successMessage = null;
    });
  }

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        title: const Text(
          'PinView Library Examples',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(40),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              'Production-ready PIN/OTP input component',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Premium Card Container
              Container(
                width: double.infinity,
                constraints: const BoxConstraints(maxWidth: 450),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0x0A000000),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Example Title
                    const Text(
                      'Example 1: App Lock PIN',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E88E5), // Vibrant Blue
                      ),
                    ),
                    const SizedBox(height: 6),
                    // Specifications description matching the user's requirements
                    Text(
                      '4-digit • Box style • Masked • Error shake',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Correct PIN: 1234',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.green,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 36),

                    // Custom SmartTextInput Widget Instance
                    Center(
                      child: PinView(
                        key: _pinFieldKey,
                        isPinMode: true,
                        pinLength: 4,
                        pinStyle: PinStyle.box,
                        obscureText: true,
                        keyboardType: TextInputType.number,
                        controller: _pinController,
                        errorText: _errorMessage,
                        pinTheme: PinTheme(
                          cellWidth: 62,
                          cellHeight: 68,
                          spacing: 16,
                          borderRadius: BorderRadius.circular(16),
                          emptyBorderColor: Colors.grey.shade300,
                          filledBorderColor: const Color(0xFF1E88E5),
                          focusedBorderColor: const Color(0xFF1565C0),
                          errorBorderColor: Colors.red.shade400,
                          borderWidth: 2.0,
                          textStyle: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        onPinChanged: (value) {
                          // Clear error message dynamically when typing changes
                          if (_errorMessage != null) {
                            setState(() {
                              _errorMessage = null;
                            });
                          }
                        },
                        onPinCompleted: (value) {
                          // Optional: Auto submit or auto verify
                          debugPrint('PIN Completed: $value');
                        },
                      ),
                    ),

                    const SizedBox(height: 12),
                    if (_successMessage != null)
                      Center(
                        child: Text(
                          _successMessage!,
                          style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),

                    const SizedBox(height: 36),

                    // Button Row (Verify & Clear)
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _verifyPin,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1E88E5),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28),
                              ),
                            ),
                            child: const Text(
                              'Verify',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _clearPin,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.grey.shade700,
                              side: BorderSide(color: Colors.grey.shade300),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28),
                              ),
                            ),
                            child: const Text(
                              'Clear',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              // Footer note from the wireframes
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.lightbulb_outline, size: 18, color: Colors.orange),
                  const SizedBox(width: 8),
                  Text(
                    'All examples are 100% customizable via code attributes',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
