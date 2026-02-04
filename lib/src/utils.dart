int _identifierCounter = 0;

String generateIdentifier() {
  return 'loc_${_identifierCounter++}';
}

String normalizeBase(String? base) {
  if (base == null || base.isEmpty || base == '/') {
    return '';
  }
  var normalized = base.trim();
  if (!normalized.startsWith('/')) {
    normalized = '/$normalized';
  }
  if (normalized.length > 1 && normalized.endsWith('/')) {
    normalized = normalized.substring(0, normalized.length - 1);
  }
  return normalized;
}

String ensureLeadingSlash(String path) {
  if (path.isEmpty) return '/';
  return path.startsWith('/') ? path : '/$path';
}

String stripBase(String path, String base) {
  if (base.isEmpty) return path;
  if (path.startsWith(base)) {
    final stripped = path.substring(base.length);
    if (stripped.isEmpty) return '/';
    return stripped.startsWith('/') ? stripped : '/$stripped';
  }
  return path;
}

Uri applyBase(Uri uri, String base) {
  if (base.isEmpty) return uri;
  final path = ensureLeadingSlash(uri.path);
  return uri.replace(path: '$base$path');
}
