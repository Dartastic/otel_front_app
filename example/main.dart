// Licensed under the Apache License, Version 2.0
// Copyright 2025-2026 Mindful Software LLC d/b/a Dartastic.io, All rights reserved.

import 'package:dartastic_opentelemetry/dartastic_opentelemetry.dart';
import 'package:otel_front_app/otel_front_app.dart';

/// Traces Front App calls with OpenTelemetry.
///
/// `otel_front_app` depends on the OpenTelemetry API only, so the application
/// initializes an SDK once at startup. Wrap each Front App call in
/// [tracedFrontApp]; the `invoke` callback makes the real call and reports what
/// came back, which is recorded on the span.
Future<void> main() async {
  await OTel.initialize(serviceName: 'front-app-example');

  // Traces a Front App call.
  final frontAppId = await tracedFrontApp<String>(
    operation: 'create',
    invoke: () async {
      // Make the Front App call here, then report what it returned.
      const id = 'front_app_8f3a2c';
      return const FrontAppCallResult(
          value: id,
          result: FrontAppResult(
              companyId: 'company_8f3a2c',
              surface: 'example',
              inboxId: 'inbox_8f3a2c',
              inboxName: 'example',
              channelId: 'channel_8f3a2c',
              channelType: 'orders',
              conversationId: 'conversation_8f3a2c',
              conversationStatus: 'succeeded',
              conversationCategory: 'example',
              messageId: 'message_8f3a2c',
              messageType: 'standard',
              contactId: 'contact_8f3a2c',
              teammateId: 'teammate_8f3a2c',
              tagsCount: 3,
              attachmentsCount: 3,
              draftId: 'draft_8f3a2c',
              ruleId: 'rule_8f3a2c',
              firstResponseTimeSeconds: 1,
              resolutionTimeSeconds: 1,
              statusCode: 201,
              errorCode: 'example',
              errorMessage: 'example'));
    },
  );
  OTelLog.info('tracedFrontApp create returned $frontAppId');

  // Calls that should not be traced, such as health checks, run inside
  // runWithoutFrontAppInstrumentationAsync.
  await runWithoutFrontAppInstrumentationAsync(
    () => tracedFrontApp<String>(
      operation: 'create',
      invoke: () async {
        const id = 'front_app_8f3a2c';
        return const FrontAppCallResult(
            value: id,
            result: FrontAppResult(
                companyId: 'company_8f3a2c',
                surface: 'example',
                inboxId: 'inbox_8f3a2c',
                inboxName: 'example',
                channelId: 'channel_8f3a2c',
                channelType: 'orders',
                conversationId: 'conversation_8f3a2c',
                conversationStatus: 'succeeded',
                conversationCategory: 'example',
                messageId: 'message_8f3a2c',
                messageType: 'standard',
                contactId: 'contact_8f3a2c',
                teammateId: 'teammate_8f3a2c',
                tagsCount: 3,
                attachmentsCount: 3,
                draftId: 'draft_8f3a2c',
                ruleId: 'rule_8f3a2c',
                firstResponseTimeSeconds: 1,
                resolutionTimeSeconds: 1,
                statusCode: 201,
                errorCode: 'example',
                errorMessage: 'example'));
      },
    ),
  );

  await OTel.shutdown();
}
