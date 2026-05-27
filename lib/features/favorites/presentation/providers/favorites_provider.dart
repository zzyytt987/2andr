import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../home/domain/entities/job.dart';
import '../../data/datasources/favorite_remote_datasource.dart';

final favoritesProvider = StateNotifierProvider<FavoritesNotifier, AsyncValue<List<Job>>>(
  (ref) => FavoritesNotifier(),
);

class FavoritesNotifier extends StateNotifier<AsyncValue<List<Job>>> {
  final FavoriteRemoteDataSource _remote = FavoriteRemoteDataSource();
  int _currentPage = 1;
  bool _hasMore = true;

  FavoritesNotifier() : super(const AsyncValue.loading()) {
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    try {
      _currentPage = 1;
      state = const AsyncValue.loading();
      final result = await _remote.getFavorites();
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
      final result = await _remote.getFavorites(page: nextPage);
      _currentPage = nextPage;
      _hasMore = result.hasMore;
      state = AsyncValue.data([...currentJobs, ...result.content]);
    } catch (e, _) {}
  }

  Future<void> removeFavorite(int jobId) async {
    try {
      await _remote.removeFavorite(jobId);
      final currentJobs = state.value ?? [];
      state = AsyncValue.data(currentJobs.where((j) => j.id != jobId).toList());
    } catch (e, _) {}
  }

  Future<void> toggleFavorite(int jobId) async {
    await _remote.toggleFavorite(jobId);
    await loadFavorites();
  }

  bool get hasMore => _hasMore;
}
