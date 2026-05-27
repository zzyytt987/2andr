import '../../../../core/storage/local_storage.dart';

class AuthLocalDataSource {
  Future<void> saveTokens(String accessToken, String refreshToken) async {
    await LocalStorage.setTokens(accessToken, refreshToken);
  }

  Future<void> clearTokens() async {
    await LocalStorage.clearTokens();
  }

  Future<bool> isLoggedIn() async {
    return LocalStorage.isLoggedIn();
  }

  Future<String?> getAccessToken() async {
    return LocalStorage.getAccessToken();
  }

  Future<String?> getRefreshToken() async {
    return LocalStorage.getRefreshToken();
  }
}
