import 'package:web/web.dart' as web;

import '../history.dart';
import '../utils.dart';
import 'url_based_history.dart';

/// A web [History] that uses path-based URLs (e.g. `/about`).
///
/// The current location is read from `window.location` using:
/// - `pathname` as [Uri.path]
/// - `search` as [Uri.query]
/// - `hash` as [Uri.fragment]
class BrowserHistory extends UrlBasedHistory {
  /// Creates a [BrowserHistory] that reads/writes path-based URLs.
  ///
  /// If [window] is omitted, the default browser window is used.
  BrowserHistory({super.base, super.window});

  @override
  HistoryLocation get location {
    final web.Location(:pathname, :search, :hash) = window.location;
    final path = ensureLeadingSlash(pathname);
    final uri = Uri(
      path: stripBase(path, base),
      query: search.startsWith('?') ? search.substring(1) : search,
      fragment: hash.startsWith('#') ? hash.substring(1) : hash,
    );
    return HistoryLocation(uri, state?.userData);
  }

  @override
  String createHref(Uri uri) => applyBase(uri, base).toString();
}
