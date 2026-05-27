import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../providers/settings_provider.dart';
import '../../../../core/storage/local_storage.dart';
import '../../../profile/presentation/providers/profile_provider.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final notificationEnabled = ref.watch(notificationEnabledProvider);

    return Scaffold(
      backgroundColor: AppColors.secondary,
      appBar: AppBar(
        title: const Text(AppStrings.settings, style: TextStyle(color: AppColors.foreground)),
        backgroundColor: AppColors.card,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionTitle(AppStrings.accountSecurity),
          _buildCard([
            _SettingsTile(
              icon: Icons.lock_outline,
              title: AppStrings.changePassword,
              trailing: const Icon(Icons.chevron_right, color: AppColors.mutedForeground, size: 20),
              onTap: () => _showChangePasswordDialog(context, ref),
            ),
            _SettingsTile(
              icon: Icons.phone_android,
              title: AppStrings.changePhone,
              trailing: const Icon(Icons.chevron_right, color: AppColors.mutedForeground, size: 20),
              onTap: () {},
            ),
          ]),

          const SizedBox(height: 20),

          _buildSectionTitle(AppStrings.notificationSettings),
          _buildCard([
            _SettingsTile(
              icon: Icons.notifications_outlined,
              title: AppStrings.messageNotification,
              trailing: Switch(
                value: notificationEnabled,
                onChanged: (val) {
                  ref.read(notificationEnabledProvider.notifier).state = val;
                  LocalStorage.setNotificationsEnabled(val);
                },
                activeColor: AppColors.primary,
              ),
            ),
          ]),

          const SizedBox(height: 20),

          _buildSectionTitle(AppStrings.appSettings),
          _buildCard([
            _SettingsTile(
              icon: Icons.dark_mode_outlined,
              title: AppStrings.darkMode,
              trailing: Switch(
                value: themeMode == ThemeMode.dark,
                onChanged: (_) => ref.read(themeModeProvider.notifier).toggle(),
                activeColor: AppColors.primary,
              ),
            ),
            _SettingsTile(
              icon: Icons.language,
              title: AppStrings.languageSettings,
              trailing: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('中文', style: TextStyle(color: AppColors.mutedForeground, fontSize: 14)),
                  SizedBox(width: 4),
                  Icon(Icons.chevron_right, color: AppColors.mutedForeground, size: 20),
                ],
              ),
              onTap: () {},
            ),
            _SettingsTile(
              icon: Icons.cleaning_services_outlined,
              title: AppStrings.clearCache,
              trailing: const Text('2.3 MB', style: TextStyle(color: AppColors.mutedForeground, fontSize: 14)),
              onTap: () async {
                await LocalStorage.clearCache();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('缓存已清除'), backgroundColor: AppColors.success),
                  );
                }
              },
            ),
          ]),

          const SizedBox(height: 20),

          _buildCard([
            _SettingsTile(
              icon: Icons.help_outline,
              title: AppStrings.helpFeedback,
              trailing: const Icon(Icons.chevron_right, color: AppColors.mutedForeground, size: 20),
              onTap: () {},
            ),
            _SettingsTile(
              icon: Icons.info_outline,
              title: AppStrings.aboutUs,
              trailing: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(AppStrings.appVersion, style: TextStyle(color: AppColors.mutedForeground, fontSize: 14)),
                  SizedBox(width: 4),
                  Icon(Icons.chevron_right, color: AppColors.mutedForeground, size: 20),
                ],
              ),
              onTap: () {},
            ),
          ]),

          const SizedBox(height: 40),
          const Center(
            child: Text(AppStrings.copyright,
                style: TextStyle(color: AppColors.mutedForeground, fontSize: 12)),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 10),
      child: Text(title,
          style: const TextStyle(
              fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.mutedForeground)),
    );
  }

  Widget _buildCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(children: children),
    );
  }

  void _showChangePasswordDialog(BuildContext context, WidgetRef ref) {
    final oldCtrl = TextEditingController();
    final newCtrl = TextEditingController();
    final confirmCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) {
          bool isLoading = false;
          return AlertDialog(
            title: const Text(AppStrings.changePassword),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: oldCtrl,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: '旧密码', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: newCtrl,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: '新密码', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: confirmCtrl,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: '确认新密码', border: OutlineInputBorder()),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: isLoading ? null : () => Navigator.pop(ctx),
                child: const Text('取消'),
              ),
              ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () async {
                        if (oldCtrl.text.isEmpty || newCtrl.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('请填写所有字段'), backgroundColor: AppColors.destructive),
                          );
                          return;
                        }
                        if (newCtrl.text != confirmCtrl.text) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('两次密码不一致'), backgroundColor: AppColors.destructive),
                          );
                          return;
                        }
                        setDialogState(() => isLoading = true);
                        try {
                          await ref.read(userRepositoryProvider).changePassword(oldCtrl.text, newCtrl.text);
                          if (ctx.mounted) Navigator.pop(ctx);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('密码修改成功'), backgroundColor: AppColors.success),
                            );
                          }
                        } catch (e) {
                          setDialogState(() => isLoading = false);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('修改失败: $e'), backgroundColor: AppColors.destructive),
                          );
                        }
                      },
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                child: const Text('确认', style: TextStyle(color: Colors.white)),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        child: Row(
          children: [
            Icon(icon, color: AppColors.foreground, size: 22),
            const SizedBox(width: 14),
            Expanded(child: Text(title, style: const TextStyle(fontSize: 15, color: AppColors.foreground))),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}
