import 'package:flutter_test/flutter_test.dart';

import 'package:psu_nav/main.dart';

void main() {
  testWidgets('PSU Navigator prototype renders core navigation', (
    tester,
  ) async {
    await tester.pumpWidget(const PsuNavigatorApp());
    await tester.pump();

    expect(find.text('Campus Navigator'), findsOneWidget);
    expect(find.text('แผนที่'), findsOneWidget);

    await tester.tap(find.text('รถ'));
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pump(const Duration(milliseconds: 600));

    expect(find.text('สาย 1'), findsWidgets);
  });
}
