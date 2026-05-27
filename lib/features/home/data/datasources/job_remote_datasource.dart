import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../../domain/entities/job.dart';

class JobRemoteDataSource {
  final Dio _dio = DioClient.instance.dio;

  Future<PageResult<Job>> getRecommendedJobs({int page = 1, int size = 20}) async {
    final response = await _dio.get(
      ApiConstants.jobsRecommended,
      queryParameters: {'page': page, 'size': size},
    );
    return PageResult.fromJson(response.data['data'], Job.fromJson);
  }

  Future<PageResult<Job>> getLatestJobs({int page = 1, int size = 20}) async {
    final response = await _dio.get(
      ApiConstants.jobsLatest,
      queryParameters: {'page': page, 'size': size},
    );
    return PageResult.fromJson(response.data['data'], Job.fromJson);
  }

  Future<PageResult<Job>> getNearbyJobs({String? city, int page = 1, int size = 20}) async {
    final response = await _dio.get(
      ApiConstants.jobsNearby,
      queryParameters: {'city': city, 'page': page, 'size': size},
    );
    return PageResult.fromJson(response.data['data'], Job.fromJson);
  }

  Future<Job> getJobDetail(int id) async {
    final response = await _dio.get(ApiConstants.jobDetail(id));
    return Job.fromJson(response.data['data']);
  }
}
