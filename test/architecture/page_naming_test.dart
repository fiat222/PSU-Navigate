import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('presentation files and classes use page naming', () {
    expect(Directory('lib/screens').existsSync(), isFalse);
    expect(Directory('lib/pages').existsSync(), isTrue);

    final sources = Directory('lib')
        .listSync(recursive: true)
        .whereType<File>()
        .where((file) => file.path.endsWith('.dart'));

    for (final file in sources) {
      final source = file.readAsStringSync();
      expect(source, isNot(contains('/screens/')), reason: file.path);
      expect(
        RegExp(r'class\s+\w+Screen\b').hasMatch(source),
        isFalse,
        reason: file.path,
      );
    }
  });

  test('visible prototype copy does not claim inactive services', () {
    final sources = Directory('lib')
        .listSync(recursive: true)
        .whereType<File>()
        .where((file) => file.path.endsWith('.dart'))
        .map((file) => file.readAsStringSync())
        .join('\n');

    const removedClaims = [
      'Hat Yai campus · live',
      'Realtime shuttle · cached',
      'Place reviews · live feed',
      'Google Maps + PSU overlay',
      'WebSocket update',
      'ผู้ใช้ online ใน campus',
      'Offline cache',
      'JWT session · mock SSO',
      'ข้อมูล cache ล่าสุด',
      'แชทจะลบใน 5 นาที',
      'สุ่มหาเพื่อนแชทชั่วคราว',
      'เลือกรูปได้สูงสุด 3 รูปต่อคอมเมนต์',
    ];

    for (final claim in removedClaims) {
      expect(sources, isNot(contains(claim)), reason: claim);
    }
  });

  test('README and SRS are deliverable current-prototype documentation', () {
    final gitignoreLines = File('../.gitignore').readAsLinesSync();
    final readme = File('README.md').readAsStringSync();
    final srs = File('../docs/SRS.md').readAsStringSync();

    expect(gitignoreLines, contains('!docs/'));
    expect(gitignoreLines, contains('docs/*'));
    expect(gitignoreLines, contains('!docs/SRS.md'));

    for (final entry in {'README': readme, 'SRS': srs}.entries) {
      expect(entry.value, contains('flutter_bloc'), reason: entry.key);
      expect(entry.value, contains('NavigationBloc'), reason: entry.key);
      expect(entry.value, contains('RouteGenerator'), reason: entry.key);
      expect(entry.value, contains('in-memory mock'), reason: entry.key);
    }

    final srsCurrentImplementation = srs
        .split('## 5. สถาปัตยกรรม Production ในอนาคต')
        .first;
    expect(srsCurrentImplementation, isNot(contains('Riverpod')));
    expect(srsCurrentImplementation, isNot(contains('go_router')));
  });
}
