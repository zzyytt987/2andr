import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/job_card.dart';
import '../providers/favorites_provider.dart';
import '../../../home/domain/entities/job.dart';

class FavoritesPage extends ConsumerWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritesAsync = ref.watch(favoritesProvider);

    return Scaffold(
      backgroundColor: AppColors.secondary,
      appBar: AppBar(
        title: const Text(AppStrings.myFavorites, style: TextStyle(color: AppColors.foreground)),
        backgroundColor: AppColors.card,
        elevation: 0,
      ),
      body: favoritesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(AppStrings.networkError, style: TextStyle(color: AppColors.mutedForeground)),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => ref.read(favoritesProvider.notifier).loadFavorites(),
                child: const Text(AppStrings.retry),
              ),
            ],
          ),
        ),
        data: (jobs) {
          if (jobs.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border, color: AppColors.mutedForeground, size: 64),
                  SizedBox(height: 16),
                  Text('还没有收藏职位', style: TextStyle(fontSize: 16, color: AppColors.mutedForeground)),
                  SizedBox(height: 8),
                  Text('去首页看看感兴趣的职位吧', style: TextStyle(fontSize: 13, color: AppColors.mutedForeground)),
                ],
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () => ref.read(favoritesProvider.notifier).loadFavorites(),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: jobs.length,
              itemBuilder: (context, index) {
                final job = jobs[index];
                return Dismissible(
                  key: Key('fav_${job.id}'),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: AppColors.destructive,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 24),
                    child: const Icon(Icons.delete_outline, color: Colors.white, size: 28),
                  ),
                  onDismissed: (_) {
                    ref.read(favoritesProvider.notifier).removeFavorite(job.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('已取消收藏'), duration: Duration(seconds: 2)),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: JobCard(job: _toJobCardData(job)),
                  ),
                );
              },
            ),
          );
        },
      ),
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
