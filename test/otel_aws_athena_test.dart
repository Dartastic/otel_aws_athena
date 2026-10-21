// Licensed under the Apache License, Version 2.0
// Copyright 2025-2026 Mindful Software LLC d/b/a Dartastic.io, All rights reserved.

import 'package:dartastic_opentelemetry/dartastic_opentelemetry.dart';
import 'package:dartastic_opentelemetry/testing.dart';
import 'package:otel_aws_athena/otel_aws_athena.dart';
import 'package:test/test.dart';

void main() {
  late TestHarness harness;
  late InMemorySpanExporter spans;

  setUpAll(() async {
    harness = await maybeInitializeOtelForTest(
      serviceName: 'otel_aws_athena-test',
    );
    spans = harness.spans;
  });

  setUp(() => harness.clear());

  Map<String, Object> attrsOf(Span s) =>
      {for (final a in s.attributes.toList()) a.key: a.value};

  test('StartQueryExecution records workgroup + scanned bytes', () async {
    await tracedAwsAthena<String>(
      operation: 'StartQueryExecution',
      invoke: () async => const AwsAthenaCallResult(
        value: 'ok',
        result: AwsAthenaResult(
          workgroup: 'primary',
          engineVersion: 'Athena engine version 3',
          statementType: 'DML',
          dataScannedBytes: 1073741824,
          engineExecutionTimeMs: 2400,
          rowsReturned: 250,
        ),
      ),
    );
    final a = attrsOf(spans.findSpanByName('aws_athena StartQueryExecution')!);
    expect(a['aws.athena.workgroup'], 'primary');
    expect(a['aws.athena.data_scanned_bytes'], 1073741824);
    expect(a['aws.athena.statement.type'], 'DML');
  });

  test('FAILED query sets span error', () async {
    await tracedAwsAthena<String>(
      operation: 'GetQueryExecution',
      invoke: () async => const AwsAthenaCallResult(
        value: 'ok',
        result: AwsAthenaResult(
          queryState: 'FAILED',
        ),
      ),
    );
    expect(
      spans.findSpanByName('aws_athena GetQueryExecution')!.status,
      SpanStatusCode.Error,
    );
  });

  test('CANCELLED query sets span error', () async {
    await tracedAwsAthena<String>(
      operation: 'GetQueryExecution',
      invoke: () async => const AwsAthenaCallResult(
        value: 'ok',
        result: AwsAthenaResult(
          queryState: 'CANCELLED',
        ),
      ),
    );
    expect(
      spans.findSpanByName('aws_athena GetQueryExecution')!.status,
      SpanStatusCode.Error,
    );
  });

  test('suppression skips spans', () async {
    await runWithoutAwsAthenaInstrumentationAsync(() async {
      await tracedAwsAthena<String>(
        operation: 'ListWorkGroups',
        invoke: () async => const AwsAthenaCallResult(value: 'v'),
      );
    });
    expect(spans.findSpansStartingWith('aws_athena '), isEmpty);
  });
}
