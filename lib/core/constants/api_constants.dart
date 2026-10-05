class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'https://jsonplaceholder.typicode.com';
  static const String postsEndpoint = '/posts';

  /// First load shows 15 posts, every following page adds 10, until 100.
  static const int initialPostsCount = 15;
  static const int pageSize = 10;
  static const int totalPosts = 100;

  static const Duration timeout = Duration(seconds: 15);
}
