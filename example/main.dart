// Licensed under the Apache License, Version 2.0
// Copyright 2025-2026 Mindful Software LLC d/b/a Dartastic.io, All rights reserved.

import 'package:dartastic_opentelemetry/dartastic_opentelemetry.dart';
import 'package:otel_aws_athena/otel_aws_athena.dart';

/// Traces Aws Athena calls with OpenTelemetry.
///
/// `otel_aws_athena` depends on the OpenTelemetry API only, so the application
/// initializes an SDK once at startup. Wrap each Aws Athena call in
/// [tracedAwsAthena]; the `invoke` callback makes the real call and reports what
/// came back, which is recorded on the span.
Future<void> main() async {
  await OTel.initialize(serviceName: 'aws-athena-example');

  // Traces a Aws Athena call.
  final awsAthenaId = await tracedAwsAthena<String>(
    operation: 'create',
    invoke: () async {
      // Make the Aws Athena call here, then report what it returned.
      const id = 'aws_athena_8f3a2c';
      return const AwsAthenaCallResult(
          value: id,
          result: AwsAthenaResult(
              region: 'us-east-1',
              account: 'example',
              workgroup: 'example',
              engineVersion: '1',
              queryExecutionId: 'queryexecution_8f3a2c',
              queryState: 'active',
              statementType: 'active',
              dataCatalog: 'example',
              database: 'example',
              outputLocation: 'example',
              dataScannedBytes: 512,
              engineExecutionTimeMs: 120,
              queryQueueTimeMs: 120,
              totalExecutionTimeMs: 120,
              rowsReturned: 1,
              resultSetSizeBytes: 512,
              outputType: 'standard',
              statusCode: 201,
              errorCode: 'example',
              errorMessage: 'example'));
    },
  );
  OTelLog.info('tracedAwsAthena create returned $awsAthenaId');

  // Calls that should not be traced, such as health checks, run inside
  // runWithoutAwsAthenaInstrumentationAsync.
  await runWithoutAwsAthenaInstrumentationAsync(
    () => tracedAwsAthena<String>(
      operation: 'create',
      invoke: () async {
        const id = 'aws_athena_8f3a2c';
        return const AwsAthenaCallResult(
            value: id,
            result: AwsAthenaResult(
                region: 'us-east-1',
                account: 'example',
                workgroup: 'example',
                engineVersion: '1',
                queryExecutionId: 'queryexecution_8f3a2c',
                queryState: 'active',
                statementType: 'active',
                dataCatalog: 'example',
                database: 'example',
                outputLocation: 'example',
                dataScannedBytes: 512,
                engineExecutionTimeMs: 120,
                queryQueueTimeMs: 120,
                totalExecutionTimeMs: 120,
                rowsReturned: 1,
                resultSetSizeBytes: 512,
                outputType: 'standard',
                statusCode: 201,
                errorCode: 'example',
                errorMessage: 'example'));
      },
    ),
  );

  await OTel.shutdown();
}
