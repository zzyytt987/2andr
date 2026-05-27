import '../../../home/domain/entities/job.dart';

abstract class SearchRepository {
  Future<PageResult<Job>> searchJobs({
    String? keyword,
    String? city,
    String? salary,
    String? education,
    String? experience,
    String? companySize,
    int page = 1,
    int size = 20,
  });
  Future<List<String>> getHotSearches();
  Future<List<String>> getSearchHistory();
  Future<void> clearSearchHistory();
}
