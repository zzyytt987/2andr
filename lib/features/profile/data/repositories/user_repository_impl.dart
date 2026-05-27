import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/user_remote_datasource.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource _remote = UserRemoteDataSource();

  @override
  Future<UserProfile> getProfile() => _remote.getProfile();

  @override
  Future<UserProfile> updateProfile(Map<String, dynamic> data) => _remote.updateProfile(data);

  @override
  Future<void> updateAvatar(String avatarUrl) => _remote.updateAvatar(avatarUrl);

  @override
  Future<void> changePassword(String oldPassword, String newPassword) =>
      _remote.changePassword(oldPassword, newPassword);

  @override
  Future<String> uploadImage(String filePath) => _remote.uploadImage(filePath);
}
