import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../resources/constants/error_constants.dart';
import 'failure.dart';

class ErrorHandler implements Exception {
  final Failure failure;

  ErrorHandler.handle(Object error) : failure = _mapError(error) {
    if (kDebugMode) {
      debugPrint('[ErrorHandler] ${failure.message}');
    }
  }

  static Failure _mapError(Object error) {
    if (error is DioException) return _mapDio(error);
    if (error is SocketException) {
      return NetworkFailure(
        message: ErrorConstants.noInternet,
        details: error.message,
      );
    }
    if (error is FormatException) {
      return ValidationFailure(
        message: ErrorConstants.validation,
        details: error.message,
      );
    }
    return UnknownFailure(
      message: ErrorConstants.unknown,
      details: error.toString(),
    );
  }

  static Failure _mapDio(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutFailure(
          message: ErrorConstants.timeout,
          details: error.message,
        );
      case DioExceptionType.connectionError:
        return NetworkFailure(
          message: ErrorConstants.noInternet,
          details: error.message,
        );
      case DioExceptionType.badResponse:
        return _mapResponse(error.response);
      case DioExceptionType.cancel:
      case DioExceptionType.badCertificate:
      case DioExceptionType.unknown:
        return UnknownFailure(
          message: ErrorConstants.defaultError,
          details: error.message,
        );
    }
  }

  static Failure _mapResponse(Response<dynamic>? response) {
    final statusCode = response?.statusCode ?? ResponseCode.unknown;
    final message = _extractMessage(response?.data);

    if (statusCode == ResponseCode.unauthorized) {
      return UnauthenticatedFailure(
        message: message ?? ErrorConstants.unauthorized,
        details: response?.data?.toString(),
      );
    }
    if (statusCode == ResponseCode.forbidden) {
      return ServerFailure(
        message: message ?? ErrorConstants.forbidden,
        statusCode: statusCode,
        details: response?.data?.toString(),
      );
    }
    if (statusCode == ResponseCode.notFound) {
      return ServerFailure(
        message: message ?? ErrorConstants.notFound,
        statusCode: statusCode,
        details: response?.data?.toString(),
      );
    }
    if (statusCode == ResponseCode.validation ||
        statusCode == ResponseCode.badRequest) {
      return ValidationFailure(
        message: message ?? ErrorConstants.validation,
        details: response?.data?.toString(),
      );
    }
    if (statusCode >= ResponseCode.server) {
      return ServerFailure(
        message: message ?? ErrorConstants.server,
        statusCode: statusCode,
        details: response?.data?.toString(),
      );
    }
    return UnknownFailure(
      message: message ?? ErrorConstants.unknown,
      details: response?.data?.toString(),
    );
  }

  static String? _extractMessage(dynamic data) {
    if (data is Map) {
      final fieldError = _extractFirstFieldError(data['errors']);
      if (fieldError != null) return fieldError;
      if (data['message'] is String) return data['message'] as String;
      if (data['error'] is String) return data['error'] as String;
    }
    return null;
  }

  static String? _extractFirstFieldError(dynamic errors) {
    if (errors is! Map || errors.isEmpty) return null;
    final firstValue = errors.values.first;
    if (firstValue is String) return firstValue;
    if (firstValue is List && firstValue.isNotEmpty) {
      return firstValue.first.toString();
    }
    return null;
  }
}
