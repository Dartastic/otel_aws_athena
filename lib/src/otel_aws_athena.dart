// Licensed under the Dartastic Pro Software License Agreement.
// Copyright 2025-2026 Mindful Software LLC d/b/a Dartastic.io, All rights reserved.

import 'package:dartastic_opentelemetry/dartastic_opentelemetry.dart';

import 'otel_aws_athena_suppression.dart';

class AwsAthenaResult {
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

class AwsAthenaCallResult<T> {
  const AwsAthenaCallResult({required this.value, this.result});
  final T value;
  final AwsAthenaResult? result;
}

Future<T> tracedAwsAthena<T>({
  required String operation,
  required Future<AwsAthenaCallResult<T>> Function() invoke,
  Tracer? tracer,
}) async {
  if (awsAthenaInstrumentationSuppressed()) {
    final r = await invoke();
    return r.value;
  }
  final t = tracer ?? OTel.tracerProvider().getTracer('otel_aws_athena');
  final span = t.startSpan('aws_athena $operation', kind: SpanKind.client);
  try {
    span.addAttributes(
        OTel.attributes([OTel.attributeString('rpc.system', 'aws-api')]));
    span.addAttributes(
        OTel.attributes([OTel.attributeString('rpc.service', 'Athena')]));
    span.addAttributes(
        OTel.attributes([OTel.attributeString('rpc.method', operation)]));
    span.addAttributes(
        OTel.attributes([OTel.attributeString('db.system', 'athena')]));
    final r = await invoke();
    final res = r.result;
    if (res != null) {
      if (res.region != null) {
        span.addAttributes(
            OTel.attributes([OTel.attributeString('aws.region', res.region!)]));
      }
      if (res.account != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeString('aws.account.id', res.account!)]));
      }
      if (res.workgroup != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeString('aws.athena.workgroup', res.workgroup!)]));
      }
      if (res.engineVersion != null) {
        span.addAttributes(OTel.attributes([
          OTel.attributeString('aws.athena.engine_version', res.engineVersion!)
        ]));
      }
      if (res.queryExecutionId != null) {
        span.addAttributes(OTel.attributes([
          OTel.attributeString(
              'aws.athena.query.execution_id', res.queryExecutionId!)
        ]));
      }
      if (res.queryState != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeString('aws.athena.query.state', res.queryState!)]));
      }
      if (res.statementType != null) {
        span.addAttributes(OTel.attributes([
          OTel.attributeString('aws.athena.statement.type', res.statementType!)
        ]));
      }
      if (res.dataCatalog != null) {
        span.addAttributes(OTel.attributes([
          OTel.attributeString('aws.athena.data_catalog', res.dataCatalog!)
        ]));
      }
      if (res.database != null) {
        span.addAttributes(
            OTel.attributes([OTel.attributeString('db.name', res.database!)]));
      }
      if (res.outputLocation != null) {
        span.addAttributes(OTel.attributes([
          OTel.attributeString(
              'aws.athena.output_location', res.outputLocation!)
        ]));
      }
      if (res.dataScannedBytes != null) {
        span.addAttributes(OTel.attributes([
          OTel.attributeInt(
              'aws.athena.data_scanned_bytes', res.dataScannedBytes!)
        ]));
      }
      if (res.engineExecutionTimeMs != null) {
        span.addAttributes(OTel.attributes([
          OTel.attributeInt(
              'aws.athena.engine_execution_time_ms', res.engineExecutionTimeMs!)
        ]));
      }
      if (res.queryQueueTimeMs != null) {
        span.addAttributes(OTel.attributes([
          OTel.attributeInt(
              'aws.athena.query_queue_time_ms', res.queryQueueTimeMs!)
        ]));
      }
      if (res.totalExecutionTimeMs != null) {
        span.addAttributes(OTel.attributes([
          OTel.attributeInt(
              'aws.athena.total_execution_time_ms', res.totalExecutionTimeMs!)
        ]));
      }
      if (res.rowsReturned != null) {
        span.addAttributes(OTel.attributes([
          OTel.attributeInt('aws.athena.rows_returned', res.rowsReturned!)
        ]));
      }
      if (res.resultSetSizeBytes != null) {
        span.addAttributes(OTel.attributes([
          OTel.attributeInt(
              'aws.athena.result_set_size_bytes', res.resultSetSizeBytes!)
        ]));
      }
      if (res.outputType != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeString('aws.athena.output.type', res.outputType!)]));
      }
      if (res.statusCode != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeInt('http.response.status_code', res.statusCode!)]));
      }
      if (res.errorCode != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeString('aws.athena.error.code', res.errorCode!)]));
      }
      final fail = res.errorCode != null ||
          (res.statusCode != null && res.statusCode! >= 400) ||
          res.queryState == 'FAILED' ||
          res.queryState == 'CANCELLED';
      if (fail) {
        span.addAttributes(OTel.attributes([
          OTel.attributeString(
              ErrorResource.errorType.key, res.errorCode ?? 'aws_athena.error')
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
