import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/resources/locale_keys.g.dart';

import '../../../../../../core/config/router/route_manager.dart';
import '../../../../../../core/config/service_locator/injection.dart';
import '../../../../../../core/config/theme/theme_controller.dart';
import '../../../../../../core/config/theme/theme_manager.dart';

class ElectroApp extends StatelessWidget {
  const ElectroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: sl<ThemeController>(),
      builder: (context, themeMode, _) {
        return MaterialApp.router(
          onGenerateTitle: (context) => LocaleKeys.app_name.tr(),
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          debugShowCheckedModeBanner: false,
          theme: ThemeManager.lightTheme,
          darkTheme: ThemeManager.darkTheme,
          themeMode: themeMode,
          routerConfig: BaseRouter.routerConfig,
        );
      },
    );
  }
}
