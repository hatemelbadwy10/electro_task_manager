import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../modules/common/routes/common_router.dart';
import 'app_route.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

class RouteManager {
  static void configureRoutes() {
    BaseRouter.routes.clear();
    CommonRouter().registerRoutes();
    BaseRouter.configureRouter();
  }
}

abstract class BaseRouter {
  static final List<RouteBase> routes = [];
  static late GoRouter routerConfig;

  void registerRoutes();

  static void configureRouter() {
    routerConfig = GoRouter(
      navigatorKey: rootNavigatorKey,
      initialLocation: AppRoutes.splash.path,
      routes: List<RouteBase>.unmodifiable(routes),
    );
  }

  static void pop<T extends Object?>([T? result]) {
    if (rootNavigatorKey.currentState?.canPop() ?? false) {
      rootNavigatorKey.currentState?.pop(result);
      return;
    }
    routerConfig.pop(result);
  }
}

extension BaseRouteNavigation on BaseRoute {
  Future<T?> push<T extends Object?>({
    Object? extra,
    Map<String, String> params = const <String, String>{},
    Map<String, dynamic> queries = const <String, dynamic>{},
  }) {
    return BaseRouter.routerConfig.pushNamed(
      name,
      extra: extra,
      pathParameters: params,
      queryParameters: queries,
    );
  }

  void go({
    Object? extra,
    Map<String, String> params = const <String, String>{},
    Map<String, dynamic> queries = const <String, dynamic>{},
  }) {
    BaseRouter.routerConfig.goNamed(
      name,
      extra: extra,
      pathParameters: params,
      queryParameters: queries,
    );
  }
}
