import 'package:dio/dio.dart';
import '../constants/api_constants.dart';
import 'api_interceptor.dart';

class DioClient {
  static DioClient? _instance;
  late final Dio dio;

  DioClient._() {
    dio = Dio(BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));
    dio.interceptors.add(AuthInterceptor());
  }

  static DioClient get instance {
    _instance ??= DioClient._();
    return _instance!;
  }

  static void updateBaseUrl(String baseUrl) {
    _instance?.dio.options.baseUrl = baseUrl;
  }
}
