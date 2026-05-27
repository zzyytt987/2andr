import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../constants/app_colors.dart';

class JobCardData {
  final int id;
  final String title;
  final String salaryRange;
  final String company;
  final String logo;
  final List<String> tags;
  final String experience;
  final String education;
  final String location;
  final bool isUrgent;
  final bool isOnline;

  const JobCardData({
    required this.id,
    required this.title,
    required this.salaryRange,
    required this.company,
    required this.logo,
    required this.tags,
    required this.experience,
    required this.education,
    required this.location,
    this.isUrgent = false,
    this.isOnline = false,
  });
}

class JobCard extends StatelessWidget {
  final JobCardData job;

  const JobCard({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/job/${job.id}'),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(job.title,
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.foreground)),
                          ),
                          if (job.isUrgent) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.destructive.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text('急聘',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.destructive)),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(job.salaryRange,
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary)),
                    ],
                  ),
                ),
                const Icon(Icons.favorite_border,
                    color: AppColors.mutedForeground, size: 20),
              ],
            ),
            const SizedBox(height: 12),

            // Tags
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: job.tags.map((tag) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.secondary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(tag,
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.mutedForeground)),
                );
              }).toList(),
            ),
            const SizedBox(height: 12),

            // Info row
            Row(
              children: [
                Text('${job.experience} · ${job.education} · ${job.location}',
                    style: const TextStyle(
                        fontSize: 13, color: AppColors.mutedForeground)),
              ],
            ),
            const SizedBox(height: 12),

            // Company row
            Container(
              padding: const EdgeInsets.only(top: 12),
              decoration: const BoxDecoration(
                border: Border(
                    top: BorderSide(color: AppColors.border, width: 0.5)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.secondary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignment: Alignment.center,
                        child: Text(job.logo, style: const TextStyle(fontSize: 20)),
                      ),
                      const SizedBox(width: 12),
                      Text(job.company,
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.foreground)),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        if (job.isOnline) ...[
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                                color: AppColors.success, shape: BoxShape.circle),
                          ),
                          const SizedBox(width: 4),
                        ],
                        const Text('立即沟通',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
