// Licensed under the Apache License, Version 2.0
// Copyright 2025-2026 Mindful Software LLC d/b/a Dartastic.io, All rights reserved.

import 'package:dartastic_opentelemetry/dartastic_opentelemetry.dart';
import 'package:otel_shopify_pos/otel_shopify_pos.dart';

/// Traces Shopify Pos calls with OpenTelemetry.
///
/// `otel_shopify_pos` depends on the OpenTelemetry API only, so the application
/// initializes an SDK once at startup. Wrap each Shopify Pos call in
/// [tracedShopifyPOS]; the `invoke` callback makes the real call and reports what
/// came back, which is recorded on the span.
Future<void> main() async {
  await OTel.initialize(serviceName: 'shopify-pos-example');

  // Traces a Shopify Pos call.
  final shopifyPOSId = await tracedShopifyPOS<String>(
    operation: 'create',
    invoke: () async {
      // Make the Shopify Pos call here, then report what it returned.
      const id = 'shopify_pos_8f3a2c';
      return const ShopifyPOSCallResult(
          value: id,
          result: ShopifyPOSResult(
              shopId: 'shop_8f3a2c',
              locationId: 'location_8f3a2c',
              orderId: 'order_8f3a2c',
              posOrderId: 'posorder_8f3a2c',
              staffMember: 'example',
              customerId: 'customer_8f3a2c',
              amount: 0.5,
              currency: 'usd',
              statusCode: 201,
              errorCode: 'example',
              errorMessage: 'example'));
    },
  );
  OTelLog.info('tracedShopifyPOS create returned $shopifyPOSId');

  // Calls that should not be traced, such as health checks, run inside
  // runWithoutShopifyPOSInstrumentationAsync.
  await runWithoutShopifyPOSInstrumentationAsync(
    () => tracedShopifyPOS<String>(
      operation: 'create',
      invoke: () async {
        const id = 'shopify_pos_8f3a2c';
        return const ShopifyPOSCallResult(
            value: id,
            result: ShopifyPOSResult(
                shopId: 'shop_8f3a2c',
                locationId: 'location_8f3a2c',
                orderId: 'order_8f3a2c',
                posOrderId: 'posorder_8f3a2c',
                staffMember: 'example',
                customerId: 'customer_8f3a2c',
                amount: 0.5,
                currency: 'usd',
                statusCode: 201,
                errorCode: 'example',
                errorMessage: 'example'));
      },
    ),
  );

  await OTel.shutdown();
}
