import 'history.dart';
import 'history_strategy.dart';
import 'web/browser_history.dart';
import 'web/hash_history.dart';

History createHistoryImpl({
  String? base,
  HistoryStrategy strategy = HistoryStrategy.browser,
}) {
  switch (strategy) {
    case HistoryStrategy.browser:
      return BrowserHistory(base: base);
    case HistoryStrategy.hash:
      return HashHistory(base: base);
  }
}
