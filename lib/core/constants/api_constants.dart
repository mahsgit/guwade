class ApiConstants {
  static const String baseUrl = 'https://buddy-of9y.onrender.com';

  // Auth endpoints
  static const String login = '/auth/login';
  static const String getProfile = '/auth/me';

  // Story endpoints
  static const String getStories = '/stories/my-stories';
  static const String getVocabulary = '/stories/my-vocabulary';

  // Headers
  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
  };

  static Map<String, String> authHeaders(String token) => {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };
}
