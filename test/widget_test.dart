import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_first_app/Cart.dart';
import 'package:my_first_app/cart_store.dart';
import 'package:my_first_app/main.dart';

bool _isObscured(WidgetTester tester, Finder field) {
  final editableText = find.descendant(
    of: field,
    matching: find.byType(EditableText),
  );
  return tester.widget<EditableText>(editableText).obscureText;
}

void main() {
  setUp(() => CartStore.instance.clear());

  testWidgets('cart quantity updates and checkout opens', (
    WidgetTester tester,
  ) async {
    CartStore.instance.add(
      name: 'Small Paw Taba Squishy',
      price: '₱150.00',
      imagePath: 'assets/images/taba1.jpg',
      quantity: 1,
    );

    await tester.pumpWidget(const MaterialApp(home: CartScreen()));

    expect(find.text('Small Paw Taba Squishy'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.add_circle_outline));
    await tester.pump();
    expect(CartStore.instance.items.single.quantity, 2);

    await tester.tap(find.text('Proceed to checkout'));
    await tester.pumpAndSettle();
    expect(find.text('Delivery information'), findsOneWidget);
    expect(find.text('Payment method'), findsOneWidget);
    expect(find.text('Place order'), findsOneWidget);
  });

  testWidgets('empty cart prompts the shopper to continue shopping', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: CartScreen()));

    expect(
      find.text('Your cart is waiting for something cute!'),
      findsOneWidget,
    );
    expect(find.text('Continue shopping'), findsOneWidget);
  });

  testWidgets('login password can be shown and hidden', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

    final passwordField = find.byType(TextFormField).last;
    expect(_isObscured(tester, passwordField), isTrue);

    await tester.tap(find.byTooltip('Show password'));
    await tester.pump();
    expect(_isObscured(tester, passwordField), isFalse);

    await tester.tap(find.byTooltip('Hide password'));
    await tester.pump();
    expect(_isObscured(tester, passwordField), isTrue);
  });

  testWidgets('registration password fields toggle visibility independently', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: RegisterScreen()));

    final fields = find.byType(TextFormField);
    final passwordField = fields.at(2);
    final confirmPasswordField = fields.at(3);

    expect(_isObscured(tester, passwordField), isTrue);
    expect(_isObscured(tester, confirmPasswordField), isTrue);

    await tester.tap(find.byTooltip('Show password').first);
    await tester.pump();
    expect(_isObscured(tester, passwordField), isFalse);
    expect(_isObscured(tester, confirmPasswordField), isTrue);

    await tester.tap(find.byTooltip('Show password'));
    await tester.pump();
    expect(_isObscured(tester, confirmPasswordField), isFalse);
  });
}
