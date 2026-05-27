import 'package:dio/dio.dart';
import '../storage/local_storage.dart';

class AuthInterceptor extends QueuedInterceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await LocalStorage.getAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      final refreshToken = await LocalStorage.getRefreshToken();
      if (refreshToken != null) {
        try {
          final dio = Dio(BaseOptions(baseUrl: err.requestOptions.baseUrl));
          final response = await dio.post(
            '/api/v1/auth/refresh',
            data: {'refreshToken': refreshToken},
          );

          if (response.statusCode == 200 && response.data['code'] == 200) {
            final data = response.data['data'];
            await LocalStorage.setTokens(
              data['accessToken'],
              data['refreshToken'],
            );

            err.requestOptions.headers['Authorization'] =
                'Bearer ${data['accessToken']}';
            final retryResponse = await dio.fetch(err.requestOptions);
            return handler.resolve(retryResponse);
          }
        } catch (_) {
          await LocalStorage.clearTokens();
        }
      }
    }
    handler.next(err);
  }
}
