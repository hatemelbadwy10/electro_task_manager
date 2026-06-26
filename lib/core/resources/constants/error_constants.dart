class ErrorConstants {
  static const String defaultError = 'Something went wrong. Please try again.';
  static const String noInternet = 'Could not connect to the API server.';
  static const String timeout = 'Connection timed out. Please try again.';
  static const String unauthorized =
      'Your session expired. Please login again.';
  static const String forbidden = 'You do not have permission for this action.';
  static const String notFound = 'The requested item was not found.';
  static const String validation = 'Please check the entered data.';
  static const String server = 'Server error. Please try again later.';
  static const String unknown = 'Unexpected error. Please try again.';
}

class ResponseCode {
  static const int success = 200;
  static const int created = 201;
  static const int noContent = 204;
  static const int badRequest = 400;
  static const int unauthorized = 401;
  static const int forbidden = 403;
  static const int notFound = 404;
  static const int validation = 422;
  static const int server = 500;
  static const int noInternet = -6;
  static const int timeout = -7;
  static const int unknown = -1;
}
