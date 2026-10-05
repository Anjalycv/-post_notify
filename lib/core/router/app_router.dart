import 'package:flutter/material.dart';
import '../../features/posts/presentation/pages/post_details_page.dart';
import '../../features/posts/presentation/pages/posts_page.dart';

class AppRouter {
  AppRouter._();

  static const String home = '/';
  static const String postDetails = '/post-details';

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case postDetails:
        final postId = settings.arguments as int;
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => PostDetailsPage(postId: postId),
        );
      case home:
      default:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const PostsPage(),
        );
    }
  }
}
