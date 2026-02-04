import 'package:test/test.dart';
import 'package:unstory/src/web/history_state.dart';

void main() {
  group('HistoryState', () {
    test('serializes to json', () {
      final state = HistoryState(
        index: 2,
        identifier: 'state-1',
        userData: {'key': 'value'},
      );
      final json = state.toJson();

      expect(json['index'], 2);
      expect(json['identifier'], 'state-1');
      expect(json['userData'], {'key': 'value'});
    });

    test('deserializes with defaults', () {
      final state = HistoryState.fromJson({
        'identifier': 'state-2',
        'userData': 123,
      });

      expect(state.index, 0);
      expect(state.identifier, 'state-2');
      expect(state.userData, 123);
    });
  });
}
