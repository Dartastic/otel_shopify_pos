// Licensed under the Apache License, Version 2.0
// Copyright 2025, Mindful Software LLC, All rights reserved.

import 'package:otel_shopify_pos/otel_shopify_pos.dart';
import 'package:test/test.dart';

void main() {
  group('otel_shopify_pos', () {
    test('suppression toggles in zone', () async {
      expect(shopifyPOSInstrumentationSuppressed(), isFalse);
      await runWithoutShopifyPOSInstrumentationAsync(() async {
        expect(shopifyPOSInstrumentationSuppressed(), isTrue);
      });
      expect(shopifyPOSInstrumentationSuppressed(), isFalse);
    });

    test('ShopifyPOSResult fields default null', () {
      const r = ShopifyPOSResult();
      expect(r.statusCode, isNull);
    });
  });
}
