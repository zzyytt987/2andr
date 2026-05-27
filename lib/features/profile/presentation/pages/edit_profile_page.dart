import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../providers/profile_provider.dart';
import '../../domain/entities/user_profile.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  const EditProfilePage({super.key});

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nicknameCtrl;
  late TextEditingController _emailCtrl;
  late TextEditingController _cityCtrl;
  late TextEditingController _positionCtrl;
  int _gender = 0;
  String _jobStatus = '在职-考虑机会';
  bool _saving = false;

  final _jobStatusOptions = ['离职-随时到岗', '在职-考虑机会', '在职-暂无跳槽打算', '应届毕业生'];

  @override
  void initState() {
    super.initState();
    _nicknameCtrl = TextEditingController();
    _emailCtrl = TextEditingController();
    _cityCtrl = TextEditingController();
    _positionCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _nicknameCtrl.dispose();
    _emailCtrl.dispose();
    _cityCtrl.dispose();
    _positionCtrl.dispose();
    super.dispose();
  }

  void _loadProfile(UserProfile profile) {
    _nicknameCtrl.text = profile.nickname ?? '';
    _emailCtrl.text = profile.email ?? '';
    _cityCtrl.text = profile.city ?? '';
    _positionCtrl.text = profile.expectedPosition ?? '';
    _gender = profile.gender;
    _jobStatus = profile.jobStatus ?? '在职-考虑机会';
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);
    try {
      final repo = ref.read(userRepositoryProvider);
      await repo.updateProfile({
        'nickname': _nicknameCtrl.text,
        'email': _emailCtrl.text,
        'gender': _gender,
        'city': _cityCtrl.text,
        'expectedPosition': _positionCtrl.text,
        'jobStatus': _jobStatus,
      });
      ref.invalidate(userProfileProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('保存成功'), backgroundColor: AppColors.success),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('保存失败: $e'), backgroundColor: AppColors.destructive),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(userProfileProvider);

    return Scaffold(
      backgroundColor: AppColors.secondary,
      appBar: AppBar(
        title: const Text(AppStrings.editProfile, style: TextStyle(color: AppColors.foreground)),
        backgroundColor: AppColors.card,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _saving ? null : _save,
            child: _saving
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                : const Text(AppStrings.save, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('加载失败: $e', style: const TextStyle(color: AppColors.mutedForeground))),
        data: (profile) {
          if (_nicknameCtrl.text.isEmpty && profile.nickname != null) {
            _loadProfile(profile);
          }
          return _buildForm(profile);
        },
      ),
    );
  }

  Widget _buildForm(UserProfile profile) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            // Avatar
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 88,
                    height: 88,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.secondary,
                      border: Border.all(color: AppColors.border, width: 1),
                    ),
                    alignment: Alignment.center,
                    child: profile.avatarUrl != null && profile.avatarUrl!.isNotEmpty
                        ? ClipOval(
                            child: Image.network(profile.avatarUrl!,
                                width: 88, height: 88, fit: BoxFit.cover),
                          )
                        : const Icon(Icons.person, color: AppColors.mutedForeground, size: 44),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const Icon(Icons.camera_alt, color: Colors.white, size: 14),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            _buildTextField('昵称', _nicknameCtrl, hint: '请输入昵称'),
            _buildTextField('邮箱', _emailCtrl, hint: '请输入邮箱', keyboardType: TextInputType.emailAddress),
            _buildTextField('所在城市', _cityCtrl, hint: '请输入城市'),
            _buildTextField('期望职位', _positionCtrl, hint: '请输入期望职位'),

            // Gender
            _buildSectionTitle('性别'),
            Row(
              children: [
                _buildGenderChip('男', 1),
                const SizedBox(width: 12),
                _buildGenderChip('女', 2),
              ],
            ),
            const SizedBox(height: 16),

            // Job status
            _buildSectionTitle('求职状态'),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _jobStatusOptions.map((status) {
                final selected = _jobStatus == status;
                return GestureDetector(
                  onTap: () => setState(() => _jobStatus = status),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: selected ? AppColors.primary : AppColors.card,
                      borderRadius: BorderRadius.circular(20),
                      border: selected ? null : Border.all(color: AppColors.border, width: 0.5),
                    ),
                    child: Text(status,
                        style: TextStyle(
                            fontSize: 13,
                            color: selected ? Colors.white : AppColors.foreground)),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _saving ? null : _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text(AppStrings.save, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {String? hint, TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(label),
          TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            style: const TextStyle(fontSize: 14, color: AppColors.foreground),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: AppColors.mutedForeground, fontSize: 14),
              filled: true,
              fillColor: AppColors.card,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(title,
          style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.foreground)),
    );
  }

  Widget _buildGenderChip(String label, int value) {
    final selected = _gender == value;
    return GestureDetector(
      onTap: () => setState(() => _gender = value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.card,
          borderRadius: BorderRadius.circular(20),
          border: selected ? null : Border.all(color: AppColors.border, width: 0.5),
        ),
        child: Text(label,
            style: TextStyle(
                fontSize: 14,
                color: selected ? Colors.white : AppColors.foreground)),
      ),
    );
  }
}
