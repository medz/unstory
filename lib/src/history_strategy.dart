/// Strategies available for web history creation.
enum HistoryStrategy {
  /// Path-based URLs (e.g. `/about`).
  browser,

  /// Hash-based URLs (e.g. `/#/about`).
  hash,
}
