import 'package:flutter/material.dart';
import 'pin_view.dart';
import 'pin_theme.dart';

class PinViewDemoPage extends StatefulWidget {
  const PinViewDemoPage({super.key});

  @override
  State<PinViewDemoPage> createState() => _PinViewDemoPageState();
}

class _PinViewDemoPageState extends State<PinViewDemoPage> {
  final _key1 = GlobalKey<PinViewState>();
  final _controller1 = TextEditingController();
  String? _error1;

  final _key2 = GlobalKey<PinViewState>();
  final _controller2 = TextEditingController();
  String? _error2;

  final _key3 = GlobalKey<PinViewState>();
  final _controller3 = TextEditingController();
  String? _error3;

  final _key4 = GlobalKey<PinViewState>();
  final _controller4 = TextEditingController();
  String? _error4;

  final _key5 = GlobalKey<PinViewState>();
  final _controller5 = TextEditingController();
  String? _error5;

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    _controller4.dispose();
    _controller5.dispose();
    super.dispose();
  }

  void _verify(
    String value,
    String correct,
    GlobalKey<PinViewState> key,
    String errorText,
    String successTitle,
    void Function(String?) setError,
  ) {
    setState(() {
      setError(null);
    });
    if (value == correct) {
      _showSuccessDialog(successTitle, value);
    } else {
      setState(() {
        setError(errorText);
      });
      key.currentState?.triggerShake();
    }
  }

  void _showSuccessDialog(String title, String code) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_circle_rounded, color: Colors.green, size: 64),
              ),
              const SizedBox(height: 20),
              Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('Code "$code" verified successfully.', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey.shade600)),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Continue', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("PinView Library", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 24),
            _buildCard(
              title: "Example 1: App Lock PIN",
              subtitle: "4-digit • Box style • Masked • Teal theme",
              hint: "Correct PIN: 5555",
              color: Colors.teal,
              controller: _controller1,
              onVerify: () => _verify(_controller1.text, "5555", _key1, "Incorrect PIN!", "App Lock Bypassed", (err) => _error1 = err),
              onClear: () { _controller1.clear(); setState(() { _error1 = null; }); },
              child: PinView(
                key: _key1,
                isPinMode: true,
                pinLength: 4,
                obscureText: true,
                controller: _controller1,
                errorText: _error1,
                keyboardType: TextInputType.number,
                pinTheme: const PinTheme(
                  cellWidth: 55,
                  cellHeight: 55,
                  focusedBorderColor: Colors.teal,
                  filledBorderColor: Colors.tealAccent,
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildCard(
              title: "Example 2: OTP Verification",
              subtitle: "6-digit • Underline style • Unmasked • Indigo theme",
              hint: "Correct OTP: 987654",
              color: Colors.indigo,
              controller: _controller2,
              onVerify: () => _verify(_controller2.text, "987654", _key2, "Invalid OTP!", "Phone Verified", (err) => _error2 = err),
              onClear: () { _controller2.clear(); setState(() { _error2 = null; }); },
              child: PinView(
                key: _key2,
                isPinMode: true,
                pinLength: 6,
                pinStyle: PinStyle.underline,
                controller: _controller2,
                errorText: _error2,
                keyboardType: TextInputType.number,
                onPinCompleted: (val) => _verify(val, "987654", _key2, "Invalid OTP!", "Phone Verified", (err) => _error2 = err),
                pinTheme: const PinTheme(
                  cellWidth: 42,
                  cellHeight: 48,
                  focusedBorderColor: Colors.indigo,
                  filledBorderColor: Colors.indigoAccent,
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildCard(
              title: "Example 3: Banking PIN",
              subtitle: "5-digit • Circle style • Masked • Red theme",
              hint: "Correct PIN: 43210",
              color: Colors.red,
              controller: _controller3,
              onVerify: () => _verify(_controller3.text, "43210", _key3, "Incorrect Banking PIN!", "Transaction Authenticated", (err) => _error3 = err),
              onClear: () { _controller3.clear(); setState(() { _error3 = null; }); },
              child: PinView(
                key: _key3,
                isPinMode: true,
                pinLength: 5,
                pinStyle: PinStyle.circle,
                obscureText: true,
                controller: _controller3,
                errorText: _error3,
                keyboardType: TextInputType.number,
                pinTheme: const PinTheme(
                  cellWidth: 48,
                  cellHeight: 48,
                  focusedBorderColor: Colors.red,
                  filledBorderColor: Colors.redAccent,
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildCard(
              title: "Example 4: Secure Wallet PIN",
              subtitle: "4-digit • Circle style • Unmasked • Amber theme",
              hint: "Correct PIN: 7777",
              color: Colors.amber.shade900,
              controller: _controller4,
              onVerify: () => _verify(_controller4.text, "7777", _key4, "Incorrect Wallet PIN!", "Wallet Access Granted", (err) => _error4 = err),
              onClear: () { _controller4.clear(); setState(() { _error4 = null; }); },
              child: PinView(
                key: _key4,
                isPinMode: true,
                pinLength: 4,
                pinStyle: PinStyle.circle,
                controller: _controller4,
                errorText: _error4,
                keyboardType: TextInputType.number,
                pinTheme: PinTheme(
                  cellWidth: 50,
                  cellHeight: 50,
                  focusedBorderColor: Colors.amber.shade900,
                  filledBorderColor: Colors.amberAccent,
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildCard(
              title: "Example 5: Smart Lock Access",
              subtitle: "6-digit • Box style (Rounded) • Masked • Pink theme",
              hint: "Correct Code: 246813",
              color: Colors.pink,
              controller: _controller5,
              onVerify: () => _verify(_controller5.text, "246813", _key5, "Access Denied!", "Door Unlocked", (err) => _error5 = err),
              onClear: () { _controller5.clear(); setState(() { _error5 = null; }); },
              child: PinView(
                key: _key5,
                isPinMode: true,
                pinLength: 6,
                obscureText: true,
                controller: _controller5,
                errorText: _error5,
                keyboardType: TextInputType.number,
                pinTheme: const PinTheme(
                  cellWidth: 40,
                  cellHeight: 40,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  focusedBorderColor: Colors.pink,
                  filledBorderColor: Colors.pinkAccent,
                ),
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              "💡 All widgets are rendered directly from the library",
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.grey),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({
    required String title,
    required String subtitle,
    required String hint,
    required Color color,
    required TextEditingController controller,
    required VoidCallback onVerify,
    required VoidCallback onClear,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
            const SizedBox(height: 4),
            Text(subtitle, style: TextStyle(fontSize: 12.5, color: Colors.grey.shade500)),
            const SizedBox(height: 4),
            Text(hint, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, color: Colors.green)),
            const SizedBox(height: 20),
            Center(child: child),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    onPressed: onVerify,
                    child: const Text("Verify", style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF757575),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    onPressed: onClear,
                    child: const Text("Clear", style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
