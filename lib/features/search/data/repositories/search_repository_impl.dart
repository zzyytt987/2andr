import '../../../home/domain/entities/job.dart';
import '../../domain/repositories/search_repository.dart';
import '../datasources/search_remote_datasource.dart';

class SearchRepositoryImpl implements SearchRepository {
  final SearchRemoteDataSource _remote = SearchRemoteDataSource();

  @override
  Future<PageResult<Job>> searchJobs({
    String? keyword,
    String? city,
    String? salary,
    String? education,
    String? experience,
    String? companySize,
    int page = 1,
    int size = 20,
  }) {
    return _remote.searchJobs(
      keyword: keyword,
      city: city,
      salary: salary,
      education: education,
      experience: experience,
      companySize: companySize,
      page: page,
      size: size,
    );
  }

  @override
  Future<List<String>> getHotSearches() => _remote.getHotSearches();

  @override
  Future<List<String>> getSearchHistory() => _remote.getSearchHistory();

  @override
  Future<void> clearSearchHistory() => _remote.clearSearchHistory();
}
