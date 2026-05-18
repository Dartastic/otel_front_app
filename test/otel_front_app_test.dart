// Licensed under the Dartastic Pro Software License Agreement.
// Copyright 2025-2026 Mindful Software LLC d/b/a Dartastic.io, All rights reserved.

import 'package:dartastic_opentelemetry/dartastic_opentelemetry.dart';
import 'package:dartastic_opentelemetry/testing.dart';
import 'package:otel_front_app/otel_front_app.dart';
import 'package:test/test.dart';

void main() {
  late TestHarness harness;
  late InMemorySpanExporter spans;

  setUpAll(() async {
    harness = await maybeInitializeOtelForTest(
      serviceName: 'otel_front_app-test',
    );
    spans = harness.spans;
  });

  setUp(() => harness.clear());

  Map<String, Object> attrsOf(Span s) =>
      {for (final a in s.attributes.toList()) a.key: a.value};

  test('conversations.create records inbox + channel', () async {
    await tracedFrontApp<String>(
      operation: 'conversations.create',
      invoke: () async => const FrontAppCallResult(
        value: 'ok',
        result: FrontAppResult(
          inboxName: 'Support',
          channelType: 'email',
          conversationStatus: 'unassigned',
        ),
      ),
    );
    final a = attrsOf(spans.findSpanByName('front conversations.create')!);
    expect(a['front.inbox.name'], 'Support');
    expect(a['front.channel.type'], 'email');
  });

  test('analytics records first response + resolution', () async {
    await tracedFrontApp<String>(
      operation: 'analytics.metrics',
      invoke: () async => const FrontAppCallResult(
        value: 'ok',
        result: FrontAppResult(
          firstResponseTimeSeconds: 120,
          resolutionTimeSeconds: 1800,
        ),
      ),
    );
    final a = attrsOf(spans.findSpanByName('front analytics.metrics')!);
    expect(a['front.first_response_time_seconds'], 120);
    expect(a['front.resolution_time_seconds'], 1800);
  });

  test('error sets span error', () async {
    await tracedFrontApp<String>(
      operation: 'conversations.get',
      invoke: () async => const FrontAppCallResult(
        value: 'ok',
        result: FrontAppResult(
          errorCode: 'not_found',
          statusCode: 404,
        ),
      ),
    );
    expect(
      spans.findSpanByName('front conversations.get')!.status,
      SpanStatusCode.Error,
    );
  });

  test('suppression skips spans', () async {
    await runWithoutFrontAppInstrumentationAsync(() async {
      await tracedFrontApp<String>(
        operation: 'contacts.list',
        invoke: () async => const FrontAppCallResult(value: 'v'),
      );
    });
    expect(spans.findSpansStartingWith('front '), isEmpty);
  });
}
