import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:calculator_app/main.dart';

void main() {
  testWidgets('Calculator UI Test', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: HomeScreen(),
      ),
    );

    // Verify if the calculator app title is displayed
    expect(find.text('Calculator App'), findsOneWidget);

    // Tap on a button (example: button '1')
    await tester.tap(find.text('1'));
    await tester.pump();

    // Verify if the text field shows the tapped button value ('1')
    expect(find.text('1'), findsOneWidget);
  });
}
