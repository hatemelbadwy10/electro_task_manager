import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../core/config/extensions/all_extensions.dart';
import '../../../../../../../core/config/theme/app_colors.dart';
import '../../../../../../../core/utils/validators.dart';
import '../../../../../../../core/widgets/buttons/custom_button.dart';
import '../../../../../../../core/widgets/custom_surface.dart';
import '../../../../../../../core/widgets/custom_text_field.dart';
import '../../../../../../../core/resources/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../controller/tasks_cubit.dart';

class AddTaskBottomSheet extends StatefulWidget {
  const AddTaskBottomSheet({super.key});

  @override
  State<AddTaskBottomSheet> createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  String _priority = 'medium';

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 18,
          bottom: MediaQuery.viewInsetsOf(context).bottom + 16,
        ),
        child: CustomSurface(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 44,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.outline,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  LocaleKeys.tasks_add_new_task.tr(),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _titleController,
                  label: LocaleKeys.tasks_task_title.tr(),
                  hint: LocaleKeys.tasks_task_title_hint.tr(),
                  icon: Icons.task_alt_rounded,
                  textInputAction: TextInputAction.done,
                  validator: (value) => Validator.required(value, LocaleKeys.tasks_task_title.tr()),
                  onFieldSubmitted: (_) => _submit(context),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    _PriorityOption(
                      label: LocaleKeys.tasks_priority_low.tr(),
                      value: 'low',
                      selectedValue: _priority,
                      color: AppColors.success,
                      onChanged: _setPriority,
                    ).expand(),
                    8.gap,
                    _PriorityOption(
                      label: LocaleKeys.tasks_priority_medium.tr(),
                      value: 'medium',
                      selectedValue: _priority,
                      color: AppColors.warning,
                      onChanged: _setPriority,
                    ).expand(),
                    8.gap,
                    _PriorityOption(
                      label: LocaleKeys.tasks_priority_high.tr(),
                      value: 'high',
                      selectedValue: _priority,
                      color: AppColors.error,
                      onChanged: _setPriority,
                    ).expand(),
                  ],
                ),
                const SizedBox(height: 18),
                CustomButton(
                  label: LocaleKeys.tasks_add_task.tr(),
                  icon: Icons.add_rounded,
                  onPressed: () => _submit(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _setPriority(String priority) {
    setState(() => _priority = priority);
  }

  void _submit(BuildContext context) {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;
    context.read<TasksCubit>().addTask(
      title: _titleController.text.trim(),
      priority: _priority,
    );
    Navigator.of(context).pop();
  }
}

class _PriorityOption extends StatelessWidget {
  final String label;
  final String value;
  final String selectedValue;
  final Color color;
  final ValueChanged<String> onChanged;

  const _PriorityOption({
    required this.label,
    required this.value,
    required this.selectedValue,
    required this.color,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = value == selectedValue;
    return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.circle_outlined,
              size: 16,
              color: isSelected ? color : AppColors.textMuted,
            ),
            6.gap,
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: isSelected ? color : AppColors.textMuted,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        )
        .paddingSymmetric(10, 12)
        .onTap(() => onChanged(value), borderRadius: 14.borderRadius)
        .setContainerToView(
          radius: 14,
          color: isSelected
              ? color.withValues(alpha: 0.1)
              : AppColors.surfaceContainer.withValues(alpha: 0.46),
          borderColor: isSelected ? color.withValues(alpha: 0.35) : null,
        );
  }
}
