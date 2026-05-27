import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../providers/applications_provider.dart';
import '../../domain/entities/application.dart';

class ApplicationsPage extends ConsumerWidget {
  const ApplicationsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final applicationsAsync = ref.watch(applicationsProvider);
    final statsAsync = ref.watch(applicationStatsProvider);

    return Scaffold(
      backgroundColor: AppColors.secondary,
      appBar: AppBar(
        title: const Text(AppStrings.applicationRecords, style: TextStyle(color: AppColors.foreground)),
        backgroundColor: AppColors.card,
        elevation: 0,
      ),
      body: applicationsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(AppStrings.networkError, style: TextStyle(color: AppColors.mutedForeground)),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => ref.read(applicationsProvider.notifier).loadApplications(),
                child: const Text(AppStrings.retry),
              ),
            ],
          ),
        ),
        data: (applications) {
          if (applications.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.send_outlined, color: AppColors.mutedForeground, size: 64),
                  SizedBox(height: 16),
                  Text('还没有投递记录', style: TextStyle(fontSize: 16, color: AppColors.mutedForeground)),
                  SizedBox(height: 8),
                  Text('去首页看看感兴趣的职位吧', style: TextStyle(fontSize: 13, color: AppColors.mutedForeground)),
                ],
              ),
            );
          }
          return Column(
            children: [
              // Stats bar
              statsAsync.when(
                loading: () => const SizedBox(),
                error: (_, __) => const SizedBox(),
                data: (stats) => _buildStatsBar(stats),
              ),

              // List
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () {
                    ref.invalidate(applicationStatsProvider);
                    return ref.read(applicationsProvider.notifier).loadApplications();
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: applications.length,
                    itemBuilder: (context, index) {
                      final app = applications[index];
                      return _buildApplicationCard(app);
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatsBar(ApplicationStats stats) {
    final items = [
      ('全部', stats.total, AppColors.primary),
      ('待处理', stats.statusCounts['PENDING'] ?? 0, AppColors.warning),
      ('已查看', stats.statusCounts['VIEWED'] ?? 0, AppColors.chartPurple),
      ('面试', stats.statusCounts['INTERVIEW'] ?? 0, AppColors.success),
      ('不合适', stats.statusCounts['REJECTED'] ?? 0, AppColors.mutedForeground),
    ];

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: items.map((item) {
          return Column(
            children: [
              Text('${item.$2}',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: item.$3)),
              const SizedBox(height: 2),
              Text(item.$1,
                  style: const TextStyle(fontSize: 11, color: AppColors.mutedForeground)),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildApplicationCard(JobApplication app) {
    final status = app.applicationStatus;
    final job = app.job;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status + time
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _statusColor(status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(status.label,
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _statusColor(status))),
              ),
              if (app.createdAt != null)
                Text('${AppStrings.applyTime}: ${_formatDate(app.createdAt!)}',
                    style: const TextStyle(fontSize: 12, color: AppColors.mutedForeground)),
            ],
          ),

          if (app.interviewTime != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.06),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today, size: 16, color: AppColors.success),
                  const SizedBox(width: 8),
                  Text('面试时间: ${_formatDate(app.interviewTime!)}',
                      style: const TextStyle(fontSize: 13, color: AppColors.success)),
                ],
              ),
            ),
          ],

          // Job info
          if (job != null) ...[
            const SizedBox(height: 12),
            const Divider(height: 1, color: AppColors.border),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.secondary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: Text(job.companyLogo ?? '🏢', style: const TextStyle(fontSize: 22)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(job.title,
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: AppColors.foreground)),
                      const SizedBox(height: 4),
                      Text(job.salaryRange,
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary)),
                      const SizedBox(height: 2),
                      Text('${job.companyName ?? ""}  ${job.city} · ${job.district}',
                          style: const TextStyle(
                              fontSize: 12, color: AppColors.mutedForeground)),
                    ],
                  ),
                ),
              ],
            ),
          ],

          if (app.remark != null && app.remark!.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(app.remark!,
                style: const TextStyle(fontSize: 13, color: AppColors.mutedForeground)),
          ],
        ],
      ),
    );
  }

  Color _statusColor(ApplicationStatus status) {
    switch (status) {
      case ApplicationStatus.pending:
        return AppColors.warning;
      case ApplicationStatus.viewed:
        return AppColors.chartPurple;
      case ApplicationStatus.interview:
        return AppColors.success;
      case ApplicationStatus.offer:
        return AppColors.primary;
      case ApplicationStatus.rejected:
        return AppColors.mutedForeground;
    }
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return '${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return dateStr;
    }
  }
}
