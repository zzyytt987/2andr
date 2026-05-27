import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../providers/profile_provider.dart';
import '../../domain/entities/user_profile.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../resume/presentation/providers/resume_provider.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileProvider);
    final progressAsync = ref.watch(resumeProgressProvider);

    return Scaffold(
      backgroundColor: AppColors.secondary,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Profile card
              profileAsync.when(
                loading: () => _buildProfileSkeleton(),
                error: (e, _) => _buildProfileError(),
                data: (profile) => _buildProfileCard(context, profile, progressAsync),
              ),

              const SizedBox(height: 12),

              // Menu sections
              _buildMenuSection([
                _MenuItem(Icons.favorite_border, AppStrings.myFavorites, () => context.push('/favorites')),
                _MenuItem(Icons.send_outlined, AppStrings.applicationRecords, () => context.push('/applications')),
                _MenuItem(Icons.calendar_today_outlined, AppStrings.interviewInvites, () {}),
              ]),
              const SizedBox(height: 12),
              _buildMenuSection([
                _MenuItem(Icons.person_outline, AppStrings.personalInfo, () => context.push('/profile/edit')),
                _MenuItem(Icons.article_outlined, AppStrings.onlineResume, () => context.push('/resume')),
              ]),
              const SizedBox(height: 12),
              _buildMenuSection([
                _MenuItem(Icons.settings_outlined, AppStrings.settings, () => context.push('/settings')),
                _MenuItem(Icons.help_outline, AppStrings.helpFeedback, () {}),
              ]),

              const SizedBox(height: 24),
              OutlinedButton(
                onPressed: () => ref.read(authProvider.notifier).logout(),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.destructive,
                  side: const BorderSide(color: AppColors.destructive),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 12),
                ),
                child: const Text(AppStrings.logoutButton, style: TextStyle(fontSize: 15)),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context, UserProfile profile, AsyncValue<int> progressAsync) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1677FF), Color(0xFF4096FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Avatar
              GestureDetector(
                onTap: () => context.push('/profile/edit'),
                child: Container(
                  width: 68,
                  height: 68,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                    color: Colors.white.withOpacity(0.2),
                  ),
                  alignment: Alignment.center,
                  child: profile.avatarUrl != null && profile.avatarUrl!.isNotEmpty
                      ? ClipOval(
                          child: Image.network(profile.avatarUrl!,
                              width: 68, height: 68, fit: BoxFit.cover),
                        )
                      : const Icon(Icons.person, color: Colors.white, size: 36),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(profile.displayName,
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                    const SizedBox(height: 4),
                    Text(
                      profile.expectedPosition ?? '添加期望职位',
                      style: const TextStyle(fontSize: 14, color: Colors.white70),
                    ),
                    const SizedBox(height: 4),
                    if (profile.city != null)
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined,
                              size: 13, color: Colors.white70),
                          const SizedBox(width: 2),
                          Text(profile.city!,
                              style: const TextStyle(fontSize: 12, color: Colors.white70)),
                        ],
                      ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.qr_code_scanner, color: Colors.white, size: 28),
                onPressed: () {},
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Resume progress
          progressAsync.when(
            loading: () => const SizedBox(),
            error: (_, __) => const SizedBox(),
            data: (progress) => GestureDetector(
              onTap: () => context.push('/resume'),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: Text('$progress%',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(AppStrings.resumeCompleteness,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14)),
                          const SizedBox(height: 2),
                          Text(AppStrings.resumeTip,
                              style: const TextStyle(
                                  color: Colors.white60, fontSize: 12)),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right, color: Colors.white60),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileSkeleton() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1677FF), Color(0xFF4096FF)],
        ),
      ),
      child: const Center(
        child: CircularProgressIndicator(color: Colors.white),
      ),
    );
  }

  Widget _buildProfileError() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1677FF), Color(0xFF4096FF)],
        ),
      ),
      child: const Center(
        child: Text('加载失败', style: TextStyle(color: Colors.white70)),
      ),
    );
  }

  Widget _buildMenuSection(List<_MenuItem> items) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: items.asMap().entries.map((entry) {
          final item = entry.value;
          final isLast = entry.key == items.length - 1;
          return InkWell(
            onTap: item.onTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                border: isLast
                    ? null
                    : const Border(
                        bottom: BorderSide(color: AppColors.border, width: 0.5)),
              ),
              child: Row(
                children: [
                  Icon(item.icon, color: AppColors.foreground, size: 22),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(item.label,
                        style: const TextStyle(
                            fontSize: 15, color: AppColors.foreground)),
                  ),
                  const Icon(Icons.chevron_right,
                      color: AppColors.mutedForeground, size: 20),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _MenuItem(this.icon, this.label, this.onTap);
}
