import '../entities/user_profile.dart';

abstract class UserRepository {
  Future<UserProfile> getProfile();
  Future<UserProfile> updateProfile(Map<String, dynamic> data);
  Future<void> updateAvatar(String avatarUrl);
  Future<void> changePassword(String oldPassword, String newPassword);
  Future<String> uploadImage(String filePath);
}
