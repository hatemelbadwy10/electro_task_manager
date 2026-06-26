import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/bloc_observer/app_bloc_observer.dart';
import 'core/config/router/route_manager.dart';
import 'core/config/service_locator/injection.dart';
import 'modules/common/features/app/presentation/view/electro_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  RouteManager.configureRoutes();
  Bloc.observer = AppBlocObserver();

  runApp(const ElectroApp());
}
