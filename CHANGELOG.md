## 0.1.0

- Initial release with a cross-platform history abstraction.
- Core `History` API with `push`, `replace`, `go`, and `listen` semantics.
- `MemoryHistory` for all platforms.
- Web histories: `BrowserHistory` and `HashHistory`.
- `createHistory` helper with `HistoryStrategy` for automatic selection.
