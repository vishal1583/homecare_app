import 'package:flutter/material.dart';
import 'package:flutter_application_7/constants/my_theme.dart';
import 'package:flutter_application_7/ip_address.dart';
import 'package:flutter_application_7/models/bookings.dart';
import 'package:flutter_application_7/select_user.dart';
import 'package:flutter_application_7/ser_provider/profile_screen2.dart';
import 'package:flutter_application_7/ser_provider/login_screen2.dart';
import 'package:flutter_application_7/ser_provider/sign_up_screen2.dart';
import 'package:flutter_application_7/user/feedback.dart';
import 'package:flutter_application_7/user/login_screen1.dart';
import 'package:flutter_application_7/user/payment_screen.dart';
import 'package:flutter_application_7/user/profile_screen1.dart';
import 'package:flutter_application_7/user/provider_details_screen.dart';
import 'package:flutter_application_7/user/sign_up_screen1.dart';
import 'package:flutter_application_7/widgets/app_collection_page.dart';
import 'package:flutter_application_7/widgets/booking_card.dart';
import 'package:flutter_application_7/widgets/password_field.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({
      'ip': '127.0.0.1',
      'userid': '1',
      'providerid': '2',
      'username': 'Alex Morgan',
      'useremail': 'alex@example.com',
      'userphone': '1234567890',
      'useraddress': 'A long address for a small screen',
      'providername': 'Alex Morgan',
      'provideremail': 'alex@example.com',
      'providerphoneno': '1234567890',
      'providerlocation': 'A long location for a small screen',
      'providerskills': 'Plumbing and home maintenance',
    });
  });

  Future<void> showPage(WidgetTester tester, Widget page,
      {double scale = 2}) async {
    tester.view.physicalSize = const Size(320, 568);
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

  for (final sample in <(String, Widget, String)>[
    ('setup', const IpAddressScreen(), 'Submit'),
    ('user registration', const SignUpScreen1(), 'Register'),
    ('provider registration', const SignUpScreen2(), 'Register'),
    ('user profile', const ProfileScreen1(), 'Update'),
    ('provider profile', const ProfileScreen2(), 'Update'),
    ('payment', const PaymentScreen(bookingID: '1'), 'Submit Payment'),
    (
      'feedback',
      const FeedbackScreen(bookingID: '1', userID: '1', providerID: '2'),
      'Submit Feedback'
    ),
    (
      'provider details',
      const ProviderDetailsScreen(
          providerName: 'Alexandra Catherine Montgomery',
          providerEmail: 'alexandra@example.com',
          providerPhoneNo: '1234567890',
          providerLocation: 'A very long address',
          providerSkills: 'Plumbing, repairs, and home maintenance'),
      'Request booking'
    ),
  ]) {
    testWidgets('${sample.$1} scrolls to its action with enlarged text',
        (tester) async {
      await showPage(tester, sample.$2);
      expect(tester.takeException(), isNull);
      await tester.ensureVisible(find.text(sample.$3));
      await tester.pumpAndSettle();
      expect(find.text(sample.$3).hitTestable(), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('role selection opens the correct login', (tester) async {
    await showPage(tester, const SelectUserScreen(), scale: 1);
    await tester.ensureVisible(find.text('General User'));
    await tester.tap(find.text('General User'));
    await tester.pumpAndSettle();
    expect(find.byType(LoginScreen1), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('provider role opens the provider login', (tester) async {
    await showPage(tester, const SelectUserScreen(), scale: 1);
    await tester.ensureVisible(find.text('Service Provider'));
    await tester.tap(find.text('Service Provider'));
    await tester.pumpAndSettle();
    expect(find.byType(LoginScreen2), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('form action remains reachable with the keyboard open',
      (tester) async {
    await showPage(tester, const IpAddressScreen(), scale: 1);
    await tester.showKeyboard(find.byType(TextFormField));
    tester.view.viewInsets = const FakeViewPadding(bottom: 260);
    addTearDown(tester.view.resetViewInsets);
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.widgetWithText(ElevatedButton, 'Submit'));
    await tester.pumpAndSettle();
    expect(find.text('Submit').hitTestable(), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('password is concealed and can be revealed', (tester) async {
    await showPage(tester, const LoginScreen1(), scale: 1);
    final field = find.descendant(
        of: find.byType(PasswordField), matching: find.byType(TextField));
    expect(tester.widget<TextField>(field).obscureText, isTrue);
    await tester.ensureVisible(find.byTooltip('Show password'));
    await tester.tap(find.byTooltip('Show password'));
    await tester.pump();
    expect(tester.widget<TextField>(field).obscureText, isFalse);
    expect(find.byTooltip('Hide password'), findsOneWidget);
  });

  testWidgets('booking status and actions wrap without overflowing',
      (tester) async {
    final booking = Bookings(
        id: '123456789',
        userId: '1',
        providerId: '2',
        dateOfBooking: '24-11-2026',
        timeOfBooking: '10:30 AM',
        status: 'completed');
    await showPage(
        tester,
        AppCollectionPage<Bookings>(
          title: 'My Bookings',
          description: 'Your upcoming visits.',
          future: Future.value([booking]),
          emptyMessage: 'No visits yet.',
          itemBuilder: (context, item, index) => BookingCard(
              booking: item,
              name: 'Alexandra Catherine Montgomery',
              actions: [
                ElevatedButton(
                    onPressed: () {}, child: const Text('Make Payment'))
              ]),
        ));
    await tester.ensureVisible(find.text('Make Payment'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.text('Completed'), findsOneWidget);
    expect(find.text('Make Payment').hitTestable(), findsOneWidget);
  });

  testWidgets('empty collections explain the next step', (tester) async {
    await showPage(
        tester,
        AppCollectionPage<Bookings>(
          title: 'My Bookings',
          description: 'Your upcoming visits.',
          future: Future.value([]),
          emptyMessage: 'Book a service to get started.',
          itemBuilder: (context, item, index) => const SizedBox(),
        ));
    expect(find.text('Book a service to get started.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
