import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:psu_nav/app/app_theme.dart';
import 'package:psu_nav/widgets/common/responsive_list.dart';

void main() {
  testWidgets('tablet list allows cards to use their natural height', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 800,
            height: 600,
            child: ResponsiveList(
              device: DeviceType.tablet,
              children: [
                Container(
                  color: Colors.white,
                  child: const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 220),
                      Text('การ์ดเนื้อหาสูง'),
                      SizedBox(height: 80),
                    ],
                  ),
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(find.text('การ์ดเนื้อหาสูง'), findsOneWidget);
  });
}
