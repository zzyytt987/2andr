import '../../domain/entities/job.dart';

abstract class JobRepository {
  Future<PageResult<Job>> getRecommendedJobs({int page = 1, int size = 20});
  Future<PageResult<Job>> getLatestJobs({int page = 1, int size = 20});
  Future<PageResult<Job>> getNearbyJobs({String? city, int page = 1, int size = 20});
  Future<Job> getJobDetail(int id);
}
