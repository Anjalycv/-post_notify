import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/notifications/domain/entities/notification_payload.dart';
import 'features/notifications/presentation/cubit/notification_cubit.dart';
import 'features/notifications/presentation/handlers/notification_navigation_handler.dart';
import 'injection_container.dart';

class App extends StatefulWidget {
  final NotificationPayload? launchPayload;
  const App({super.key, this.launchPayload});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final NotificationNavigationHandler _handler;

  @override
  void initState() {
    super.initState();
    _handler = sl<NotificationNavigationHandler>()
      ..start(launchPayload: widget.launchPayload);
  }

  @override
  void dispose() {
    _handler.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: sl<NotificationCubit>(),
      child: MaterialApp(
        title: 'Posts',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        navigatorKey: AppRouter.navigatorKey,
        initialRoute: AppRouter.home,
        onGenerateRoute: AppRouter.onGenerateRoute,
      ),
    );
  }
}
