import 'package:flutter/material.dart';
import 'package:flutter_application_7/ser_provider/login_screen2.dart';
import 'package:flutter_application_7/user/login_screen1.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({'ip': '127.0.0.1'});
  });

  for (final isProvider in [false, true]) {
    final role = isProvider ? 'Provider' : 'User';

    testWidgets('$role login preserves required-field validation',
        (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: isProvider ? const LoginScreen2() : const LoginScreen1(),
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
      await tester.pump();

      final emailError =
          isProvider ? 'Please enter your email' : 'Please enter a valid email';
      final passwordError = isProvider
          ? 'Please enter your password'
          : 'Please enter a valid password';
      expect(find.text(emailError), findsOneWidget);
      expect(find.text(passwordError), findsOneWidget);

      await tester.enterText(
          find.byType(TextFormField).first, 'user@example.com');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
      await tester.pump();

      expect(find.text(emailError), findsNothing);
      expect(find.text(passwordError), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });
  }
}
