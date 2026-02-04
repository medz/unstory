import 'history.dart';
import 'history_strategy.dart';
import 'memory_history.dart';

History createHistoryImpl({
  String? base,
  HistoryStrategy strategy = HistoryStrategy.browser,
}) {
  return MemoryHistory(base: base);
}
