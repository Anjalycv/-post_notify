import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import 'core/network/network_info.dart';
import 'features/notifications/data/datasources/notification_local_data_source.dart';
import 'features/notifications/data/repositories/notification_repository_impl.dart';
import 'features/notifications/domain/repositories/notification_repository.dart';
import 'features/notifications/domain/usecases/get_launch_notification.dart';
import 'features/notifications/domain/usecases/observe_notification_taps.dart';
import 'features/notifications/domain/usecases/show_post_notification.dart';
import 'features/notifications/presentation/cubit/notification_cubit.dart';
import 'features/notifications/presentation/handlers/notification_navigation_handler.dart';
import 'features/posts/data/datasources/post_remote_data_source.dart';
import 'features/posts/data/repositories/post_repository_impl.dart';
import 'features/posts/domain/repositories/post_repository.dart';
import 'features/posts/domain/usecases/get_post_details.dart';
import 'features/posts/domain/usecases/get_posts.dart';
import 'features/posts/presentation/bloc/post_details/post_details_bloc.dart';
import 'features/posts/presentation/bloc/posts/posts_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ---------- External ----------
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => Connectivity());
  sl.registerLazySingleton(() => FlutterLocalNotificationsPlugin());

  // ---------- Core ----------
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  // ---------- Posts ----------
  sl.registerFactory(() => PostsBloc(getPosts: sl()));
  sl.registerFactory(() => PostDetailsBloc(getPostDetails: sl()));

  sl.registerLazySingleton(() => GetPosts(sl()));
  sl.registerLazySingleton(() => GetPostDetails(sl()));

  sl.registerLazySingleton<PostRepository>(
    () => PostRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );
  sl.registerLazySingleton<PostRemoteDataSource>(
    () => PostRemoteDataSourceImpl(sl()),
  );

  // ---------- Notifications ----------
  final notificationDataSource = NotificationLocalDataSource(sl());
  await notificationDataSource.init();
  sl.registerSingleton<NotificationLocalDataSource>(notificationDataSource);

  sl.registerLazySingleton<NotificationRepository>(
    () => NotificationRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => ShowPostNotification(sl()));
  sl.registerLazySingleton(() => ObserveNotificationTaps(sl()));
  sl.registerLazySingleton(() => GetLaunchNotification(sl()));

  sl.registerLazySingleton(() => NotificationCubit(showPostNotification: sl()));
  sl.registerLazySingleton(() => NotificationNavigationHandler(sl()));
}
