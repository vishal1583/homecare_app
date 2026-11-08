import 'package:flutter/material.dart';
import 'package:flutter_application_7/constants/my_theme.dart';
import 'package:flutter_application_7/models/service_provider.dart';
import 'package:flutter_application_7/user/available_service_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_7/widgets/service_browser.dart';
import 'package:flutter_application_7/widgets/serviceavailablecard.dart';
import 'package:flutter_test/flutter_test.dart';

ServiceProvider provider(
        String id, String name, String skills, String location) =>
    ServiceProvider(
        id: id,
        providerName: name,
        providerEmail: '$id@example.com',
        providerPassword: '',
        providerPhoneno: '1234567890',
        providerLocation: location,
        providerSkills: skills);

void main() {
  final providers = [
    provider('1', 'Alex Morgan', 'Plumbing, Repairs', 'North End'),
    provider('2', 'Jamie Patel', 'Cleaning', 'South Park'),
    provider('3', 'Taylor Lee', 'Electrical; AC repair', 'North End'),
  ];

  Future<void> showBrowser(WidgetTester tester,
      {Size size = const Size(390, 844),
      double scale = 1,
      List<ServiceProvider>? items,
      ValueChanged<ServiceProvider>? onSelected}) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(MaterialApp(
      theme: MyTheme.lightTheme,
      builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: TextScaler.linear(scale)),
          child: child!),
      home: Scaffold(
          appBar: AppBar(title: const Text('Find a Service')),
          body: ServiceBrowser(
              providers: items ?? providers,
              onProviderSelected: onSelected ?? (_) {})),
    ));
    await tester.pumpAndSettle();
  }

  testWidgets('search finds names, skills, and locations without changing case',
      (tester) async {
    await showBrowser(tester);
    final search = find.byType(TextField);
    for (final sample in [
      ('alex', '1 provider found'),
      ('CLEANING', '1 provider found'),
      (' north ', '2 providers found')
    ]) {
      await tester.enterText(search, sample.$1);
      await tester.pumpAndSettle();
      expect(find.text(sample.$2), findsOneWidget);
    }
    expect(tester.takeException(), isNull);
  });

  testWidgets('skill filters combine with search and can be reset',
      (tester) async {
    await showBrowser(tester);
    final plumbing = find.widgetWithText(ChoiceChip, 'Plumbing');
    await tester.ensureVisible(plumbing);
    await tester.tap(plumbing);
    await tester.pumpAndSettle();
    expect(find.text('1 provider found'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'south');
    await tester.pumpAndSettle();
    expect(find.text('0 providers found'), findsOneWidget);
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(find.text('Clear filters'), 180,
        scrollable: find.byType(Scrollable).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Clear filters'));
    await tester.pumpAndSettle();
    expect(find.text('3 providers to explore'), findsOneWidget);
    expect(tester.widget<TextField>(find.byType(TextField)).controller!.text,
        isEmpty);
    expect(tester.takeException(), isNull);
  });

  testWidgets('profile action selects the correct filtered provider',
      (tester) async {
    ServiceProvider? selected;
    await showBrowser(tester, onSelected: (provider) => selected = provider);
    await tester.enterText(find.byType(TextField), 'Jamie');
    await tester.pumpAndSettle();
    final view = find.widgetWithText(OutlinedButton, 'View provider');
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(view, 180,
        scrollable: find.byType(Scrollable).first);
    await tester.pumpAndSettle();
    await tester.tap(view);
    expect(selected?.id, '2');
  });

  testWidgets('failed service loads show a retry instead of an empty directory',
      (tester) async {
    SharedPreferences.setMockInitialValues({'ip': '127.0.0.1'});
    // Flutter's test HTTP client returns 400 without reaching a real server.
    await tester.pumpWidget(MaterialApp(
        theme: MyTheme.lightTheme, home: const AvailableServiceScreen()));
    await tester.pumpAndSettle();
    expect(find.text('Let us try that again.'), findsOneWidget);
    expect(find.text('No providers yet'), findsNothing);
    await tester.tap(find.text('Try again'));
    await tester.pumpAndSettle();
    expect(find.text('Let us try that again.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('empty directory explains what happens next', (tester) async {
    await showBrowser(tester, items: []);
    expect(find.text('0 providers to explore'), findsOneWidget);
    expect(find.text('No providers yet'), findsOneWidget);
    expect(find.byType(ServiceAvailableCard), findsNothing);
    expect(tester.takeException(), isNull);
  });

  for (final scenario in [
    (size: const Size(320, 568), scale: 1.0),
    (size: const Size(568, 320), scale: 2.0),
    (size: const Size(240, 320), scale: 3.0),
    (size: const Size(1024, 768), scale: 1.0),
  ]) {
    testWidgets(
        'provider cards fit ${scenario.size} at text scale ${scenario.scale}',
        (tester) async {
      await showBrowser(tester,
          size: scenario.size,
          scale: scenario.scale,
          items: [
            provider(
                'long',
                'Alexandra Catherine Montgomery Wellington',
                'Home maintenance, Plumbing and extensive repairs',
                'A long service location across the city')
          ]);
      final button = find.widgetWithText(OutlinedButton, 'View provider');
      await tester.scrollUntilVisible(button, 300,
          scrollable: find.byType(Scrollable).first, maxScrolls: 40);
      await tester.pumpAndSettle();
      expect(button.hitTestable(), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }
}
