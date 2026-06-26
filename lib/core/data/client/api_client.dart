import 'package:dio/dio.dart';

import '../../resources/constants/remote_urls.dart';
import '../error/app_exception.dart';
import '../error/error_handler.dart';
import '../storage/token_storage.dart';
import 'logger_interceptor.dart';

class ApiClient {
  final Dio dio;
  final TokenStorage tokenStorage;

  ApiClient({required this.dio, required this.tokenStorage}) {
    dio.options = BaseOptions(
      baseUrl: RemoteUrls.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: const {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );

    dio.interceptors
      ..add(
        InterceptorsWrapper(
          onRequest: (options, handler) async {
            final token = await tokenStorage.readToken();
            if (token != null && token.isNotEmpty) {
              options.headers['Authorization'] = 'Bearer $token';
            }
            handler.next(options);
          },
        ),
      )
      ..add(LoggerInterceptor());
  }

  Future<Response<dynamic>> get(String path) => _run(() => dio.get(path));

  Future<Response<dynamic>> post(String path, {Map<String, dynamic>? data}) {
    return _run(() => dio.post(path, data: data));
  }

  Future<Response<dynamic>> patch(String path, {Map<String, dynamic>? data}) {
    return _run(() => dio.patch(path, data: data));
  }

  Future<Response<dynamic>> delete(String path) {
    return _run(() => dio.delete(path));
  }

  Future<Response<dynamic>> _run(
    Future<Response<dynamic>> Function() request,
  ) async {
    try {
      return await request();
    } catch (error) {
      throw AppException(ErrorHandler.handle(error).failure);
    }
  }
}
