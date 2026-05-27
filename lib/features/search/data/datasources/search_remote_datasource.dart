import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../../../home/domain/entities/job.dart';

class SearchRemoteDataSource {
  final Dio _dio = DioClient.instance.dio;

  Future<PageResult<Job>> searchJobs({
    String? keyword,
    String? city,
    String? salary,
    String? education,
    String? experience,
    String? companySize,
    int page = 1,
    int size = 20,
  }) async {
    final params = <String, dynamic>{'page': page, 'size': size};
    if (keyword != null && keyword.isNotEmpty) params['keyword'] = keyword;
    if (city != null && city.isNotEmpty) params['city'] = city;
    if (salary != null && salary.isNotEmpty) params['salary'] = salary;
    if (education != null && education.isNotEmpty) params['education'] = education;
    if (experience != null && experience.isNotEmpty) params['experience'] = experience;
    if (companySize != null && companySize.isNotEmpty) params['companySize'] = companySize;

    final response = await _dio.get(ApiConstants.jobsSearch, queryParameters: params);
    return PageResult.fromJson(response.data['data'], Job.fromJson);
  }

  Future<List<String>> getHotSearches() async {
    final response = await _dio.get(ApiConstants.searchHot);
    return (response.data['data'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        [];
  }

  Future<List<String>> getSearchHistory() async {
    final response = await _dio.get(ApiConstants.searchHistory);
    return (response.data['data'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        [];
  }

  Future<void> clearSearchHistory() async {
    await _dio.delete(ApiConstants.searchHistory);
  }
}
