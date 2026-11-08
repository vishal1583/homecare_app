import 'package:flutter/material.dart';
import 'package:flutter_application_7/splash_screen.dart';
import 'package:flutter_application_7/select_user.dart';
import 'package:flutter_application_7/widgets/date.dart';
import 'package:flutter_application_7/widgets/time.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Disposed splash screen does not navigate when its timer fires',
      (tester) async {
    await tester.pumpWidget(const MaterialApp(home: SplashScreen()));
    await tester.pumpWidget(const MaterialApp(home: SizedBox()));
    await tester.pump(const Duration(seconds: 2));

    expect(tester.takeException(), isNull);
    expect(find.byType(SelectUserScreen), findsNothing);
  });

  for (final isDate in [true, false]) {
    final pickerName = isDate ? 'Date' : 'Time';
    testWidgets(
        '$pickerName picker ignores results after its widget is disposed',
        (tester) async {
      final visible = ValueNotifier(true);
      addTearDown(visible.dispose);
      var callbackCalled = false;

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: ValueListenableBuilder<bool>(
            valueListenable: visible,
            builder: (context, showPicker, child) {
              if (!showPicker) return const SizedBox();
              return isDate
                  ? DateScreen(updateSelectedDate: (_) => callbackCalled = true)
                  : TimeScreen(
                      updateSelectedTime: (_) => callbackCalled = true);
            },
          ),
        ),
      ));
      await tester.tap(find.byType(OutlinedButton));
      await tester.pumpAndSettle();

      // Remove the originating widget while keeping the dialog open.
      visible.value = false;
      await tester.pump();
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(callbackCalled, isFalse);
    });
  }
}
