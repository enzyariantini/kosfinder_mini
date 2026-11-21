// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kosfinder_mini/main.dart';

void main() {
  testWidgets('Menampilkan kos dan mencari berdasarkan lokasi',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('KosFinder Mini'), findsOneWidget);
    expect(find.text('6 kos ditemukan'), findsOneWidget);
    expect(find.text('Kos Melati'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'Babarsari');
    await tester.pump();

    expect(find.text('1 kos ditemukan'), findsOneWidget);
    expect(find.text('Kos Cendana'), findsOneWidget);
    expect(find.text('Kos Melati'), findsNothing);
  });

  testWidgets('Tombol favorit dapat diklik', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.byIcon(Icons.favorite_border), findsWidgets);

    await tester.tap(find.byIcon(Icons.favorite_border).first);
    await tester.pump();

    expect(find.byIcon(Icons.favorite), findsOneWidget);
  });
}
