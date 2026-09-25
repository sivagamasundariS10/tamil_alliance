import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tamil_alliance/screens/auth/password_login_screen.dart';

void main() {
  testWidgets('PasswordLoginScreen renders correctly matching UI', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: PasswordLoginScreen(
          initialPhone: '9842176540',
          initialCountryCode: '+91',
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('TAMIL ALLIANCE'), findsOneWidget);
    expect(find.text('Welcome Back'), findsOneWidget);
    expect(find.text('வணக்கம்'), findsOneWidget);
    expect(find.text('Mobile Number'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Remember me'), findsOneWidget);
    expect(find.text('Forgot Password?'), findsOneWidget);
    expect(find.text('Log In'), findsOneWidget);
    expect(find.text('Log in with OTP'), findsOneWidget);
    expect(find.text('Register Free'), findsOneWidget);
  });
}
