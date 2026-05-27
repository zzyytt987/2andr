class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'http://10.0.2.2:8080/api/v1';

  // Auth
  static const String loginPassword = '/auth/login/password';
  static const String loginSms = '/auth/login/sms';
  static const String register = '/auth/register';
  static const String sendSms = '/auth/sms/send';
  static const String refreshToken = '/auth/refresh';
  static const String logout = '/auth/logout';

  // Jobs
  static const String jobs = '/jobs';
  static const String jobsRecommended = '/jobs/recommended';
  static const String jobsLatest = '/jobs/latest';
  static const String jobsNearby = '/jobs/nearby';
  static const String jobsSearch = '/jobs/search';
  static const String banners = '/banners';

  static String jobDetail(int id) => '/jobs/$id';

  // User
  static const String userMe = '/users/me';
  static const String userAvatar = '/users/me/avatar';
  static const String userPassword = '/users/me/password';

  // Resume
  static const String resumeMe = '/resumes/me';
  static const String resumeProgress = '/resumes/me/progress';
  static const String education = '/resumes/me/education';
  static const String experience = '/resumes/me/experience';
  static const String userSkills = '/resumes/me/skills';
  static const String introduction = '/resumes/me/introduction';

  // Favorites
  static const String favorites = '/favorites';
  static const String favoritesCheck = '/favorites/check';

  // Applications
  static const String applications = '/applications';
  static const String applicationsStats = '/applications/stats';

  // Messages
  static const String conversations = '/conversations';
  static String conversationMessages(int id) => '/conversations/$id/messages';
  static String conversationRead(int id) => '/conversations/$id/read';

  // Search
  static const String searchHot = '/search/hot';
  static const String searchHistory = '/search/history';

  // Notifications
  static const String notifications = '/notifications';
  static const String unreadCount = '/notifications/unread-count';

  // Upload
  static const String uploadImage = '/upload/image';
  static const String uploadResume = '/upload/resume-file';

  // Cities
  static const String cities = '/cities';
  static const String hotCities = '/cities/hot';
}
