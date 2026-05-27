import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../../../home/domain/entities/job.dart';
import '../../domain/entities/application.dart';

class ApplicationRemoteDataSource {
  final Dio _dio = DioClient.instance.dio;

  Future<PageResult<JobApplication>> getApplications({int page = 1, int size = 20}) async {
    final response = await _dio.get(
      ApiConstants.applications,
      queryParameters: {'page': page, 'size': size},
    );
    return PageResult.fromJson(response.data['data'], JobApplication.fromJson);
  }

  Future<ApplicationStats> getStats() async {
    final response = await _dio.get(ApiConstants.applicationsStats);
    return ApplicationStats.fromJson(response.data['data']);
  }

  Future<void> apply(int jobId) async {
    await _dio.post(ApiConstants.applications, data: {'jobId': jobId});
  }
}
