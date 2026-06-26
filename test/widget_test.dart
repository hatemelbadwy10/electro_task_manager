import 'package:electro_task_manager/core/config/theme/theme_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders app shell smoke test', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeManager.lightTheme,
        home: const Scaffold(body: Text('Electro Task Manager')),
      ),
    );

    expect(find.text('Electro Task Manager'), findsOneWidget);
  });
}
