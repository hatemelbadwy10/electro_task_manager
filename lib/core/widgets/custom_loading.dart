import 'package:flutter/material.dart';

import '../config/theme/app_colors.dart';
import '../resources/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

class CustomLoading extends StatelessWidget {
  final String message;

  const CustomLoading({super.key, this.message = 'Loading...'});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(color: AppColors.primary),
          const SizedBox(height: 12),
          Text(message == 'Loading...' ? LocaleKeys.common_loading.tr() : message),
        ],
      ),
    );
  }
}
