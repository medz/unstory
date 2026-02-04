import 'dart:js_interop';

import 'package:web/web.dart' as web;

import '../history.dart';
import '../utils.dart';
import 'history_state.dart';

/// Base class for web [History] implementations backed by `window.history`.
///
/// This class wires up the browser `popstate` event and implements:
/// - [push] / [replace] (synchronous, do not emit events)
/// - [go] / [back] / [forward] (emit events via `popstate`)
abstract class UrlBasedHistory extends History {
  UrlBasedHistory({String? base, web.Window? window})
    : base = normalizeBase(base) {
    this.window = window ?? web.document.defaultView ?? web.window;
    index = state?.index ?? 0;
    if (index == 0) {
      final nextState = HistoryState(
        identifier: state?.identifier ?? generateIdentifier(),
        userData: state?.userData,
        index: index ?? 0,
      );
      this.window.history.replaceState(nextState.toJson().jsify(), '');
    }

    this.window.addEventListener('popstate', _didPopJsFunction);
  }

  @override
  final String base;

  late final web.Window window;

  @override
  int? index;

  final listeners = <HistoryListener>[];
  late final JSFunction _didPopJsFunction = _didPop.toJS;

  @override
  HistoryAction action = .pop;

  bool _ignoreNextPop = false;

  @override
  void push(Uri uri, {Object? state}) {
    action = .push;
    index = (this.state?.index ?? 0) + 1;
    final historyState = HistoryState(
      userData: state,
      index: index ?? 0,
      identifier: generateIdentifier(),
    );

    window.history.pushState(
      historyState.toJson().jsify(),
      '',
      createHref(uri),
    );
  }

  @override
  void replace(Uri uri, {Object? state}) {
    action = .replace;
    index = this.state?.index ?? 0;
    final historyState = HistoryState(
      identifier: this.state?.identifier ?? generateIdentifier(),
      index: index ?? 0,
      userData: state,
    );

    window.history.replaceState(
      historyState.toJson().jsify(),
      '',
      createHref(uri),
    );
  }

  @override
  void go(int delta, {bool triggerListeners = true}) {
    if (!triggerListeners) {
      _ignoreNextPop = true;
    }
    window.history.go(delta);
  }

  @override
  void Function() listen(HistoryListener listener) {
    listeners.add(listener);
    return () {
      listeners.removeWhere((entry) => entry == listener);
    };
  }

  @override
  void dispose() {
    window.removeEventListener('popstate', _didPopJsFunction);
    listeners.clear();
  }

  HistoryState? get state {
    final dartified = window.history.state.dartify();
    if (dartified is Map) {
      return HistoryState.fromJson(dartified);
    }
    return null;
  }

  void _didPop(web.PopStateEvent _) {
    if (_ignoreNextPop) {
      _ignoreNextPop = false;
      return;
    }
    action = .pop;
    final nextIndex = state?.index;
    final delta = nextIndex == null ? null : nextIndex - (index ?? 0);
    index = nextIndex ?? 0;
    final event = HistoryEvent(
      action: action,
      location: location,
      delta: delta,
    );

    for (final listener in listeners) {
      listener(event);
    }
  }
}
