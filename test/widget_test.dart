import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_7/main.dart';

void main() {
  testWidgets('App opens the IP address setup screen', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Enter your IP Address'), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'Submit'), findsOneWidget);
  });

  testWidgets('Submitting an empty IP address shows a validation error',
      (tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.widgetWithText(ElevatedButton, 'Submit'));
    await tester.pump();

    expect(find.text('Invalid data'), findsOneWidget);
    expect(find.text('Enter your IP Address'), findsOneWidget);
  });
}
