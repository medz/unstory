# Unstory Example

```dart
import 'package:unstory/unstory.dart';

void main() {
  final history = createHistory(
    base: '/app',
    strategy: HistoryStrategy.browser,
  );

  history.listen((event) {
    // Respond to back/forward/go navigations.
    print('action=${event.action} location=${event.location}');
  });

  history.push(Uri.parse('/docs'), state: {'tab': 'intro'});
  history.replace(Uri.parse('/docs?tab=api'));
  history.back();

  history.dispose();
}
```
