import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/job_card.dart';
import '../providers/search_provider.dart';
import '../../../home/domain/entities/job.dart';

const _salaryOptions = ['不限', '10K以下', '10K-20K', '20K-30K', '30K-50K', '50K以上'];
const _educationOptions = ['不限', '大专', '本科', '硕士', '博士'];
const _experienceOptions = ['不限', '应届生', '1-3年', '3-5年', '5-7年', '7-10年', '10年以上'];
const _companySizeOptions = ['不限', '0-20人', '20-99人', '100-499人', '500-999人', '1000-5000人', '5000-10000人', '10000+人'];

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _hasSearched = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final notifier = ref.read(searchResultsProvider.notifier);
      if (notifier.hasMore) {
        final filters = ref.read(searchFiltersProvider);
        notifier.loadMore(
          keyword: _searchController.text,
          filters: filters,
        );
      }
    }
  }

  void _performSearch() {
    final keyword = _searchController.text.trim();
    if (keyword.isEmpty) return;
    ref.read(searchQueryProvider.notifier).state = keyword;
    final filters = ref.read(searchFiltersProvider);
    ref.read(searchResultsProvider.notifier).search(keyword: keyword, filters: filters);
    setState(() => _hasSearched = true);
  }

  void _onHistoryTap(String keyword) {
    _searchController.text = keyword;
    _performSearch();
  }

  void _showFilterSheet() {
    final filters = ref.read(searchFiltersProvider);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => _FilterSheet(
        currentFilters: filters,
        onApply: (newFilters) {
          ref.read(searchFiltersProvider.notifier).state = newFilters;
          final keyword = ref.read(searchQueryProvider);
          if (keyword.isNotEmpty) {
            ref.read(searchResultsProvider.notifier).search(
                  keyword: keyword,
                  filters: newFilters,
                );
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final searchResults = ref.watch(searchResultsProvider);

    return Scaffold(
      backgroundColor: AppColors.secondary,
      body: SafeArea(
        child: Column(
          children: [
            _buildSearchBar(),
            if (!_hasSearched) _buildInitialContent(),
            if (_hasSearched)
              Expanded(
                child: searchResults.when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(AppStrings.networkError),
                        const SizedBox(height: 12),
                        ElevatedButton(onPressed: _performSearch, child: const Text(AppStrings.retry)),
                      ],
                    ),
                  ),
                  data: (jobs) {
                    if (jobs.isEmpty) {
                      return const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.search_off, color: AppColors.mutedForeground, size: 48),
                            SizedBox(height: 12),
                            Text(AppStrings.noResults,
                                style: TextStyle(color: AppColors.mutedForeground, fontSize: 16)),
                            SizedBox(height: 4),
                            Text(AppStrings.adjustSearch,
                                style: TextStyle(color: AppColors.mutedForeground, fontSize: 13)),
                          ],
                        ),
                      );
                    }
                    return ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                      itemCount: jobs.length,
                      itemBuilder: (context, index) {
                        final job = jobs[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: JobCard(job: _toJobCardData(job)),
                        );
                      },
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.foreground),
            onPressed: () {
              if (_hasSearched) {
                setState(() => _hasSearched = false);
                ref.read(searchResultsProvider.notifier).clear();
                _searchController.clear();
              } else {
                context.go('/home');
              }
            },
          ),
          Expanded(
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.secondary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextField(
                controller: _searchController,
                autofocus: true,
                onSubmitted: (_) => _performSearch(),
                style: const TextStyle(fontSize: 14, color: AppColors.foreground),
                decoration: InputDecoration(
                  hintText: AppStrings.searchHint,
                  hintStyle:
                      const TextStyle(color: AppColors.mutedForeground, fontSize: 14),
                  prefixIcon: const Icon(Icons.search,
                      color: AppColors.mutedForeground, size: 20),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.cancel, size: 18,
                              color: AppColors.mutedForeground),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {});
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                ),
                onChanged: (_) => setState(() {}),
              ),
            ),
          ),
          TextButton(
            onPressed: _performSearch,
            child: const Text('搜索',
                style: TextStyle(color: AppColors.primary, fontSize: 15)),
          ),
          IconButton(
            icon: const Icon(Icons.tune, color: AppColors.primary),
            onPressed: _showFilterSheet,
          ),
        ],
      ),
    );
  }

  Widget _buildInitialContent() {
    final hotSearches = ref.watch(hotSearchesProvider);
    final searchHistory = ref.watch(searchHistoryProvider);
    final filters = ref.watch(searchFiltersProvider);

    return Expanded(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Active filters
            if (filters.isNotEmpty) ...[
              _buildActiveFilters(filters),
              const SizedBox(height: 16),
            ],

            // Hot searches
            const Text(AppStrings.hotSearches,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.foreground)),
            const SizedBox(height: 12),
            hotSearches.when(
              loading: () => const SizedBox(),
              error: (_, __) => const SizedBox(),
              data: (items) => Wrap(
                spacing: 10,
                runSpacing: 10,
                children: items.asMap().entries.map((entry) {
                  return GestureDetector(
                    onTap: () => _onHistoryTap(entry.value),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.border, width: 0.5),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${entry.key + 1}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: entry.key < 3 ? AppColors.primary : AppColors.mutedForeground,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(entry.value,
                              style: const TextStyle(fontSize: 13, color: AppColors.foreground)),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 24),

            // Search history
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(AppStrings.searchHistory,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.foreground)),
                GestureDetector(
                  onTap: () {
                    ref.read(searchRepositoryProvider).clearSearchHistory();
                    ref.invalidate(searchHistoryProvider);
                  },
                  child: const Row(
                    children: [
                      Icon(Icons.delete_outline,
                          size: 16, color: AppColors.mutedForeground),
                      SizedBox(width: 4),
                      Text(AppStrings.clear,
                          style: TextStyle(
                              fontSize: 13, color: AppColors.mutedForeground)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            searchHistory.when(
              loading: () => const SizedBox(),
              error: (_, __) => const SizedBox(),
              data: (items) {
                if (items.isEmpty) {
                  return const Text('暂无搜索历史',
                      style: TextStyle(
                          fontSize: 13, color: AppColors.mutedForeground));
                }
                return Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: items.map((keyword) {
                    return GestureDetector(
                      onTap: () => _onHistoryTap(keyword),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                        decoration: BoxDecoration(
                          color: AppColors.card,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.border, width: 0.5),
                        ),
                        child: Text(keyword,
                            style: const TextStyle(
                                fontSize: 13, color: AppColors.mutedForeground)),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveFilters(Map<String, String> filters) {
    final labels = <String, String>{
      'salary': '薪资',
      'education': '学历',
      'experience': '经验',
      'companySize': '规模',
    };
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: filters.entries.where((e) => e.value.isNotEmpty && e.value != '不限').map((entry) {
        return Chip(
          label: Text('${labels[entry.key] ?? entry.key}: ${entry.value}',
              style: const TextStyle(fontSize: 12, color: AppColors.primary)),
          backgroundColor: AppColors.primary.withOpacity(0.08),
          deleteIcon: const Icon(Icons.close, size: 14, color: AppColors.primary),
          onDeleted: () {
            final updated = Map<String, String>.from(filters);
            updated[entry.key] = '';
            ref.read(searchFiltersProvider.notifier).state = updated;
          },
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          padding: EdgeInsets.zero,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        );
      }).toList(),
    );
  }

  JobCardData _toJobCardData(Job job) {
    return JobCardData(
      id: job.id,
      title: job.title,
      salaryRange: job.salaryRange,
      company: job.companyName ?? '',
      logo: job.companyLogo ?? '',
      tags: job.skills.take(3).toList(),
      experience: job.experience,
      education: job.education,
      location: '${job.city} · ${job.district}',
      isUrgent: job.isUrgent,
      isOnline: true,
    );
  }
}

class _FilterSheet extends StatefulWidget {
  final Map<String, String> currentFilters;
  final ValueChanged<Map<String, String>> onApply;

  const _FilterSheet({required this.currentFilters, required this.onApply});

  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet> {
  late Map<String, String> _filters;

  @override
  void initState() {
    super.initState();
    _filters = Map<String, String>.from(widget.currentFilters);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(AppStrings.filter,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.foreground)),
              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      setState(() => _filters = {});
                    },
                    child: const Text(AppStrings.reset,
                        style: TextStyle(color: AppColors.mutedForeground)),
                  ),
                  TextButton(
                    onPressed: () {
                      widget.onApply(_filters);
                      Navigator.pop(context);
                    },
                    child: const Text(AppStrings.confirm,
                        style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildFilterSection(AppStrings.salaryRange, 'salary', _salaryOptions),
          _buildFilterSection(AppStrings.educationReq, 'education', _educationOptions),
          _buildFilterSection(AppStrings.workExperience, 'experience', _experienceOptions),
          _buildFilterSection(AppStrings.companySize, 'companySize', _companySizeOptions),
          SizedBox(height: MediaQuery.of(context).padding.bottom + 20),
        ],
      ),
    );
  }

  Widget _buildFilterSection(String title, String key, List<String> options) {
    final selected = _filters[key] ?? '不限';
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.foreground)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: options.map((option) {
              final isSelected = selected == option;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _filters[key] = option == '不限' ? '' : option;
                    if (_filters[key]!.isEmpty) _filters.remove(key);
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : AppColors.secondary,
                    borderRadius: BorderRadius.circular(20),
                    border: isSelected
                        ? null
                        : Border.all(color: AppColors.border, width: 0.5),
                  ),
                  child: Text(
                    option,
                    style: TextStyle(
                      fontSize: 13,
                      color: isSelected ? Colors.white : AppColors.foreground,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
