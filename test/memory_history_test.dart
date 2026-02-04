import 'package:test/test.dart';
import 'package:unstory/unstory.dart';

import 'contract/history_matrix.dart';

void main() {
  defineHistoryMatrixTests(
    label: 'MemoryHistory shared behavior',
    create: () => MemoryHistory(),
    firstLocation: Uri.parse('/first?x=1#frag'),
    secondLocation: Uri.parse('/second?y=2#frag2'),
  );

  group('MemoryHistory', () {
    test('defaults to a single / entry', () {
      final history = MemoryHistory();
      expect(history.base, '');
      expect(history.index, 0);
      expect(history.location.path, '/');
      expect(history.action, HistoryAction.pop);
    });

    test('normalizes base', () {
      final history = MemoryHistory(base: '/app/');
      expect(history.base, '/app');
    });

    test('clamps initialIndex to the valid range', () {
      final entries = [
        HistoryLocation(Uri.parse('/a')),
        HistoryLocation(Uri.parse('/b')),
      ];

      final low = MemoryHistory(initialEntries: entries, initialIndex: -5);
      expect(low.index, 0);
      expect(low.location.path, '/a');

      final high = MemoryHistory(initialEntries: entries, initialIndex: 99);
      expect(high.index, 1);
      expect(high.location.path, '/b');
    });

    test('go clamps to the available history range', () {
      final history = MemoryHistory(
        initialEntries: [
          HistoryLocation(Uri.parse('/a')),
          HistoryLocation(Uri.parse('/b')),
        ],
        initialIndex: 0,
      );

      history.go(-10);
      expect(history.index, 0);
      expect(history.location.path, '/a');

      history.go(10);
      expect(history.index, 1);
      expect(history.location.path, '/b');
    });

    test('push after going back clears forward entries', () {
      final history = MemoryHistory(
        initialEntries: [
          HistoryLocation(Uri.parse('/a')),
          HistoryLocation(Uri.parse('/b')),
          HistoryLocation(Uri.parse('/c')),
        ],
        initialIndex: 2,
      );

      history.go(-1);
      expect(history.location.path, '/b');

      history.push(Uri.parse('/d'));
      expect(history.location.path, '/d');

      history.go(-1);
      expect(history.location.path, '/b');
    });

    test('pushes the same path as a new entry', () {
      final history = MemoryHistory();

      history.push(Uri.parse('/repeat'));
      history.push(Uri.parse('/repeat'));

      expect(history.index, 2);

      history.go(-1);
      expect(history.location.path, '/repeat');
      history.go(-1);
      expect(history.location.path, '/');
    });

    test('createHref applies the base', () {
      final history = MemoryHistory(base: 'app/');
      final href = history.createHref(Uri(path: 'route'));
      expect(href, '/app/route');
    });
  });
}
