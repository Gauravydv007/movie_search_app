import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_search_app_001/app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:movie_search_app_001/injection/injection.dart';

void main() {
  setUpAll(() async {
    WidgetsFlutterBinding.ensureInitialized();

    SharedPreferences.setMockInitialValues({});

    await init();
  });

  group('Movie App UI Tests', () {
    testWidgets('App launches and shows search field', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MovieSearchApp());
      await tester.pumpAndSettle();

      expect(find.text('Search'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('Typing in search field works', (WidgetTester tester) async {
      await tester.pumpWidget(const MovieSearchApp());
      await tester.pumpAndSettle();

      final textField = find.byType(TextField);
      await tester.enterText(textField, 'Batman');
      await tester.pump();

      expect(find.text('Batman'), findsOneWidget);
    });

    testWidgets('Search action starts navigation without crash', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MovieSearchApp());
      await tester.pumpAndSettle();

      final textField = find.byType(TextField);
      await tester.enterText(textField, 'Avengers');

      await tester.testTextInput.receiveAction(TextInputAction.search);

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.byType(MaterialApp), findsOneWidget);
    });
  });
}
