# otel_shopify_pos

Dartastic OpenTelemetry bridge for Shopify POS (in-store + omnichannel).

Wraps each call in a CLIENT-kind span with vendor-specific attributes following OpenTelemetry semantic conventions where applicable.

```dart
import 'package:otel_shopify_pos/otel_shopify_pos.dart';

await tracedShopifyPOS<void>(
  operation: 'someOp',
  invoke: () async {
    final r = await client.someOp();
    return ShopifyPOSCallResult(value: r, result: ShopifyPOSResult(statusCode: 200));
  },
);
```

Suppress instrumentation within a block:

```dart
await runWithoutShopifyPOSInstrumentationAsync(() async {
  await client.someInternalSync();
});
```
