/// Strategies available for web history creation.
///
/// Used by [createHistory] when JS interop is available.
enum HistoryStrategy {
  /// Path-based URLs (e.g. `/about`).
  browser,

  /// Hash-based URLs (e.g. `/#/about`).
  hash,
}
