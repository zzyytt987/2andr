import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../../domain/entities/user_profile.dart';

class UserRemoteDataSource {
  final Dio _dio = DioClient.instance.dio;

  Future<UserProfile> getProfile() async {
    final response = await _dio.get(ApiConstants.userMe);
    return UserProfile.fromJson(response.data['data']);
  }

  Future<UserProfile> updateProfile(Map<String, dynamic> data) async {
    final response = await _dio.put(ApiConstants.userMe, data: data);
    return UserProfile.fromJson(response.data['data']);
  }

  Future<void> updateAvatar(String avatarUrl) async {
    await _dio.put(ApiConstants.userAvatar, queryParameters: {'avatarUrl': avatarUrl});
  }

  Future<void> changePassword(String oldPassword, String newPassword) async {
    await _dio.put(ApiConstants.userPassword, data: {
      'oldPassword': oldPassword,
      'newPassword': newPassword,
    });
  }

  Future<String> uploadImage(String filePath) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(filePath),
    });
    final response = await _dio.post(ApiConstants.uploadImage, data: formData);
    return response.data['data']['url'];
  }
}
