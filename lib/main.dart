import 'package:flutter/material.dart';

import 'app.dart';
import 'core/usecase/usecase.dart';
import 'features/notifications/domain/usecases/get_launch_notification.dart';
import 'injection_container.dart' as di;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();

  final launch = await di.sl<GetLaunchNotification>()(const NoParams());
  final launchPayload = launch.fold((_) => null, (payload) => payload);

  runApp(App(launchPayload: launchPayload));
}
