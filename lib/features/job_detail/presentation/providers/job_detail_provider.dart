import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../home/domain/entities/job.dart';
import '../../../home/domain/repositories/job_repository.dart';
import '../../../home/data/repositories/job_repository_impl.dart';

final jobDetailProvider = FutureProvider.family<Job, int>(
  (ref, jobId) async {
    final repository = JobRepositoryImpl();
    return repository.getJobDetail(jobId);
  },
);
