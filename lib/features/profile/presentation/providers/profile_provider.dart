import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/user_repository.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) => UserRepositoryImpl());

final userProfileProvider = FutureProvider<UserProfile>((ref) {
  final authState = ref.watch(authProvider);
  if (authState.status != AuthStatus.authenticated) {
    throw Exception('未登录');
  }
  return ref.read(userRepositoryProvider).getProfile();
});
