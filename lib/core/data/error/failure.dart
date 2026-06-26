import 'package:equatable/equatable.dart';

import '../../resources/constants/error_constants.dart';

abstract class Failure extends Equatable {
  final String message;
  final int statusCode;
  final String? details;

  const Failure({
    required this.message,
    this.statusCode = ResponseCode.unknown,
    this.details,
  });

  @override
  List<Object?> get props => [message, statusCode, details];
}

class ServerFailure extends Failure {
  const ServerFailure({
    required super.message,
    super.statusCode,
    super.details,
  });
}

class NetworkFailure extends Failure {
  const NetworkFailure({required super.message, super.details})
    : super(statusCode: ResponseCode.noInternet);
}

class TimeoutFailure extends Failure {
  const TimeoutFailure({required super.message, super.details})
    : super(statusCode: ResponseCode.timeout);
}

class ValidationFailure extends Failure {
  const ValidationFailure({required super.message, super.details})
    : super(statusCode: ResponseCode.validation);
}

class UnauthenticatedFailure extends Failure {
  const UnauthenticatedFailure({required super.message, super.details})
    : super(statusCode: ResponseCode.unauthorized);
}

class UnknownFailure extends Failure {
  const UnknownFailure({required super.message, super.details})
    : super(statusCode: ResponseCode.unknown);
}
