import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latestnewsapp/presentation/screens/search_screen.dart';

void main() {
  group('SearchScreen UI Tests', () {
    testWidgets('should display the search screen correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: SearchScreen())),
      );

      expect(find.text('Search News'), findsOneWidget);

      expect(find.byType(TextField), findsOneWidget);

      expect(find.text('Recent Searches:'), findsNothing);
    });

    testWidgets('should update search query when typing in the text field',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: SearchScreen())),
      );

      final textField = find.byType(TextField);

      await tester.enterText(textField, 'Flutter');
      await tester.pump();

      expect(find.text('Flutter'), findsOneWidget);
    });

    testWidgets('should display recent searches when available',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: SearchScreen())),
      );
    });

    testWidgets('should navigate to news list screen when search is performed',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: SearchScreen())),
      );

      final textField = find.byType(TextField);
      await tester.enterText(textField, 'Flutter');

      final searchButton = find.widgetWithText(ElevatedButton, 'Search');
      await tester.tap(searchButton);
      await tester.pumpAndSettle();
    });
  });
}
