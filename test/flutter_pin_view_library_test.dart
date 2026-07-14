import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_pin_view_library/flutter_pin_view_library.dart';

void main() {
  testWidgets('PinView renders correctly in standard mode', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PinView(
            labelText: 'Username',
            hintText: 'Enter username',
          ),
        ),
      ),
    );

    // Verify label text and hint text render
    expect(find.text('Username'), findsOneWidget);
    expect(find.text('Enter username'), findsOneWidget);
    expect(find.byType(TextFormField), findsOneWidget);
  });

  testWidgets('PinView renders correctly in PIN mode', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PinView(
            isPinMode: true,
            pinLength: 4,
          ),
        ),
      ),
    );

    // Verify the transparent overlay TextField and form field render
    expect(find.byType(TextField), findsOneWidget);
    expect(find.byType(FormField<String>), findsOneWidget);
  });
}
