@TestOn('vm')
library;

import 'package:test/test.dart';
import 'package:unstory/unstory.dart';

void main() {
  test('createHistory returns memory history on non-web platforms', () {
    final history = createHistory(strategy: .hash);
    expect(history, isA<MemoryHistory>());
  });
}
