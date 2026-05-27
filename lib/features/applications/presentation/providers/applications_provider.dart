import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/application.dart';
import '../../data/datasources/application_remote_datasource.dart';

final applicationsProvider = StateNotifierProvider<ApplicationsNotifier, AsyncValue<List<JobApplication>>>(
  (ref) => ApplicationsNotifier(),
);

class ApplicationsNotifier extends StateNotifier<AsyncValue<List<JobApplication>>> {
  final ApplicationRemoteDataSource _remote = ApplicationRemoteDataSource();
  int _currentPage = 1;
  bool _hasMore = true;

  ApplicationsNotifier() : super(const AsyncValue.loading()) {
    loadApplications();
  }

  Future<void> loadApplications() async {
    try {
      _currentPage = 1;
      state = const AsyncValue.loading();
      final result = await _remote.getApplications();
      _currentPage = 1;
      _hasMore = result.hasMore;
      state = AsyncValue.data(result.content);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> loadMore() async {
    if (!_hasMore) return;
    final current = state.value ?? [];
    try {
      final nextPage = _currentPage + 1;
      final result = await _remote.getApplications(page: nextPage);
      _currentPage = nextPage;
      _hasMore = result.hasMore;
      state = AsyncValue.data([...current, ...result.content]);
    } catch (e, _) {}
  }

  bool get hasMore => _hasMore;
}

final applicationStatsProvider = FutureProvider<ApplicationStats>((ref) {
  return ApplicationRemoteDataSource().getStats();
});
