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
}
