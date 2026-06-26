import 'dart:convert';
import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class LoggerInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.extra['start_time'] = DateTime.now().millisecondsSinceEpoch;

    if (kDebugMode) {
      final requestLog = StringBuffer()
        ..writeln(
          '============================================================',
        )
        ..writeln('[API REQUEST] ${options.method} ${options.uri}')
        ..writeln(
          '------------------------------------------------------------',
        );

      if (options.headers.isNotEmpty) {
        requestLog.writeln('Headers:');
        options.headers.forEach((key, value) {
          requestLog.writeln('  $key: ${_sanitizeHeader(key, value)}');
        });
      }

      if (options.queryParameters.isNotEmpty) {
        requestLog.writeln('Query:');
        options.queryParameters.forEach((key, value) {
          requestLog.writeln('  $key: $value');
        });
      }

      if (options.data != null) {
        requestLog
          ..writeln('Body:')
          ..writeln(_indent(_formatData(options.data)));
      }

      requestLog.writeln(
        '============================================================',
      );
      _log(requestLog.toString());
    }

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      final duration = _duration(response.requestOptions);
      final responseLog = StringBuffer()
        ..writeln(
          '============================================================',
        )
        ..writeln(
          '[API RESPONSE] ${response.requestOptions.method} '
          '${response.requestOptions.uri}',
        )
        ..writeln(
          '------------------------------------------------------------',
        )
        ..writeln(
          'Status: ${response.statusCode} ${response.statusMessage ?? ''}',
        )
        ..writeln('Duration: ${duration}ms');

      if (response.data != null) {
        responseLog
          ..writeln('Data:')
          ..writeln(_indent(_formatData(response.data)));
      }

      responseLog.writeln(
        '============================================================',
      );
      _log(responseLog.toString());
    }

    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      final duration = _duration(err.requestOptions);
      final errorLog = StringBuffer()
        ..writeln(
          '============================================================',
        )
        ..writeln(
          '[API ERROR] ${err.requestOptions.method} ${err.requestOptions.uri}',
        )
        ..writeln(
          '------------------------------------------------------------',
        )
        ..writeln('Duration: ${duration}ms')
        ..writeln('Type: ${err.type}')
        ..writeln('Status: ${err.response?.statusCode ?? 'N/A'}')
        ..writeln('Message: ${err.message}');

      if (err.response?.data != null) {
        errorLog
          ..writeln('Response:')
          ..writeln(_indent(_formatData(err.response!.data)));
      }

      errorLog.writeln(
        '============================================================',
      );
      _log(errorLog.toString(), isError: true);
    }

    handler.next(err);
  }

  int _duration(RequestOptions options) {
    final startTime = options.extra['start_time'];
    if (startTime is! int) return 0;
    return DateTime.now().millisecondsSinceEpoch - startTime;
  }

  String _formatData(dynamic data) {
    try {
      if (data is FormData) {
        final buffer = StringBuffer('FormData');
        for (final field in data.fields) {
          buffer.writeln('\n${field.key}: ${field.value}');
        }
        for (final file in data.files) {
          buffer.writeln('\n${file.key}: ${file.value.filename}');
        }
        return buffer.toString();
      }

      if (data is String) {
        try {
          return const JsonEncoder.withIndent('  ').convert(jsonDecode(data));
        } catch (_) {
          return data;
        }
      }

      return const JsonEncoder.withIndent('  ').convert(data);
    } catch (_) {
      return data.toString();
    }
  }

  String _indent(String value) {
    return value
        .split('\n')
        .map((line) => line.isEmpty ? line : '  $line')
        .join('\n');
  }

  String _sanitizeHeader(String key, dynamic value) {
    if (key.toLowerCase() == 'authorization') {
      final text = value.toString();
      if (text.length <= 18) return '***';
      return '${text.substring(0, 14)}...';
    }
    return value.toString();
  }

  void _log(String message, {bool isError = false}) {
    developer.log(
      message.trimRight(),
      name: 'HTTP_INTERCEPTOR',
      level: isError ? 1000 : 800,
    );
    debugPrint(message.trimRight());
  }
}
