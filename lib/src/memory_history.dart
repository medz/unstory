import 'history.dart';
import 'utils.dart';

/// Internal entry for [MemoryHistory] that includes an identifier.
class _MemoryEntry {
  final HistoryLocation location;
  final String identifier;

  const _MemoryEntry({required this.location, required this.identifier});
}

/// An in-memory [History] implementation.
///
/// Browser semantics:
/// - [push] and [replace] update [location] immediately and do **not** notify
///   listeners.
/// - [go] / [back] / [forward] notify listeners synchronously.
class MemoryHistory extends History {
  /// Creates a [MemoryHistory] with an optional initial stack.
  ///
  /// If [initialEntries] is omitted (or empty), the stack starts with a single
  /// entry at `/`.
  ///
  /// If provided, [initialIndex] is clamped to the valid range.
  MemoryHistory({
    List<HistoryLocation>? initialEntries,
    int? initialIndex,
    String? base,
  }) : base = normalizeBase(base) {
    final entries = (initialEntries == null || initialEntries.isEmpty)
        ? [HistoryLocation(Uri.parse('/'))]
        : initialEntries;
    _entries = entries
        .map(
          (location) => _MemoryEntry(
            location: location,
            identifier: generateIdentifier(),
          ),
        )
        .toList();
    index = _clampIndex(initialIndex ?? _entries.length - 1);
  }

  late final List<_MemoryEntry> _entries;

  @override
  late int index;

  @override
  final String base;

  final listeners = <HistoryListener>[];

  @override
  HistoryAction action = .pop;

  @override
  HistoryLocation get location => _entries.elementAt(index).location;

  @override
  String createHref(Uri uri) => applyBase(uri, base).toString();

  @override
  void push(Uri uri, {Object? state}) {
    action = .push;
    index += 1;
    _entries
      ..length = index
      ..add(
        _MemoryEntry(
          location: HistoryLocation(uri, state),
          identifier: generateIdentifier(),
        ),
      );
  }

  @override
  void replace(Uri uri, {Object? state}) {
    action = .replace;
    _entries[index] = _MemoryEntry(
      location: HistoryLocation(uri, state),
      identifier: generateIdentifier(),
    );
  }

  @override
  void go(int delta, {bool triggerListeners = true}) {
    action = .pop;
    index = _clampIndex(index + delta);
    if (!triggerListeners) return;
    final event = HistoryEvent(
      action: action,
      location: location,
      delta: delta,
    );
    for (final listener in listeners) {
      listener(event);
    }
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
    _entries.clear();
    listeners.clear();
  }

  int _clampIndex(int value) => value.clamp(0, _entries.length - 1);
}
