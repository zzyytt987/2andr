import '../entities/user.dart';

abstract class AuthRepository {
  Future<User> loginWithPassword(String phone, String password);
  Future<User> loginWithSms(String phone, String code);
  Future<User> register(String phone, String password);
  Future<void> sendSmsCode(String phone, String type);
  Future<void> refreshToken();
  Future<void> logout();
  Future<bool> isLoggedIn();
}
