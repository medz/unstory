import 'history.dart';
import 'history_strategy.dart';
import 'web/browser_history.dart';
import 'web/hash_history.dart';

History createHistoryImpl({String? base, HistoryStrategy strategy = .browser}) {
  switch (strategy) {
    case .browser:
      return BrowserHistory(base: base);
    case .hash:
      return HashHistory(base: base);
  }
}
