import 'dart:async';

import 'package:test/test.dart';
import 'package:unstory/unstory.dart';

Future<HistoryEvent> waitForPop(
  History history, {
  Duration timeout = const Duration(seconds: 1),
}) {
  final completer = Completer<HistoryEvent>();
  final remove = history.listen((event) {
    if (completer.isCompleted) return;
    completer.complete(event);
  });

  return completer.future
      .timeout(
        timeout,
        onTimeout: () {
          throw TimeoutException('Timed out waiting for pop navigation');
        },
      )
      .whenComplete(remove);
}

Future<void> expectNoPop(
  History history,
  FutureOr<void> Function() action, {
  Duration timeout = const Duration(milliseconds: 200),
}) async {
  final popFuture = waitForPop(history, timeout: timeout);
  await Future<void>.sync(action);
  try {
    await popFuture;
    fail('Expected no pop navigation');
  } on TimeoutException {
    // Expected: no pop event within timeout.
  }
}
