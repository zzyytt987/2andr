import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../home/domain/entities/job.dart';
import '../../domain/repositories/search_repository.dart';
import '../../data/repositories/search_repository_impl.dart';

final searchRepositoryProvider = Provider<SearchRepository>((ref) => SearchRepositoryImpl());

final searchQueryProvider = StateProvider<String>((ref) => '');

final searchFiltersProvider = StateProvider<Map<String, String>>((ref) => {});

final searchResultsProvider = StateNotifierProvider<SearchResultsNotifier, AsyncValue<List<Job>>>(
  (ref) => SearchResultsNotifier(ref.read(searchRepositoryProvider)),
);

class SearchResultsNotifier extends StateNotifier<AsyncValue<List<Job>>> {
  final SearchRepository _repository;
  int _currentPage = 1;
  bool _hasMore = true;

  SearchResultsNotifier(this._repository) : super(const AsyncValue.data([]));

  Future<void> search({
    String? keyword,
    Map<String, String>? filters,
  }) async {
    try {
      _currentPage = 1;
      state = const AsyncValue.loading();
      final result = await _repository.searchJobs(
        keyword: keyword,
        city: filters?['city'],
        salary: filters?['salary'],
        education: filters?['education'],
        experience: filters?['experience'],
        companySize: filters?['companySize'],
        page: 1,
      );
      _currentPage = 1;
      _hasMore = result.hasMore;
      state = AsyncValue.data(result.content);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> loadMore({
    String? keyword,
    Map<String, String>? filters,
  }) async {
    if (!_hasMore) return;
    final currentJobs = state.value ?? [];
    try {
      final nextPage = _currentPage + 1;
      final result = await _repository.searchJobs(
        keyword: keyword,
        city: filters?['city'],
        salary: filters?['salary'],
        education: filters?['education'],
        experience: filters?['experience'],
        companySize: filters?['companySize'],
        page: nextPage,
      );
      _currentPage = nextPage;
      _hasMore = result.hasMore;
      state = AsyncValue.data([...currentJobs, ...result.content]);
    } catch (e, st) {
      // Keep current data
    }
  }

  void clear() {
    state = const AsyncValue.data([]);
    _hasMore = true;
    _currentPage = 1;
  }

  bool get hasMore => _hasMore;
}

final hotSearchesProvider = FutureProvider<List<String>>((ref) {
  return ref.read(searchRepositoryProvider).getHotSearches();
});

final searchHistoryProvider = FutureProvider<List<String>>((ref) {
  return ref.read(searchRepositoryProvider).getSearchHistory();
});
