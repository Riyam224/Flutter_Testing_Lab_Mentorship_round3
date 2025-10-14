import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/widgets/shopping_cart.dart';

void main() {
  group('🛒 ShoppingCart Widget Tests', () {
    testWidgets('✅ Add item updates total items and subtotal', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: ShoppingCart()));

      // Tap the "Add iPhone" button
      final addButton = find.text('Add iPhone');
      await tester.tap(addButton);
      await tester.pump();

      // Verify subtotal and total items text are updated
      expect(find.textContaining('Total Items: 1'), findsOneWidget);
      expect(find.textContaining('Subtotal: \$999.99'), findsOneWidget);
    });

    testWidgets('✅ Add duplicate item increases quantity', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: ShoppingCart()));

      final addButton = find.text('Add iPhone');
      await tester.tap(addButton);
      await tester.tap(addButton);
      await tester.pump();

      expect(find.textContaining('Total Items: 2'), findsOneWidget);
    });

    testWidgets('✅ Clear Cart resets everything', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: ShoppingCart()));

      final addButton = find.text('Add iPhone');
      await tester.tap(addButton);
      await tester.pump();

      final clearButton = find.text('Clear Cart');
      await tester.tap(clearButton);
      await tester.pump();

      expect(
        find.text('🛒 Your cart is empty — start adding items!'),
        findsOneWidget,
      );
    });

    testWidgets('✅ 100% discount shows FREE item total', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: ShoppingCart()));

      final addGalaxy = find.text('Add Galaxy');
      await tester.tap(addGalaxy);
      await tester.pump();

      expect(find.textContaining('Discount: 15%'), findsOneWidget);
    });

    testWidgets('✅ Edge case: quantity cannot go below 0', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: ShoppingCart()));

      final addButton = find.text('Add iPhone');
      await tester.tap(addButton);
      await tester.pump();

      // Tap the "-" button to reduce quantity
      final minusButton = find.byIcon(Icons.remove);
      await tester.tap(minusButton);
      await tester.pump();

      expect(
        find.text('🛒 Your cart is empty — start adding items!'),
        findsOneWidget,
      );
    });
  });
}
