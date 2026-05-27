import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../providers/resume_provider.dart';
import '../../domain/entities/resume_models.dart';
import '../../domain/repositories/resume_repository.dart';
import '../../data/repositories/resume_repository_impl.dart';

class ResumePage extends ConsumerWidget {
  const ResumePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resumeAsync = ref.watch(resumeProvider);

    return Scaffold(
      backgroundColor: AppColors.secondary,
      appBar: AppBar(
        title: const Text(AppStrings.onlineResume, style: TextStyle(color: AppColors.foreground)),
        backgroundColor: AppColors.card,
        elevation: 0,
      ),
      body: resumeAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(AppStrings.networkError, style: TextStyle(color: AppColors.mutedForeground)),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => ref.invalidate(resumeProvider),
                child: const Text(AppStrings.retry),
              ),
            ],
          ),
        ),
        data: (resume) => RefreshIndicator(
          onRefresh: () async => ref.invalidate(resumeProvider),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildProgressBar(resume.completeness),
              const SizedBox(height: 20),
              _buildEducationSection(context, ref, resume.educationList),
              const SizedBox(height: 16),
              _buildWorkExperienceSection(context, ref, resume.workExperienceList),
              const SizedBox(height: 16),
              _buildSkillsSection(context, ref, resume.skillList),
              const SizedBox(height: 16),
              _buildIntroductionSection(context, ref, resume.selfIntroduction),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressBar(int completeness) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
                SizedBox(
                width: 52,
                height: 52,
                child: CircularProgressIndicator(
                  value: completeness / 100,
                  strokeWidth: 4,
                  backgroundColor: AppColors.secondary,
                  color: AppColors.primary,
                ),
              ),
              Text('$completeness%',
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary)),
            ],
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppStrings.resumeCompleteness,
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.foreground)),
                SizedBox(height: 4),
                Text(AppStrings.resumeTip,
                    style: TextStyle(fontSize: 12, color: AppColors.mutedForeground)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ===== Education =====

  Widget _buildEducationSection(BuildContext context, WidgetRef ref, List<Education> list) {
    return _buildCardSection(
      title: AppStrings.educationHistory,
      icon: Icons.school_outlined,
      onAdd: list.length < 5
          ? () => _showEducationDialog(context, ref)
          : null,
      children: list.isEmpty
          ? [_buildEmptyState('添加教育经历')]
          : list.map((e) => _buildEducationItem(context, ref, e)).toList(),
    );
  }

  Widget _buildEducationItem(BuildContext context, WidgetRef ref, Education edu) {
    return _buildTimelineItem(
      title: edu.school,
      subtitle: edu.major,
      detail: '${edu.degree}  ${edu.startDate} - ${edu.endDate ?? '至今'}',
      onEdit: () => _showEducationDialog(context, ref, education: edu),
      onDelete: () async {
        await ResumeRepositoryImpl().deleteEducation(edu.id!);
        ref.invalidate(resumeProvider);
      },
    );
  }

  void _showEducationDialog(BuildContext context, WidgetRef ref, {Education? education}) {
    final schoolCtrl = TextEditingController(text: education?.school ?? '');
    final majorCtrl = TextEditingController(text: education?.major ?? '');
    final degreeCtrl = TextEditingController(text: education?.degree ?? '');
    final startCtrl = TextEditingController(text: education?.startDate ?? '');
    final endCtrl = TextEditingController(text: education?.endDate ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(ctx).viewInsets.bottom + 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(education != null ? '编辑教育经历' : '添加教育经历',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildDialogField('学校', schoolCtrl),
            _buildDialogField('专业', majorCtrl),
            _buildDialogField('学历', degreeCtrl, hint: '本科/硕士/博士/大专'),
            Row(
              children: [
                Expanded(child: _buildDialogField('开始时间', startCtrl, hint: '2020-09')),
                const SizedBox(width: 12),
                Expanded(child: _buildDialogField('结束时间', endCtrl, hint: '2024-06')),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton(
                onPressed: () async {
                  final repo = ResumeRepositoryImpl();
                  final data = {
                    'school': schoolCtrl.text,
                    'major': majorCtrl.text,
                    'degree': degreeCtrl.text,
                    'startDate': startCtrl.text,
                    'endDate': endCtrl.text.isEmpty ? null : endCtrl.text,
                  };
                  if (education != null) {
                    await repo.updateEducation(education.id!, data);
                  } else {
                    await repo.addEducation(data);
                  }
                  ref.invalidate(resumeProvider);
                  Navigator.pop(ctx);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('保存', style: TextStyle(color: Colors.white, fontSize: 15)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===== Work Experience =====

  Widget _buildWorkExperienceSection(BuildContext context, WidgetRef ref, List<WorkExperience> list) {
    return _buildCardSection(
      title: AppStrings.workHistory,
      icon: Icons.work_outline,
      onAdd: list.length < 10
          ? () => _showWorkDialog(context, ref)
          : null,
      children: list.isEmpty
          ? [_buildEmptyState('添加工作经历')]
          : list.map((e) => _buildWorkItem(context, ref, e)).toList(),
    );
  }

  Widget _buildWorkItem(BuildContext context, WidgetRef ref, WorkExperience exp) {
    return _buildTimelineItem(
      title: exp.companyName,
      subtitle: exp.position,
      detail: '${exp.startDate} - ${exp.endDate ?? '至今'}',
      description: exp.description,
      onEdit: () => _showWorkDialog(context, ref, experience: exp),
      onDelete: () async {
        await ResumeRepositoryImpl().deleteWorkExperience(exp.id!);
        ref.invalidate(resumeProvider);
      },
    );
  }

  void _showWorkDialog(BuildContext context, WidgetRef ref, {WorkExperience? experience}) {
    final companyCtrl = TextEditingController(text: experience?.companyName ?? '');
    final positionCtrl = TextEditingController(text: experience?.position ?? '');
    final startCtrl = TextEditingController(text: experience?.startDate ?? '');
    final endCtrl = TextEditingController(text: experience?.endDate ?? '');
    final descCtrl = TextEditingController(text: experience?.description ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(ctx).viewInsets.bottom + 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(experience != null ? '编辑工作经历' : '添加工作经历',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildDialogField('公司名称', companyCtrl),
            _buildDialogField('职位', positionCtrl),
            Row(
              children: [
                Expanded(child: _buildDialogField('开始时间', startCtrl, hint: '2020-07')),
                const SizedBox(width: 12),
                Expanded(child: _buildDialogField('结束时间', endCtrl, hint: '至今')),
              ],
            ),
            _buildDialogField('工作描述', descCtrl, maxLines: 3, hint: '简要描述工作内容和成果'),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton(
                onPressed: () async {
                  final repo = ResumeRepositoryImpl();
                  final data = {
                    'companyName': companyCtrl.text,
                    'position': positionCtrl.text,
                    'startDate': startCtrl.text,
                    'endDate': endCtrl.text.isEmpty ? null : endCtrl.text,
                    'description': descCtrl.text.isEmpty ? null : descCtrl.text,
                  };
                  if (experience != null) {
                    await repo.updateWorkExperience(experience.id!, data);
                  } else {
                    await repo.addWorkExperience(data);
                  }
                  ref.invalidate(resumeProvider);
                  Navigator.pop(ctx);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('保存', style: TextStyle(color: Colors.white, fontSize: 15)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===== Skills =====

  Widget _buildSkillsSection(BuildContext context, WidgetRef ref, List<UserSkill> list) {
    return _buildCardSection(
      title: AppStrings.skillTags,
      icon: Icons.code,
      onAdd: () => _showSkillsDialog(context, ref, list),
      children: [
        if (list.isEmpty)
          _buildEmptyState('添加技能标签')
        else
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                ...list.map((skill) => Chip(
                      label: Text(skill.skillName,
                          style: const TextStyle(fontSize: 13, color: AppColors.primary)),
                      backgroundColor: AppColors.primary.withOpacity(0.08),
                      deleteIcon: const Icon(Icons.close, size: 14, color: AppColors.primary),
                      onDeleted: () async {
                        final names = list
                            .where((s) => s.id != skill.id)
                            .map((s) => s.skillName)
                            .toList();
                        await ResumeRepositoryImpl().saveSkills(names);
                        ref.invalidate(resumeProvider);
                      },
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      padding: EdgeInsets.zero,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    )),
                GestureDetector(
                  onTap: () => _showSkillsDialog(context, ref, list),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.primary, width: 1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.add, size: 16, color: AppColors.primary),
                        SizedBox(width: 4),
                        Text('添加', style: TextStyle(fontSize: 13, color: AppColors.primary)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  void _showSkillsDialog(BuildContext context, WidgetRef ref, List<UserSkill> existing) {
    final controller = TextEditingController();
    final currentSkills = existing.map((s) => s.skillName).toList();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(AppStrings.skillTags),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: '输入技能名称，如 React、Java',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) async {
                if (controller.text.trim().isNotEmpty) {
                  final newSkills = [...currentSkills, controller.text.trim()];
                  await ResumeRepositoryImpl().saveSkills(newSkills);
                  ref.invalidate(resumeProvider);
                  Navigator.pop(ctx);
                }
              },
            ),
            const SizedBox(height: 8),
            const Text('按回车键添加', style: TextStyle(fontSize: 12, color: AppColors.mutedForeground)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () async {
              if (controller.text.trim().isNotEmpty) {
                final newSkills = [...currentSkills, controller.text.trim()];
                await ResumeRepositoryImpl().saveSkills(newSkills);
                ref.invalidate(resumeProvider);
                Navigator.pop(ctx);
              }
            },
            child: const Text('添加'),
          ),
        ],
      ),
    );
  }

  // ===== Self Introduction =====

  Widget _buildIntroductionSection(BuildContext context, WidgetRef ref, SelfIntroduction? intro) {
    return _buildCardSection(
      title: AppStrings.selfIntro,
      icon: Icons.edit_note,
      onAdd: () => _showIntroDialog(context, ref, intro),
      children: [
        if (intro == null || intro.content == null || intro.content!.isEmpty)
          _buildEmptyState('添加自我介绍')
        else
          GestureDetector(
            onTap: () => _showIntroDialog(context, ref, intro),
            child: Text(intro.content!,
                style: const TextStyle(fontSize: 14, color: AppColors.foreground, height: 1.6)),
          ),
      ],
    );
  }

  void _showIntroDialog(BuildContext context, WidgetRef ref, SelfIntroduction? intro) {
    final controller = TextEditingController(text: intro?.content ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(ctx).viewInsets.bottom + 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(AppStrings.selfIntro,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              maxLines: 5,
              autofocus: true,
              decoration: InputDecoration(
                hintText: '介绍一下自己，突出优势和职业目标...',
                hintStyle: const TextStyle(color: AppColors.mutedForeground),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton(
                onPressed: () async {
                  await ResumeRepositoryImpl().saveIntroduction(controller.text);
                  ref.invalidate(resumeProvider);
                  Navigator.pop(ctx);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('保存', style: TextStyle(color: Colors.white, fontSize: 15)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===== Reusable Widgets =====

  Widget _buildCardSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
    VoidCallback? onAdd,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(icon, size: 18, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Text(title,
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.foreground)),
                ],
              ),
              if (onAdd != null)
                GestureDetector(
                  onTap: onAdd,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.add, size: 16, color: AppColors.primary),
                        SizedBox(width: 2),
                        Text('添加', style: TextStyle(fontSize: 12, color: AppColors.primary)),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _buildTimelineItem({
    required String title,
    required String subtitle,
    required String detail,
    String? description,
    required VoidCallback onEdit,
    required VoidCallback onDelete,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primary.withOpacity(0.2), width: 3),
                ),
              ),
              Container(width: 1, height: 40, color: AppColors.border),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: AppColors.foreground)),
                      const SizedBox(height: 2),
                      Text(subtitle,
                          style: const TextStyle(fontSize: 13, color: AppColors.mutedForeground)),
                      const SizedBox(height: 2),
                      Text(detail,
                          style: const TextStyle(fontSize: 12, color: AppColors.mutedForeground)),
                      if (description != null && description.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 13, color: AppColors.mutedForeground)),
                      ],
                    ],
                  ),
                ),
                PopupMenuButton(
                  icon: const Icon(Icons.more_horiz, color: AppColors.mutedForeground, size: 18),
                  itemBuilder: (_) => [
                    const PopupMenuItem(value: 'edit', child: Text('编辑')),
                    const PopupMenuItem(value: 'delete', child: Text('删除', style: TextStyle(color: AppColors.destructive))),
                  ],
                  onSelected: (action) {
                    if (action == 'edit') onEdit();
                    if (action == 'delete') onDelete();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Text(message,
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppColors.mutedForeground, fontSize: 14)),
    );
  }

  Widget _buildDialogField(String label, TextEditingController controller,
      {String? hint, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.foreground)),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            maxLines: maxLines,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: AppColors.mutedForeground, fontSize: 14),
              filled: true,
              fillColor: AppColors.secondary,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
          ),
        ],
      ),
    );
  }
}
