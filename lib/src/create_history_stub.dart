import 'history.dart';
import 'history_strategy.dart';
import 'memory_history.dart';

History createHistoryImpl({String? base, HistoryStrategy strategy = .browser}) {
  return MemoryHistory(base: base);
}
