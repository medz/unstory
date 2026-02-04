import 'package:test/test.dart';
import 'package:unstory/unstory.dart';

import 'history_test_utils.dart';

typedef HistoryFactory = History Function();

void defineHistoryMatrixTests({
  required String label,
  required HistoryFactory create,
  required Uri firstLocation,
  required Uri secondLocation,
}) {
  group(label, () {
    test('listen does not fire immediately', () {
      final history = create();
      addTearDown(history.dispose);
      var called = false;

      history.listen((_) => called = true);

      expect(called, isFalse);
    });

    test('listen disposer stops events', () async {
      final history = create();
      addTearDown(history.dispose);
      var calls = 0;

      final remove = history.listen((_) => calls++);
      remove();

      history.push(firstLocation);
      final popFuture = waitForPop(history);
      history.go(-1);
      await popFuture;

      expect(calls, 0);
    });

    test('removing the same listener is a no-op', () async {
      final history = create();
      addTearDown(history.dispose);
      var calls = 0;

      final remove = history.listen((_) => calls++);
      remove();
      remove();

      history.push(firstLocation);
      final popFuture = waitForPop(history);
      history.go(-1);
      await popFuture;

      expect(calls, 0);
    });

    test('push updates location without notifying listeners', () {
      final history = create();
      addTearDown(history.dispose);
      var calls = 0;
      history.listen((_) => calls++);

      history.push(firstLocation, state: 'payload');

      expect(history.action, HistoryAction.push);
      expect(history.location.path, firstLocation.path);
      expect(history.location.query, firstLocation.query);
      expect(history.location.fragment, firstLocation.fragment);
      expect(history.location.state, 'payload');
      expect(calls, 0);
    });

    test('replace updates location without notifying listeners', () {
      final history = create();
      addTearDown(history.dispose);
      var calls = 0;
      history.listen((_) => calls++);

      history.replace(secondLocation, state: 42);

      expect(history.action, HistoryAction.replace);
      expect(history.location.path, secondLocation.path);
      expect(history.location.query, secondLocation.query);
      expect(history.location.fragment, secondLocation.fragment);
      expect(history.location.state, 42);
      expect(calls, 0);
    });

    test('go notifies listeners with delta', () async {
      final history = create();
      addTearDown(history.dispose);

      history.push(firstLocation);
      history.push(secondLocation);

      final popFuture = waitForPop(history);
      history.go(-1);
      final event = await popFuture;

      expect(history.action, HistoryAction.pop);
      expect(event.action, HistoryAction.pop);
      expect(event.delta, -1);
      expect(history.location.path, firstLocation.path);
      expect(history.location.query, firstLocation.query);
      expect(history.location.fragment, firstLocation.fragment);
      expect(event.location.path, firstLocation.path);
      expect(event.location.query, firstLocation.query);
      expect(event.location.fragment, firstLocation.fragment);
    });

    test('back and forward move through the stack', () async {
      final history = create();
      addTearDown(history.dispose);

      history.push(firstLocation);
      history.push(secondLocation);

      final backFuture = waitForPop(history);
      history.back();
      final backEvent = await backFuture;

      expect(backEvent.action, HistoryAction.pop);
      expect(backEvent.delta, -1);
      expect(history.location.path, firstLocation.path);

      final forwardFuture = waitForPop(history);
      history.forward();
      final forwardEvent = await forwardFuture;

      expect(forwardEvent.action, HistoryAction.pop);
      expect(forwardEvent.delta, 1);
      expect(history.location.path, secondLocation.path);
    });

    test('go can suppress listener notifications', () async {
      final history = create();
      addTearDown(history.dispose);

      history.push(firstLocation);
      await expectNoPop(history, () => history.go(-1, triggerListeners: false));

      expect(history.location.path, '/');
    });
  });
}
