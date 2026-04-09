import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:perfect_loader/perfect_loader.dart';

void main() {
  testWidgets('PerfectLoader builds', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(
            child: PerfectLoader(size: 48),
          ),
        ),
      ),
    );
    expect(find.byType(PerfectLoader), findsOneWidget);
    expect(find.byType(CustomPaint), findsWidgets);
  });
}
