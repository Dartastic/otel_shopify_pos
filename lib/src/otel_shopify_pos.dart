// Licensed under the Dartastic Pro Software License Agreement.
// Copyright 2025-2026 Mindful Software LLC d/b/a Dartastic.io, All rights reserved.

import 'package:dartastic_opentelemetry/dartastic_opentelemetry.dart';

import 'otel_shopify_pos_suppression.dart';

class ShopifyPOSResult {
  const ShopifyPOSResult({
    this.shopId,
    this.locationId,
    this.orderId,
    this.posOrderId,
    this.staffMember,
    this.customerId,
    this.amount,
    this.currency,
    this.statusCode,
    this.errorCode,
    this.errorMessage,
  });

  final String? shopId;
  final String? locationId;
  final String? orderId;
  final String? posOrderId;
  final String? staffMember;
  final String? customerId;
  final double? amount;
  final String? currency;
  final int? statusCode;
  final String? errorCode;
  final String? errorMessage;
}

class ShopifyPOSCallResult<T> {
  const ShopifyPOSCallResult({required this.value, this.result});
  final T value;
  final ShopifyPOSResult? result;
}

Future<T> tracedShopifyPOS<T>({
  required String operation,
  required Future<ShopifyPOSCallResult<T>> Function() invoke,
  Tracer? tracer,
}) async {
  if (shopifyPOSInstrumentationSuppressed()) {
    final r = await invoke();
    return r.value;
  }
  final t = tracer ?? OTel.tracerProvider().getTracer('otel_shopify_pos');
  final span = t.startSpan('shopifypos $operation', kind: SpanKind.client);
  try {
    span.addAttributes(
        OTel.attributes([OTel.attributeString('rpc.system', 'shopify_pos')]));
    final r = await invoke();
    final res = r.result;
    if (res != null) {
      if (res.shopId != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeString('shopify.shop.id', res.shopId!)]));
      }
      if (res.locationId != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeString('shopify.location.id', res.locationId!)]));
      }
      if (res.orderId != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeString('shopify.order.id', res.orderId!)]));
      }
      if (res.posOrderId != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeString('shopify.pos.order.id', res.posOrderId!)]));
      }
      if (res.staffMember != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeString('shopify.staff.member', res.staffMember!)]));
      }
      if (res.customerId != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeString('shopify.customer.id', res.customerId!)]));
      }
      if (res.amount != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeDouble('shopify.amount', res.amount!)]));
      }
      if (res.currency != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeString('shopify.currency', res.currency!)]));
      }
      if (res.statusCode != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeInt('http.response.status_code', res.statusCode!)]));
      }
      if (res.errorCode != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeString('shopifypos.error.code', res.errorCode!)]));
      }
      final fail = res.errorCode != null ||
          (res.statusCode != null && res.statusCode! >= 400);
      if (fail) {
        span.addAttributes(OTel.attributes([
          OTel.attributeString(
            ErrorResource.errorType.key,
            res.errorCode ?? 'shopify_pos.error',
          )
        ]));
        span.setStatus(SpanStatusCode.Error, res.errorMessage);
      }
    }
    return r.value;
  } catch (e, st) {
    span.recordException(e, stackTrace: st);
    span.setStatus(SpanStatusCode.Error, e.toString());
    rethrow;
  } finally {
    span.end();
  }
}
