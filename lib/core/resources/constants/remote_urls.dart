import 'dart:io';

class RemoteUrls {
  static const String _definedBaseUrl = String.fromEnvironment('API_BASE_URL');

  static String get baseUrl {
    if (_definedBaseUrl.isNotEmpty) return _definedBaseUrl;
    if (Platform.isIOS || Platform.isMacOS) return 'http://localhost:3000';
    return 'http://10.0.2.2:3000';
  }
}
