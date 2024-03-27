import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:slopesense/pages/home.dart';

void main() {
  testWidgets('TypeAheadField suggests ski resorts based on input', (WidgetTester tester) async {

    await tester.pumpWidget(MaterialApp(home: HomePage()));

    await tester.enterText(find.byType(TypeAheadField), 'Val');

    await tester.pump();

    expect(find.text('Val Gardena'), findsOneWidget);
  });
}
