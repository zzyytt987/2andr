import '../entities/resume_models.dart';

abstract class ResumeRepository {
  Future<ResumeData> getResume();
  Future<int> getProgress();
  Future<List<Education>> getEducationList();
  Future<Education> addEducation(Map<String, dynamic> data);
  Future<Education> updateEducation(int id, Map<String, dynamic> data);
  Future<void> deleteEducation(int id);
  Future<List<WorkExperience>> getWorkExperienceList();
  Future<WorkExperience> addWorkExperience(Map<String, dynamic> data);
  Future<WorkExperience> updateWorkExperience(int id, Map<String, dynamic> data);
  Future<void> deleteWorkExperience(int id);
  Future<List<UserSkill>> getSkills();
  Future<List<UserSkill>> saveSkills(List<String> skills);
  Future<SelfIntroduction?> getIntroduction();
  Future<SelfIntroduction> saveIntroduction(String content);
}
