# unstory

A small, cross-platform history abstraction for Dart and Flutter routing.

Unstory provides a minimal, browser-like `History` interface with consistent
semantics and multiple implementations (memory, browser path, and hash).

## Installation

```bash
dart pub add unstory
```

## Quick Start

Memory history (works everywhere):

```dart
import 'package:unstory/unstory.dart';

final history = MemoryHistory();

history.listen((event) {
  // Respond to back/forward/go navigations.
});

history.push(Uri.parse('/docs'), state: {'tab': 'intro'});
history.replace(Uri.parse('/docs?tab=api'));
history.back();
```

Web history:

```dart
import 'package:unstory/web.dart';

final browser = BrowserHistory(base: '/app');
final hash = HashHistory();

browser.push(Uri.parse('/account'));
```

Auto history (web uses browser/hash, otherwise memory):

```dart
import 'package:unstory/unstory.dart';

final history = createHistory(
  base: '/app',
  strategy: HistoryStrategy.browser,
);
```

## API Overview

`History` exposes a small set of primitives:

- `createHref(Uri)` to format a URL for the current history strategy.
- `push(Uri, {state})` and `replace(Uri, {state})` to update the current entry.
- `go(int)`, `back()`, and `forward()` to move in the history stack.
- `listen((HistoryEvent) => void)` to observe pop navigations.
- `dispose()` to release resources.

Core types:

- `HistoryLocation` wraps a `Uri` plus optional `state`.
- `HistoryEvent` includes `action`, `location`, and optional `delta`.
- `HistoryAction` is one of `pop`, `push`, or `replace`.

## Semantics

- `push` and `replace` update `location` immediately and do not notify listeners.
- `go`/`back`/`forward` move within the stack and notify listeners with a
  `HistoryEvent`.
- `listen` returns a disposer function to remove the listener.

## Base Behavior

The optional `base` value maps between internal routes and external URLs:

- `createHref` prepends the base.
- `BrowserHistory` strips the base from `window.location` when reading.
- `HashHistory` uses the base when building hash-based URLs. If no base is
  provided, it may fall back to the page `<base>` element.

## Platforms

- `MemoryHistory` works on all platforms.
- `BrowserHistory` and `HashHistory` are web-only and live in
  `package:unstory/web.dart`.

## Non-Goals

Unstory is not a router. It does not do route matching, guards, transitions, or
data loading. It only provides a consistent history abstraction.

## License

MIT. See `LICENSE`.
