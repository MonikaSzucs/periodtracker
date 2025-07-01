import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:periodtracker/main.dart';
import 'package:periodtracker/tabs.dart';

void main() {
  testWidgets('App loads and shows tabs', (WidgetTester tester) async {
    // Build our app and wait for initial frame
    await tester.pumpWidget(const MyApp());
    
    // Wait for potential async operations in Tabs widget
    await tester.pumpAndSettle(); // This waits for all animations and async ops

    // Verify the tabs widget is present
    expect(find.byType(Tabs), findsOneWidget);

    // Verify theme
    final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(materialApp.theme, isNotNull);
    expect(materialApp.darkTheme, isNotNull);
  });
}