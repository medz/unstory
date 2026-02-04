import 'package:web/web.dart' as web;

import '../history.dart';
import '../utils.dart';
import 'url_based_history.dart';

/// A web [History] that stores the route inside the URL fragment (e.g. `/#/about`).
///
/// This strategy commonly works on static hosts without server-side rewrite
/// rules, because the browser will only request `/` from the server.
class HashHistory extends UrlBasedHistory {
  /// Creates a [HashHistory] that stores the route in `location.hash`.
  ///
  /// If [window] is omitted, the default browser window is used.
  HashHistory({super.base, super.window});

  @override
  HistoryLocation get location {
    final web.Location(:hash) = window.location;
    final path = hash.startsWith('#') ? hash.substring(1) : hash;
    final uri = Uri.parse(ensureLeadingSlash(path));
    return HistoryLocation(uri, state?.userData);
  }

  @override
  String createHref(Uri uri) {
    final buffer = StringBuffer();
    final baseHref = _resolveBaseHref();
    if (baseHref.isNotEmpty) {
      buffer.write(baseHref);
    }

    buffer.write('#${ensureLeadingSlash(uri.path)}');
    if (uri.hasQuery) {
      buffer.write('?${uri.query}');
    }
    if (uri.hasFragment) {
      buffer.write('#${uri.fragment}');
    }

    return buffer.toString();
  }

  String _resolveBaseHref() {
    if (base.isNotEmpty) {
      return base;
    }

    final baseElement = window.document.querySelector('base');
    if (baseElement != null && baseElement.getAttribute('href') != null) {
      return Uri.parse(window.location.href).removeFragment().toString();
    }

    return '';
  }
}
