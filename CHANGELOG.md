# Changelog

## [0.1.0-beta.1-wip]

### Added

- Initial release.
- `tracedShopifyPOS<T>(...)` — wraps a otel_shopify_pos call in a CLIENT-kind span
  with vendor-specific attributes.
- Zone-scoped suppression via `runWithoutShopifyPOSInstrumentation()` / `Async()`.
