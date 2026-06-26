import 'package:flutter/material.dart';

import '../../../../../../core/config/router/route_manager.dart';
import '../../../../../../core/config/theme/theme_manager.dart';

class ElectroApp extends StatelessWidget {
  const ElectroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Electro Task Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeManager.lightTheme,
      routerConfig: BaseRouter.routerConfig,
    );
  }
}
