// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:gfms_mobile/app.dart';

void main() {
  testWidgets('app opens on splash and continues to sign in',
      (WidgetTester tester) async {
    // The app restores its language from preferences; use an in-memory store
    // so the test does not depend on a device plugin or previous test state.
    SharedPreferences.setMockInitialValues({});

    // GFMSApp is the real root widget and provides routing, theme, and locale.
    await tester.pumpWidget(const GFMSApp());
    await tester.pumpAndSettle();

    expect(find.text('GFMS Mobile'), findsOneWidget);
    expect(find.text('Continue'), findsOneWidget);

    // The splash action should use the app's named login route.
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    // The current login page labels both its app bar and submit button.
    expect(find.text('Sign In'), findsNWidgets(2));
    expect(find.byType(TextFormField), findsNWidgets(2));
  });
}
