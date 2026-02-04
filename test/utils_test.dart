import 'package:test/test.dart';
import 'package:unstory/src/utils.dart';

void main() {
  group('normalizeBase', () {
    test('handles empty and root values', () {
      expect(normalizeBase(null), '');
      expect(normalizeBase(''), '');
      expect(normalizeBase('/'), '');
    });

    test('adds leading slash and trims trailing slash', () {
      expect(normalizeBase('app'), '/app');
      expect(normalizeBase('app/'), '/app');
      expect(normalizeBase('/app'), '/app');
      expect(normalizeBase('/app/'), '/app');
    });
  });

  group('ensureLeadingSlash', () {
    test('normalizes empty and relative paths', () {
      expect(ensureLeadingSlash(''), '/');
      expect(ensureLeadingSlash('about'), '/about');
      expect(ensureLeadingSlash('/about'), '/about');
    });
  });

  group('stripBase', () {
    test('removes base prefixes', () {
      expect(stripBase('/app', '/app'), '/');
      expect(stripBase('/app/', '/app'), '/');
      expect(stripBase('/app/about', '/app'), '/about');
    });

    test('returns original path when base is empty', () {
      expect(stripBase('/app', ''), '/app');
    });

    test('removes matching prefix even when not a path segment', () {
      expect(stripBase('/appx', '/app'), '/x');
    });
  });

  group('applyBase', () {
    test('returns original uri when base is empty', () {
      final uri = Uri(path: '/about', query: 'q=1');
      expect(applyBase(uri, ''), uri);
    });

    test('prepends base and preserves query/fragment', () {
      final uri = Uri(path: 'about', query: 'q=1', fragment: 'frag');
      final result = applyBase(uri, '/app');
      expect(result.path, '/app/about');
      expect(result.query, 'q=1');
      expect(result.fragment, 'frag');
    });
  });

  group('generateIdentifier', () {
    test('returns unique identifiers with expected prefix', () {
      final first = generateIdentifier();
      final second = generateIdentifier();
      expect(first, isNot(equals(second)));
      expect(first, startsWith('loc_'));
      expect(second, startsWith('loc_'));
    });
  });
}
