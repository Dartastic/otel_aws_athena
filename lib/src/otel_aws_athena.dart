// Licensed under the Apache License, Version 2.0
// Copyright 2025-2026 Mindful Software LLC d/b/a Dartastic.io, All rights reserved.

import 'package:dartastic_opentelemetry_api/dartastic_opentelemetry_api.dart';

import 'otel_aws_athena_suppression.dart';

class AwsAthenaResult {
  /// Creates a result.
  const AwsAthenaResult({
    this.region,
    this.account,
    this.workgroup,
    this.engineVersion,
    this.queryExecutionId,
    this.queryState,
    this.statementType,
    this.dataCatalog,
    this.database,
    this.outputLocation,
    this.dataScannedBytes,
    this.engineExecutionTimeMs,
    this.queryQueueTimeMs,
    this.totalExecutionTimeMs,
    this.rowsReturned,
    this.resultSetSizeBytes,
    this.outputType,
    this.statusCode,
    this.errorCode,
    this.errorMessage,
  });

  final String? region;
  final String? account;
  final String? workgroup;
  final String? engineVersion;
  final String? queryExecutionId;
  final String? queryState;
  final String? statementType;
  final String? dataCatalog;
  final String? database;
  final String? outputLocation;
  final int? dataScannedBytes;
  final int? engineExecutionTimeMs;
  final int? queryQueueTimeMs;
  final int? totalExecutionTimeMs;
  final int? rowsReturned;
  final int? resultSetSizeBytes;
  final String? outputType;
  final int? statusCode;
  final String? errorCode;
  final String? errorMessage;
}

/// What a traced call returned: the value for the caller plus fields
/// recorded on the span.
class AwsAthenaCallResult<T> {
  /// Creates a call result.
  const AwsAthenaCallResult({required this.value, this.result});

  /// The value returned to the caller.
  final T value;
  final AwsAthenaResult? result;
}

Future<T> tracedAwsAthena<T>({
  required String operation,
  required Future<AwsAthenaCallResult<T>> Function() invoke,
  APITracer? tracer,
}) async {
  if (awsAthenaInstrumentationSuppressed()) {
    final r = await invoke();
    return r.value;
  }
  final t = tracer ?? OTelAPI.tracerProvider().getTracer('otel_aws_athena');
  final span = t.startSpan('aws_athena $operation', kind: SpanKind.client);
  try {
    span.addAttributes(
        OTelAPI.attributes([OTelAPI.attributeString('rpc.system', 'aws-api')]));
    span.addAttributes(
        OTelAPI.attributes([OTelAPI.attributeString('rpc.service', 'Athena')]));
    span.addAttributes(
        OTelAPI.attributes([OTelAPI.attributeString('rpc.method', operation)]));
    span.addAttributes(
        OTelAPI.attributes([OTelAPI.attributeString('db.system', 'athena')]));
    final r = await invoke();
    final res = r.result;
    if (res != null) {
      if (res.region != null) {
        span.addAttributes(OTelAPI.attributes(
            [OTelAPI.attributeString('aws.region', res.region!)]));
      }
      if (res.account != null) {
        span.addAttributes(OTelAPI.attributes(
            [OTelAPI.attributeString('aws.account.id', res.account!)]));
      }
      if (res.workgroup != null) {
        span.addAttributes(OTelAPI.attributes(
            [OTelAPI.attributeString('aws.athena.workgroup', res.workgroup!)]));
      }
      if (res.engineVersion != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeString(
              'aws.athena.engine_version', res.engineVersion!)
        ]));
      }
      if (res.queryExecutionId != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeString(
              'aws.athena.query.execution_id', res.queryExecutionId!)
        ]));
      }
      if (res.queryState != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeString('aws.athena.query.state', res.queryState!)
        ]));
      }
      if (res.statementType != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeString(
              'aws.athena.statement.type', res.statementType!)
        ]));
      }
      if (res.dataCatalog != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeString('aws.athena.data_catalog', res.dataCatalog!)
        ]));
      }
      if (res.database != null) {
        span.addAttributes(OTelAPI.attributes(
            [OTelAPI.attributeString('db.name', res.database!)]));
      }
      if (res.outputLocation != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeString(
              'aws.athena.output_location', res.outputLocation!)
        ]));
      }
      if (res.dataScannedBytes != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeInt(
              'aws.athena.data_scanned_bytes', res.dataScannedBytes!)
        ]));
      }
      if (res.engineExecutionTimeMs != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeInt(
              'aws.athena.engine_execution_time_ms', res.engineExecutionTimeMs!)
        ]));
      }
      if (res.queryQueueTimeMs != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeInt(
              'aws.athena.query_queue_time_ms', res.queryQueueTimeMs!)
        ]));
      }
      if (res.totalExecutionTimeMs != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeInt(
              'aws.athena.total_execution_time_ms', res.totalExecutionTimeMs!)
        ]));
      }
      if (res.rowsReturned != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeInt('aws.athena.rows_returned', res.rowsReturned!)
        ]));
      }
      if (res.resultSetSizeBytes != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeInt(
              'aws.athena.result_set_size_bytes', res.resultSetSizeBytes!)
        ]));
      }
      if (res.outputType != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeString('aws.athena.output.type', res.outputType!)
        ]));
      }
      if (res.statusCode != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeInt('http.response.status_code', res.statusCode!)
        ]));
      }
      if (res.errorCode != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeString('aws.athena.error.code', res.errorCode!)
        ]));
      }
      final fail = res.errorCode != null ||
          (res.statusCode != null && res.statusCode! >= 400) ||
          res.queryState == 'FAILED' ||
          res.queryState == 'CANCELLED';
      if (fail) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeString(ErrorAttributes.errorType.key,
              res.errorCode ?? 'aws_athena.error')
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
