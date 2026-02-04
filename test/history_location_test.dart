import 'package:test/test.dart';
import 'package:unstory/unstory.dart';

void main() {
  test('exposes uri parts and state', () {
    final location = HistoryLocation(Uri.parse('/path/segment?query=1#frag'), {
      'ok': true,
    });

    expect(location.path, '/path/segment');
    expect(location.query, 'query=1');
    expect(location.fragment, 'frag');
    expect(location.state, {'ok': true});
    expect(location.toString(), '/path/segment?query=1#frag');
  });
}
