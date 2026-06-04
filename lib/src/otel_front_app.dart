// Licensed under the Dartastic Pro Software License Agreement.
// Copyright 2025-2026 Mindful Software LLC d/b/a Dartastic.io, All rights reserved.

import 'package:dartastic_opentelemetry/dartastic_opentelemetry.dart';

import 'otel_front_app_suppression.dart';

class FrontAppResult {
  const FrontAppResult({
    this.companyId,
    this.surface,
    this.inboxId,
    this.inboxName,
    this.channelId,
    this.channelType,
    this.conversationId,
    this.conversationStatus,
    this.conversationCategory,
    this.messageId,
    this.messageType,
    this.contactId,
    this.teammateId,
    this.tagsCount,
    this.attachmentsCount,
    this.draftId,
    this.ruleId,
    this.firstResponseTimeSeconds,
    this.resolutionTimeSeconds,
    this.statusCode,
    this.errorCode,
    this.errorMessage,
  });

  final String? companyId;
  final String? surface;
  final String? inboxId;
  final String? inboxName;
  final String? channelId;
  final String? channelType;
  final String? conversationId;
  final String? conversationStatus;
  final String? conversationCategory;
  final String? messageId;
  final String? messageType;
  final String? contactId;
  final String? teammateId;
  final int? tagsCount;
  final int? attachmentsCount;
  final String? draftId;
  final String? ruleId;
  final int? firstResponseTimeSeconds;
  final int? resolutionTimeSeconds;
  final int? statusCode;
  final String? errorCode;
  final String? errorMessage;
}

class FrontAppCallResult<T> {
  const FrontAppCallResult({required this.value, this.result});
  final T value;
  final FrontAppResult? result;
}

Future<T> tracedFrontApp<T>({
  required String operation,
  required Future<FrontAppCallResult<T>> Function() invoke,
  Tracer? tracer,
}) async {
  if (frontAppInstrumentationSuppressed()) {
    final r = await invoke();
    return r.value;
  }
  final t = tracer ?? OTel.tracerProvider().getTracer('otel_front_app');
  final span = t.startSpan('front $operation', kind: SpanKind.client);
  try {
    span.addAttributes(
        OTel.attributes([OTel.attributeString('rpc.system', 'front')]));
    span.addAttributes(
        OTel.attributes([OTel.attributeString('rpc.method', operation)]));
    final r = await invoke();
    final res = r.result;
    if (res != null) {
      if (res.companyId != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeString('front.company.id', res.companyId!)]));
      }
      if (res.surface != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeString('front.surface', res.surface!)]));
      }
      if (res.inboxId != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeString('front.inbox.id', res.inboxId!)]));
      }
      if (res.inboxName != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeString('front.inbox.name', res.inboxName!)]));
      }
      if (res.channelId != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeString('front.channel.id', res.channelId!)]));
      }
      if (res.channelType != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeString('front.channel.type', res.channelType!)]));
      }
      if (res.conversationId != null) {
        span.addAttributes(OTel.attributes([
          OTel.attributeString('front.conversation.id', res.conversationId!)
        ]));
      }
      if (res.conversationStatus != null) {
        span.addAttributes(OTel.attributes([
          OTel.attributeString(
              'front.conversation.status', res.conversationStatus!)
        ]));
      }
      if (res.conversationCategory != null) {
        span.addAttributes(OTel.attributes([
          OTel.attributeString(
              'front.conversation.category', res.conversationCategory!)
        ]));
      }
      if (res.messageId != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeString('front.message.id', res.messageId!)]));
      }
      if (res.messageType != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeString('front.message.type', res.messageType!)]));
      }
      if (res.contactId != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeString('front.contact.id', res.contactId!)]));
      }
      if (res.teammateId != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeString('front.teammate.id', res.teammateId!)]));
      }
      if (res.tagsCount != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeInt('front.tags.count', res.tagsCount!)]));
      }
      if (res.attachmentsCount != null) {
        span.addAttributes(OTel.attributes([
          OTel.attributeInt('front.attachments.count', res.attachmentsCount!)
        ]));
      }
      if (res.draftId != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeString('front.draft.id', res.draftId!)]));
      }
      if (res.ruleId != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeString('front.rule.id', res.ruleId!)]));
      }
      if (res.firstResponseTimeSeconds != null) {
        span.addAttributes(OTel.attributes([
          OTel.attributeInt('front.first_response_time_seconds',
              res.firstResponseTimeSeconds!)
        ]));
      }
      if (res.resolutionTimeSeconds != null) {
        span.addAttributes(OTel.attributes([
          OTel.attributeInt(
              'front.resolution_time_seconds', res.resolutionTimeSeconds!)
        ]));
      }
      if (res.statusCode != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeInt('http.response.status_code', res.statusCode!)]));
      }
      if (res.errorCode != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeString('front.error.code', res.errorCode!)]));
      }
      final fail = res.errorCode != null ||
          (res.statusCode != null && res.statusCode! >= 400);
      if (fail) {
        span.addAttributes(OTel.attributes([
          OTel.attributeString(
              ErrorResource.errorType.key, res.errorCode ?? 'front.error')
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
