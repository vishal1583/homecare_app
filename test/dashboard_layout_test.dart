import 'package:flutter/material.dart';
import 'package:flutter_application_7/constants/my_theme.dart';
import 'package:flutter_application_7/ser_provider/dashboard_screen2.dart';
import 'package:flutter_application_7/user/dashboard_screen1.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({
      'ip': '127.0.0.1',
      'userid': '1',
      'username': 'Alexandria Catherine Montgomery Wellington',
      'providername': 'Alexandria Catherine Montgomery Wellington',
    });
  });

  for (final isProvider in [false, true]) {
    final role = isProvider ? 'Provider' : 'User';
    for (final scenario in [
      (size: const Size(320, 568), scale: 1.0),
      (size: const Size(390, 844), scale: 1.0),
      (size: const Size(568, 320), scale: 2.0),
      (size: const Size(240, 320), scale: 3.0),
    ]) {
      testWidgets(
          '$role dashboard fits ${scenario.size} with text scale ${scenario.scale}',
          (tester) async {
        tester.view.physicalSize = scenario.size;
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(MaterialApp(
          theme: MyTheme.lightTheme,
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: TextScaler.linear(scenario.scale),
            ),
            child: child!,
          ),
          home:
              isProvider ? const DashboardScreen2() : const DashboardScreen1(),
        ));
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
        expect(find.text('My Profile'), findsOneWidget);
        expect(find.text(isProvider ? 'View Bookings' : 'Available Services'),
            findsOneWidget);

        // The final action must remain reachable even in a short viewport.
        await tester.ensureVisible(find.text('Logout'));
        await tester.pumpAndSettle();
        expect(find.text('Logout').hitTestable(), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    }
  }
}
