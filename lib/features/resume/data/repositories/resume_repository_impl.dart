import '../../domain/entities/resume_models.dart';
import '../../domain/repositories/resume_repository.dart';
import '../datasources/resume_remote_datasource.dart';

class ResumeRepositoryImpl implements ResumeRepository {
  final ResumeRemoteDataSource _remote = ResumeRemoteDataSource();

  @override
  Future<ResumeData> getResume() => _remote.getResume();
  @override
  Future<int> getProgress() => _remote.getProgress();
  @override
  Future<List<Education>> getEducationList() => _remote.getEducationList();
  @override
  Future<Education> addEducation(Map<String, dynamic> data) => _remote.addEducation(data);
  @override
  Future<Education> updateEducation(int id, Map<String, dynamic> data) => _remote.updateEducation(id, data);
  @override
  Future<void> deleteEducation(int id) => _remote.deleteEducation(id);
  @override
  Future<List<WorkExperience>> getWorkExperienceList() => _remote.getWorkExperienceList();
  @override
  Future<WorkExperience> addWorkExperience(Map<String, dynamic> data) => _remote.addWorkExperience(data);
  @override
  Future<WorkExperience> updateWorkExperience(int id, Map<String, dynamic> data) => _remote.updateWorkExperience(id, data);
  @override
  Future<void> deleteWorkExperience(int id) => _remote.deleteWorkExperience(id);
  @override
  Future<List<UserSkill>> getSkills() => _remote.getSkills();
  @override
  Future<List<UserSkill>> saveSkills(List<String> skills) => _remote.saveSkills(skills);
  @override
  Future<SelfIntroduction?> getIntroduction() => _remote.getIntroduction();
  @override
  Future<SelfIntroduction> saveIntroduction(String content) => _remote.saveIntroduction(content);
}
