import 'history.dart';
import 'history_strategy.dart';
import 'create_history_stub.dart'
    if (dart.library.js_interop) 'create_history_web.dart';

/// Creates a [History] based on the current platform.
///
/// On web (JS interop available), returns a [BrowserHistory] or [HashHistory]
/// based on [strategy]. On non-web platforms, returns [MemoryHistory].
History createHistory({
  String? base,
  HistoryStrategy strategy = HistoryStrategy.browser,
}) {
  return createHistoryImpl(base: base, strategy: strategy);
}
