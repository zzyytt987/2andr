import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../datasources/auth_local_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remote;
  final AuthLocalDataSource _local;

  AuthRepositoryImpl({
    required AuthRemoteDataSource remote,
    required AuthLocalDataSource local,
  })  : _remote = remote,
        _local = local;

  @override
  Future<User> loginWithPassword(String phone, String password) async {
    final data = await _remote.loginWithPassword(phone, password);
    final token = _remote.parseToken(data);
    final user = _remote.parseUser(data['user']);
    await _local.saveTokens(token.accessToken, token.refreshToken);
    return user;
  }

  @override
  Future<User> loginWithSms(String phone, String code) async {
    final data = await _remote.loginWithSms(phone, code);
    final token = _remote.parseToken(data);
    final user = _remote.parseUser(data['user']);
    await _local.saveTokens(token.accessToken, token.refreshToken);
    return user;
  }

  @override
  Future<User> register(String phone, String password) async {
    final data = await _remote.register(phone, password);
    final token = _remote.parseToken(data);
    final user = _remote.parseUser(data['user']);
    await _local.saveTokens(token.accessToken, token.refreshToken);
    return user;
  }

  @override
  Future<void> sendSmsCode(String phone, String type) async {
    await _remote.sendSms(phone, type);
  }

  @override
  Future<void> refreshToken() async {
    final refreshToken = await _local.getRefreshToken();
    if (refreshToken != null) {
      final data = await _remote.refreshToken(refreshToken);
      final token = _remote.parseToken(data);
      await _local.saveTokens(token.accessToken, token.refreshToken);
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _remote.logout();
    } catch (_) {}
    await _local.clearTokens();
  }

  @override
  Future<bool> isLoggedIn() async {
    return _local.isLoggedIn();
  }
}
