import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/search/presentation/pages/search_page.dart';
import '../../features/job_detail/presentation/pages/job_detail_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/profile/presentation/pages/edit_profile_page.dart';
import '../../features/resume/presentation/pages/resume_page.dart';
import '../../features/favorites/presentation/pages/favorites_page.dart';
import '../../features/applications/presentation/pages/applications_page.dart';
import '../../features/messages/presentation/pages/messages_page.dart';
import '../../features/messages/presentation/pages/chat_detail_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../core/widgets/main_shell.dart';

final _authListenable = ValueNotifier<bool>(false);

final appRouterProvider = Provider<GoRouter>((ref) {
  ref.listen(authProvider, (_, next) {
    _authListenable.value = next.status == AuthStatus.authenticated;
  });

  return GoRouter(
    initialLocation: '/',
    refreshListenable: _authListenable,
    redirect: (context, state) {
      final authState = ref.read(authProvider);
      final isLoggedIn = authState.status == AuthStatus.authenticated;
      final isOnSplash = state.matchedLocation == '/';
      final isOnAuthPage = state.matchedLocation == '/login' ||
          state.matchedLocation == '/register';

      if (isOnSplash) return null;
      if (!isLoggedIn && !isOnAuthPage) return '/login';
      if (isLoggedIn && isOnAuthPage) return '/home';
      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        name: RouteNames.splash,
        builder: (_, __) => const SplashPage(),
      ),
      GoRoute(
        path: '/login',
        name: RouteNames.login,
        builder: (_, __) => const LoginPage(),
      ),
      GoRoute(
        path: '/register',
        name: RouteNames.register,
        builder: (_, __) => const RegisterPage(),
      ),
      ShellRoute(
        builder: (_, __, child) => MainShell(child: child),
        routes: [
          GoRoute(
            path: '/home',
            name: RouteNames.home,
            builder: (_, __) => const HomePage(),
          ),
          GoRoute(
            path: '/search',
            name: RouteNames.search,
            builder: (_, __) => const SearchPage(),
          ),
          GoRoute(
            path: '/messages',
            name: RouteNames.messages,
            builder: (_, __) => const MessagesPage(),
          ),
          GoRoute(
            path: '/profile',
            name: RouteNames.profile,
            builder: (_, __) => const ProfilePage(),
          ),
        ],
      ),
      GoRoute(
        path: '/job/:id',
        name: RouteNames.jobDetail,
        builder: (_, state) => JobDetailPage(
          jobId: int.tryParse(state.pathParameters['id'] ?? '0') ?? 0,
        ),
      ),
      GoRoute(
        path: '/profile/edit',
        name: RouteNames.editProfile,
        builder: (_, __) => const EditProfilePage(),
      ),
      GoRoute(
        path: '/resume',
        name: RouteNames.resume,
        builder: (_, __) => const ResumePage(),
      ),
      GoRoute(
        path: '/favorites',
        name: RouteNames.favorites,
        builder: (_, __) => const FavoritesPage(),
      ),
      GoRoute(
        path: '/applications',
        name: RouteNames.applications,
        builder: (_, __) => const ApplicationsPage(),
      ),
      GoRoute(
        path: '/messages/:conversationId',
        name: RouteNames.chatDetail,
        builder: (_, state) => ChatDetailPage(
          conversationId:
              int.tryParse(state.pathParameters['conversationId'] ?? '0') ?? 0,
        ),
      ),
      GoRoute(
        path: '/settings',
        name: RouteNames.settings,
        builder: (_, __) => const SettingsPage(),
      ),
    ],
  );
});
