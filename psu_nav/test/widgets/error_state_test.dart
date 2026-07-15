import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:psu_nav/widgets/common/error_state.dart';

void main() {
  testWidgets('error state explains failure and retries', (tester) async {
    var retried = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ErrorState(
            message: 'ไม่สามารถโหลดข้อมูลได้',
            onRetry: () => retried = true,
          ),
        ),
      ),
    );

    expect(find.text('ไม่สามารถโหลดข้อมูลได้'), findsOneWidget);
    expect(find.text('ลองใหม่'), findsOneWidget);

    await tester.tap(find.text('ลองใหม่'));

    expect(retried, isTrue);
  });
}
