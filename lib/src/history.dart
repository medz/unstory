/// The kind of navigation that produced the current location.
enum HistoryAction {
  /// Navigation caused by [History.go], [History.back], or [History.forward].
  pop,

  /// A new entry was added to the history stack via [History.push].
  push,

  /// The current entry was replaced via [History.replace].
  replace,
}

/// The current location for a [History] implementation.
class HistoryLocation {
  final Uri uri;
  final Object? state;

  const HistoryLocation(this.uri, [this.state]);

  String get path => uri.path;
  String get query => uri.query;
  String get fragment => uri.fragment;

  @override
  String toString() => uri.toString();
}

/// A navigation event emitted by [History.listen].
class HistoryEvent {
  /// The type of navigation that occurred.
  final HistoryAction action;

  /// The new location after the navigation finished.
  final HistoryLocation location;

  /// The navigation delta, if known (e.g. -1 for back, +1 for forward).
  final int? delta;

  const HistoryEvent({
    required this.action,
    required this.location,
    this.delta,
  });
}

typedef HistoryListener = void Function(HistoryEvent event);

/// A minimal browser-like history abstraction.
///
/// Contract:
/// - [push] and [replace] update [location] immediately and MUST NOT trigger
///   listeners registered via [listen].
/// - [go] / [back] / [forward] represent moving within the existing history
///   stack. Implementations SHOULD notify listeners with a [HistoryEvent] when
///   the navigation completes.
abstract class History {
  const History();

  /// The base path applied when creating hrefs.
  String get base;

  /// The last navigation action performed by this history.
  HistoryAction get action;

  /// The current location.
  HistoryLocation get location;

  /// The current index in the history stack, if available.
  int? get index;

  /// Formats a [Uri] as an href for this history implementation.
  String createHref(Uri uri);

  /// Pushes a new history entry.
  void push(Uri uri, {Object? state});

  /// Replaces the current history entry.
  void replace(Uri uri, {Object? state});

  /// Moves within the history stack by [delta] entries.
  ///
  /// When [triggerListeners] is false, implementations should suppress
  /// [listen] notifications for this navigation.
  void go(int delta, {bool triggerListeners = true});

  /// Equivalent to calling [go] with `-1`.
  void back() => go(-1);

  /// Equivalent to calling [go] with `+1`.
  void forward() => go(1);

  /// Registers a listener that is called when a `pop` navigation completes.
  ///
  /// Returns a function that removes the listener.
  void Function() listen(HistoryListener listener);

  /// Releases resources held by the history (e.g. DOM event listeners).
  void dispose();
}
