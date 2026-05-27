import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/job_card.dart';
import '../providers/home_provider.dart';
import '../../domain/entities/job.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final tab = ref.read(homeTabProvider);
      final notifier = ref.read(homeJobsProvider(tab).notifier);
      if (notifier.hasMore) {
        notifier.loadMore();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final tab = ref.watch(homeTabProvider);

    return Scaffold(
      backgroundColor: AppColors.secondary,
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            _buildHeader(),
            _buildSearchBar(context),
            _buildTabs(tab),
          ],
          body: _buildJobList(tab),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {},
              child: Row(
                children: [
                  const Icon(Icons.location_on_outlined,
                      color: AppColors.primary, size: 20),
                  const SizedBox(width: 4),
                  const Text('北京',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.foreground)),
                  const Icon(Icons.keyboard_arrow_down,
                      color: AppColors.mutedForeground, size: 18),
                ],
              ),
            ),
            Row(
              children: [
                Stack(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.notifications_outlined,
                          color: AppColors.foreground),
                      onPressed: () {},
                    ),
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: AppColors.destructive,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 1.5),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: GestureDetector(
          onTap: () => context.go('/search'),
          child: Container(
            height: 44,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: AppColors.border, width: 0.5),
            ),
            child: Row(
              children: [
                const Icon(Icons.search,
                    color: AppColors.mutedForeground, size: 20),
                const SizedBox(width: 8),
                Text(AppStrings.searchHint,
                    style: const TextStyle(
                        color: AppColors.mutedForeground, fontSize: 14)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabs(HomeTab currentTab) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _TabBarDelegate(currentTab, (tab) {
        ref.read(homeTabProvider.notifier).state = tab;
      }),
    );
  }

  Widget _buildJobList(HomeTab tab) {
    final jobsAsync = ref.watch(homeJobsProvider(tab));

    return jobsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline,
                color: AppColors.mutedForeground, size: 48),
            const SizedBox(height: 12),
            const Text(AppStrings.networkError,
                style: TextStyle(color: AppColors.mutedForeground)),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () =>
                  ref.read(homeJobsProvider(tab).notifier).loadJobs(),
              child: const Text(AppStrings.retry),
            ),
          ],
        ),
      ),
      data: (jobs) {
        if (jobs.isEmpty) {
          return const Center(
            child: Text(AppStrings.noData,
                style: TextStyle(color: AppColors.mutedForeground)),
          );
        }
        return RefreshIndicator(
          onRefresh: () => ref.read(homeJobsProvider(tab).notifier).loadJobs(),
          child: ListView.builder(
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
          ),
        );
      },
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

class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final HomeTab currentTab;
  final ValueChanged<HomeTab> onTabChanged;

  _TabBarDelegate(this.currentTab, this.onTabChanged);

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: AppColors.secondary,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          _buildTab(HomeTab.recommended, AppStrings.recommend),
          const SizedBox(width: 24),
          _buildTab(HomeTab.latest, AppStrings.latest),
          const SizedBox(width: 24),
          _buildTab(HomeTab.nearby, AppStrings.nearby),
        ],
      ),
    );
  }

  Widget _buildTab(HomeTab tab, String label) {
    final isSelected = currentTab == tab;
    return GestureDetector(
      onTap: () => onTabChanged(tab),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isSelected ? 18 : 15,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected ? AppColors.foreground : AppColors.mutedForeground,
            ),
          ),
          if (isSelected)
            Container(
              margin: const EdgeInsets.only(top: 4),
              width: 20,
              height: 3,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => 48;

  @override
  double get minExtent => 48;

  @override
  bool shouldRebuild(covariant _TabBarDelegate oldDelegate) =>
      currentTab != oldDelegate.currentTab;
}
