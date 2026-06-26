import '../resources/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

class Validator {
  const Validator._();

  static final RegExp _emailRegex = RegExp(
    r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$',
  );

  static String? required(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return LocaleKeys.validation_required.tr(args: [fieldName]);
    }
    return null;
  }

  static String? email(String? value) {
    final requiredError = required(value, LocaleKeys.auth_email.tr());
    if (requiredError != null) return requiredError;
    if (!_emailRegex.hasMatch(value!.trim())) {
      return LocaleKeys.validation_invalid_email.tr();
    }
    return null;
  }

  static String? password(String? value) {
    final requiredError = required(value, LocaleKeys.auth_password.tr());
    if (requiredError != null) return requiredError;
    if (value!.length < 6) {
      return LocaleKeys.validation_password_length.tr();
    }
    return null;
  }
}
