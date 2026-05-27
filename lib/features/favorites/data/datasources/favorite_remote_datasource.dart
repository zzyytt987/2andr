import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../../../home/domain/entities/job.dart';

class FavoriteRemoteDataSource {
  final Dio _dio = DioClient.instance.dio;

  Future<PageResult<Job>> getFavorites({int page = 1, int size = 20}) async {
    final response = await _dio.get(
      ApiConstants.favorites,
      queryParameters: {'page': page, 'size': size},
    );
    return PageResult.fromJson(response.data['data'], Job.fromJson);
  }

  Future<Map<String, dynamic>> toggleFavorite(int jobId) async {
    final response = await _dio.post(ApiConstants.favorites, data: {'jobId': jobId});
    return response.data['data'];
  }

  Future<void> removeFavorite(int jobId) async {
    await _dio.delete('${ApiConstants.favorites}/$jobId');
  }

  Future<bool> checkFavorited(int jobId) async {
    final response = await _dio.get('${ApiConstants.favoritesCheck}/$jobId');
    return response.data['data']['favorited'] ?? false;
  }
}
