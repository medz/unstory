# unstory

A browser-style history abstraction for Dart and Flutter routing.

## Usage

```dart
import 'package:unstory/unstory.dart';
import 'package:unstory/web.dart';

final memory = MemoryHistory();
final browser = BrowserHistory();
final hash = HashHistory();

memory.listen((event) {
  // respond to pop navigations
});

memory.push(Uri.parse('/docs'), state: {'tab': 'intro'});
```

## Semantics

- `push`/`replace` update the current location immediately and **do not** notify
  listeners.
- `go`/`back`/`forward` move within the stack and **do** notify listeners.

## Platforms

- `MemoryHistory` works on all platforms.
- `BrowserHistory` and `HashHistory` are available from `package:unstory/web.dart`.
