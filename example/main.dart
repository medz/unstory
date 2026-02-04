import 'package:unstory/unstory.dart';

void main() {
  final history = createHistory(base: '/app', strategy: .browser);

  history.listen((event) {
    print('action=${event.action} location=${event.location}');
  });

  history.push(Uri.parse('/docs'), state: {'tab': 'intro'});
  history.replace(Uri.parse('/docs?tab=api'));
  history.back();

  history.dispose();
}
