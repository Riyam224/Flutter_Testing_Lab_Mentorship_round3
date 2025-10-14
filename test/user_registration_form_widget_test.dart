import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/widgets/user_registration_form.dart';

void main() {
  testWidgets('Shows validation errors for empty fields', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: UserRegistrationForm())),
    );
    await tester.tap(find.text('Register'));
    await tester.pump();

    expect(find.text('Please enter your full name'), findsOneWidget);
    expect(find.text('Please enter your email'), findsOneWidget);
    expect(find.text('Please enter a password'), findsOneWidget);
    expect(find.text('Please confirm your password'), findsOneWidget);
  });

  testWidgets('Shows error for invalid email', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: UserRegistrationForm())),
    );
    await tester.enterText(find.byType(TextFormField).at(1), 'a@');
    await tester.tap(find.text('Register'));
    await tester.pump();

    expect(find.text('Please enter a valid email'), findsOneWidget);
  });

  testWidgets('Shows success message for valid input', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: UserRegistrationForm())),
    );
    await tester.enterText(find.byType(TextFormField).at(0), 'Riyam');
    await tester.enterText(find.byType(TextFormField).at(1), 'ok@example.com');
    await tester.enterText(find.byType(TextFormField).at(2), 'Aa@12345');
    await tester.enterText(find.byType(TextFormField).at(3), 'Aa@12345');
    await tester.tap(find.text('Register'));
    await tester.pump(const Duration(seconds: 2));

    expect(find.text('Registration successful!'), findsOneWidget);
  });
}
