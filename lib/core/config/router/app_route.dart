class AppRoutes {
  static const BaseRoute splash = BaseRoute('splash', '/');
  static const BaseRoute login = BaseRoute('login', '/login');
  static const BaseRoute register = BaseRoute('register', '/register');
  static const BaseRoute projects = BaseRoute('projects', '/projects');
  static const BaseRoute projectDetails = BaseRoute(
    'projectDetails',
    '/projects/:projectId',
  );
  static const BaseRoute profile = BaseRoute('profile', '/profile');
}

class BaseRoute {
  final String name;
  final String path;

  const BaseRoute(this.name, this.path);
}
