import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:pickleizer_app/main.dart';

void main() {
  // Initialize FFI for SQLite in tests
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  testWidgets('App launches successfully', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(
        child: PickleizerApp(),
      ),
    );

    // Verify app title is shown
    expect(find.text('Pickleizer Court Manager'), findsOneWidget);
    
    // Verify add court button exists
    expect(find.byIcon(Icons.add), findsOneWidget);
  });
}
