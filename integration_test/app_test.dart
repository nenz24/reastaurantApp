import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:submission1/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('End-to-end App Test', () {
    testWidgets('should load restaurant list on startup', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      expect(find.byType(BottomNavigationBar), findsOneWidget);

      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Favorites'), findsOneWidget);
      expect(find.text('Settings'), findsOneWidget);
    });

    testWidgets('should navigate between tabs', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      await tester.tap(find.text('Favorites'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Settings'));
      await tester.pumpAndSettle();

      expect(find.text('Dark Mode'), findsOneWidget);
      expect(find.text('Restaurant Notification'), findsOneWidget);

      await tester.tap(find.text('Home'));
      await tester.pumpAndSettle();
    });

    testWidgets('should toggle dark mode from settings', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      await tester.tap(find.text('Settings'));
      await tester.pumpAndSettle();

      final darkModeSwitch = find.byType(Switch).first;
      expect(darkModeSwitch, findsOneWidget);

      await tester.tap(darkModeSwitch);
      await tester.pumpAndSettle();

      await tester.tap(darkModeSwitch);
      await tester.pumpAndSettle();
    });
  });
}
