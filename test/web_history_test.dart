@TestOn('browser')
library;

import 'package:test/test.dart';
import 'package:unstory/web.dart';
import 'package:web/web.dart' as web;

import 'contract/history_matrix.dart';

void main() {
  final window = web.window;

  setUp(() {
    window.document.querySelector('base')?.remove();
    window.history.replaceState(null, '', '/');
  });

  defineHistoryMatrixTests(
    label: 'BrowserHistory shared behavior',
    create: () => BrowserHistory(window: window),
    firstLocation: Uri.parse('/first?x=1#frag'),
    secondLocation: Uri.parse('/second?y=2#frag2'),
  );

  defineHistoryMatrixTests(
    label: 'HashHistory shared behavior',
    create: () => HashHistory(window: window),
    firstLocation: Uri.parse('/first?x=1#frag'),
    secondLocation: Uri.parse('/second?y=2#frag2'),
  );

  group('BrowserHistory', () {
    test('normalizes base', () {
      final history = BrowserHistory(base: '/app/', window: window);
      addTearDown(history.dispose);

      expect(history.base, '/app');
    });

    test('reads location and strips base', () {
      window.history.replaceState(null, '', '/app/profile?tab=1#bio');

      final history = BrowserHistory(base: '/app', window: window);
      addTearDown(history.dispose);
      final location = history.location;

      expect(location.path, '/profile');
      expect(location.query, 'tab=1');
      expect(location.fragment, 'bio');
    });

    test('strips base when location matches base root', () {
      window.history.replaceState(null, '', '/app');

      final history = BrowserHistory(base: '/app', window: window);
      addTearDown(history.dispose);

      expect(history.location.path, '/');
    });

    test('createHref applies base and preserves query', () {
      final history = BrowserHistory(base: 'app', window: window);
      addTearDown(history.dispose);
      final href = history.createHref(
        Uri(path: '/next', queryParameters: {'q': '1'}),
      );

      expect(href, '/app/next?q=1');
    });

    test('createHref avoids double slashes with trailing base', () {
      final history = BrowserHistory(base: '/app/', window: window);
      addTearDown(history.dispose);

      final href = history.createHref(Uri(path: '/next'));

      expect(href, '/app/next');
    });

    test('push updates window location', () {
      final history = BrowserHistory(window: window);
      addTearDown(history.dispose);

      history.push(Uri.parse('/next?x=1#frag'), state: 'payload');

      expect(history.location.path, '/next');
      expect(history.location.query, 'x=1');
      expect(history.location.fragment, 'frag');
      expect(history.location.state, 'payload');
      expect(window.location.pathname, '/next');
    });

    test('replace updates window location', () {
      final history = BrowserHistory(window: window);
      addTearDown(history.dispose);

      history.replace(Uri.parse('/replace'), state: 123);

      expect(history.location.path, '/replace');
      expect(history.location.state, 123);
      expect(window.location.pathname, '/replace');
    });
  });

  group('HashHistory', () {
    test('normalizes base', () {
      final history = HashHistory(base: 'app/', window: window);
      addTearDown(history.dispose);

      expect(history.base, '/app');
    });

    test('parses location from hash', () {
      window.history.replaceState(null, '', '/#/start?x=1#frag');

      final history = HashHistory(window: window);
      addTearDown(history.dispose);
      final location = history.location;

      expect(location.path, '/start');
      expect(location.query, 'x=1');
      expect(location.fragment, 'frag');
    });

    test('createHref uses hash routing', () {
      final history = HashHistory(window: window);
      addTearDown(history.dispose);
      final href = history.createHref(
        Uri(path: '/about', queryParameters: {'q': '1'}, fragment: 'frag'),
      );

      expect(href, '#/about?q=1#frag');
    });

    test('createHref prefixes explicit base', () {
      final history = HashHistory(base: '/app', window: window);
      addTearDown(history.dispose);
      final href = history.createHref(Uri(path: '/about'));

      expect(href, '/app#/about');
    });

    test('explicit base overrides base element', () {
      final base = window.document.createElement('base');
      base.setAttribute('href', '/base/');
      window.document.head!.append(base);

      final history = HashHistory(base: '/app', window: window);
      addTearDown(history.dispose);
      final href = history.createHref(Uri(path: '/about'));

      expect(href, '/app#/about');
    });

    test('createHref uses base element when present', () {
      window.history.replaceState(null, '', '/base-element');
      final base = window.document.createElement('base');
      base.setAttribute('href', '/');
      window.document.head!.append(base);

      final history = HashHistory(window: window);
      addTearDown(history.dispose);
      final href = history.createHref(Uri(path: '/about'));

      expect(href, '${window.location.href}#/about');
    });

    test('base element uses current location without fragment', () {
      window.history.replaceState(null, '', '/prefix#/existing');
      final base = window.document.createElement('base');
      base.setAttribute('href', '/ignored');
      window.document.head!.append(base);

      final history = HashHistory(window: window);
      addTearDown(history.dispose);
      final href = history.createHref(Uri(path: '/about'));

      final expectedPrefix = Uri.parse(
        window.location.href,
      ).removeFragment().toString();
      expect(href, '$expectedPrefix#/about');
    });

    test('ensures leading slash when hash omits it', () {
      window.history.replaceState(null, '', '/#about');

      final history = HashHistory(window: window);
      addTearDown(history.dispose);

      expect(history.location.path, '/about');
    });
  });
}
