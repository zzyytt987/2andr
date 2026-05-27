import '../../domain/entities/job.dart';
import '../../domain/repositories/job_repository.dart';
import '../datasources/job_remote_datasource.dart';

class JobRepositoryImpl implements JobRepository {
  final JobRemoteDataSource _remote = JobRemoteDataSource();

  @override
  Future<PageResult<Job>> getRecommendedJobs({int page = 1, int size = 20}) {
    return _remote.getRecommendedJobs(page: page, size: size);
  }

  @override
  Future<PageResult<Job>> getLatestJobs({int page = 1, int size = 20}) {
    return _remote.getLatestJobs(page: page, size: size);
  }

  @override
  Future<PageResult<Job>> getNearbyJobs({String? city, int page = 1, int size = 20}) {
    return _remote.getNearbyJobs(city: city, page: page, size: size);
  }

  @override
  Future<Job> getJobDetail(int id) {
    return _remote.getJobDetail(id);
  }
}
