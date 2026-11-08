import 'package:flutter/material.dart';
import 'package:flutter_application_7/constants/my_theme.dart';
import 'package:flutter_application_7/select_user.dart';
import 'package:flutter_application_7/ser_provider/dashboard_screen2.dart';
import 'package:flutter_application_7/user/dashboard_screen1.dart';
import 'package:flutter_application_7/user/payment_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({
      'ip': '127.0.0.1',
      'userid': '1',
      'username': 'Alex',
      'providername': 'Alex',
    });
  });

  Future<void> showPage(WidgetTester tester, Widget page,
      {double scale = 1}) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(MaterialApp(
      theme: MyTheme.lightTheme,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: TextScaler.linear(scale)),
        child: child!,
      ),
      home: page,
    ));
    await tester.pumpAndSettle();
  }

  for (final isProvider in [false, true]) {
    testWidgets(
        '${isProvider ? 'Provider' : 'User'} logout requires confirmation',
        (tester) async {
      await showPage(tester,
          isProvider ? const DashboardScreen2() : const DashboardScreen1());
      await tester.ensureVisible(find.text('Logout'));
      await tester.tap(find.text('Logout'));
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.byType(SelectUserScreen), findsNothing);

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsNothing);
      expect(find.byType(SelectUserScreen), findsNothing);

      await tester.tap(find.text('Logout'));
      await tester.pumpAndSettle();
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(find.byType(SelectUserScreen), findsNothing);

      await tester.tap(find.text('Logout'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(ElevatedButton, 'Log out'));
      await tester.pumpAndSettle();
      expect(find.byType(SelectUserScreen), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('payment confirmation shows the details and can be cancelled',
      (tester) async {
    await showPage(tester, const PaymentScreen(bookingID: '42'));
    await tester.enterText(find.byType(TextFormField), '1500');
    final method = find.byType(DropdownButtonFormField<String>);
    await tester.ensureVisible(method);
    await tester.tap(method);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cash').last);
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Submit Payment'));
    await tester.tap(find.text('Submit Payment'));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.textContaining('Amount: 1500'), findsOneWidget);
    expect(find.textContaining('Method: Cash'), findsOneWidget);
    expect(find.textContaining('booking #42'), findsOneWidget);
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    expect(find.byType(PaymentScreen), findsOneWidget);
    expect(find.byType(AlertDialog), findsNothing);
    expect(find.text('1500'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('confirmation dialog supports enlarged text', (tester) async {
    await showPage(tester, const DashboardScreen1(), scale: 3);
    await tester.ensureVisible(find.text('Logout'));
    await tester.tap(find.text('Logout'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await tester.ensureVisible(find.text('Cancel'));
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
