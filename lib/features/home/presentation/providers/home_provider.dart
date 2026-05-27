import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/job.dart';
import '../../domain/repositories/job_repository.dart';
import '../../data/repositories/job_repository_impl.dart';

enum HomeTab { recommended, latest, nearby }

final jobRepositoryProvider = Provider<JobRepository>((ref) => JobRepositoryImpl());

final homeTabProvider = StateProvider<HomeTab>((ref) => HomeTab.recommended);

final homeJobsProvider = StateNotifierProvider.family<HomeJobsNotifier, AsyncValue<List<Job>>, HomeTab>(
  (ref, tab) => HomeJobsNotifier(ref.read(jobRepositoryProvider), tab),
);

class HomeJobsNotifier extends StateNotifier<AsyncValue<List<Job>>> {
  final JobRepository _repository;
  final HomeTab _tab;
  int _currentPage = 1;
  bool _hasMore = true;

  HomeJobsNotifier(this._repository, this._tab) : super(const AsyncValue.loading()) {
    loadJobs();
  }

  Future<void> loadJobs() async {
    try {
      _currentPage = 1;
      state = const AsyncValue.loading();
      final result = await _fetchPage(1);
      _currentPage = 1;
      _hasMore = result.hasMore;
      state = AsyncValue.data(result.content);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> loadMore() async {
    if (!_hasMore) return;
    final currentJobs = state.value ?? [];
    try {
      final nextPage = _currentPage + 1;
      final result = await _fetchPage(nextPage);
      _currentPage = nextPage;
      _hasMore = result.hasMore;
      state = AsyncValue.data([...currentJobs, ...result.content]);
    } catch (e, st) {
      // Keep current data, don't overwrite
    }
  }

  Future<PageResult<Job>> _fetchPage(int page) async {
    switch (_tab) {
      case HomeTab.recommended:
        return _repository.getRecommendedJobs(page: page);
      case HomeTab.latest:
        return _repository.getLatestJobs(page: page);
      case HomeTab.nearby:
        return _repository.getNearbyJobs(page: page);
    }
  }

  bool get hasMore => _hasMore;
}
