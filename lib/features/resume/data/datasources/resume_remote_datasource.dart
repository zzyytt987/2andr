import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../../domain/entities/resume_models.dart';

class ResumeRemoteDataSource {
  final Dio _dio = DioClient.instance.dio;

  Future<ResumeData> getResume() async {
    final response = await _dio.get(ApiConstants.resumeMe);
    return ResumeData.fromJson(response.data['data']);
  }

  Future<int> getProgress() async {
    final response = await _dio.get(ApiConstants.resumeProgress);
    return response.data['data'] ?? 0;
  }

  // Education
  Future<List<Education>> getEducationList() async {
    final response = await _dio.get(ApiConstants.education);
    return (response.data['data'] as List<dynamic>)
        .map((e) => Education.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<Education> addEducation(Map<String, dynamic> data) async {
    final response = await _dio.post(ApiConstants.education, data: data);
    return Education.fromJson(response.data['data']);
  }

  Future<Education> updateEducation(int id, Map<String, dynamic> data) async {
    final response = await _dio.put('${ApiConstants.education}/$id', data: data);
    return Education.fromJson(response.data['data']);
  }

  Future<void> deleteEducation(int id) async {
    await _dio.delete('${ApiConstants.education}/$id');
  }

  // Work Experience
  Future<List<WorkExperience>> getWorkExperienceList() async {
    final response = await _dio.get(ApiConstants.experience);
    return (response.data['data'] as List<dynamic>)
        .map((e) => WorkExperience.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<WorkExperience> addWorkExperience(Map<String, dynamic> data) async {
    final response = await _dio.post(ApiConstants.experience, data: data);
    return WorkExperience.fromJson(response.data['data']);
  }

  Future<WorkExperience> updateWorkExperience(int id, Map<String, dynamic> data) async {
    final response = await _dio.put('${ApiConstants.experience}/$id', data: data);
    return WorkExperience.fromJson(response.data['data']);
  }

  Future<void> deleteWorkExperience(int id) async {
    await _dio.delete('${ApiConstants.experience}/$id');
  }

  // Skills
  Future<List<UserSkill>> getSkills() async {
    final response = await _dio.get(ApiConstants.userSkills);
    return (response.data['data'] as List<dynamic>)
        .map((e) => UserSkill.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<UserSkill>> saveSkills(List<String> skills) async {
    final response = await _dio.put(ApiConstants.userSkills, data: {'skills': skills});
    return (response.data['data'] as List<dynamic>)
        .map((e) => UserSkill.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // Self Introduction
  Future<SelfIntroduction?> getIntroduction() async {
    final response = await _dio.get(ApiConstants.introduction);
    if (response.data['data'] == null) return null;
    return SelfIntroduction.fromJson(response.data['data']);
  }

  Future<SelfIntroduction> saveIntroduction(String content) async {
    final response = await _dio.put(ApiConstants.introduction, data: {'content': content});
    return SelfIntroduction.fromJson(response.data['data']);
  }
}
