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
import '../../controller/projects_cubit.dart';

class AddProjectBottomSheet extends StatefulWidget {
  const AddProjectBottomSheet({super.key});

  @override
  State<AddProjectBottomSheet> createState() => _AddProjectBottomSheetState();
}

class _AddProjectBottomSheetState extends State<AddProjectBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _status = 'pending';

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
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
                18.gap,
                Text(
                  LocaleKeys.projects_add_new_project.tr(),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                16.gap,
                CustomTextField(
                  controller: _titleController,
                  label: LocaleKeys.projects_project_title.tr(),
                  hint: LocaleKeys.projects_project_title_hint.tr(),
                  icon: Icons.folder_open_rounded,
                  textInputAction: TextInputAction.next,
                  validator: (value) =>
                      Validator.required(value, LocaleKeys.projects_project_title.tr()),
                ),
                14.gap,
                CustomTextField(
                  controller: _descriptionController,
                  label: LocaleKeys.projects_description.tr(),
                  hint: LocaleKeys.projects_description_hint.tr(),
                  icon: Icons.notes_rounded,
                  maxLines: 3,
                  textInputAction: TextInputAction.newline,
                  keyboardType: TextInputType.multiline,
                  validator: (value) =>
                      Validator.required(value, LocaleKeys.projects_description.tr()),
                ),
                14.gap,
                Row(
                  children: [
                    _StatusOption(
                      label: LocaleKeys.projects_status_pending.tr(),
                      value: 'pending',
                      selectedValue: _status,
                      color: AppColors.warning,
                      onChanged: _setStatus,
                    ).expand(),
                    8.gap,
                    _StatusOption(
                      label: LocaleKeys.projects_status_active.tr(),
                      value: 'inProgress',
                      selectedValue: _status,
                      color: AppColors.secondary,
                      onChanged: _setStatus,
                    ).expand(),
                    8.gap,
                    _StatusOption(
                      label: LocaleKeys.projects_status_done.tr(),
                      value: 'done',
                      selectedValue: _status,
                      color: AppColors.success,
                      onChanged: _setStatus,
                    ).expand(),
                  ],
                ),
                18.gap,
                CustomButton(
                  label: LocaleKeys.projects_create_project.tr(),
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

  void _setStatus(String value) {
    setState(() => _status = value);
  }

  void _submit(BuildContext context) {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;
    context.read<ProjectsCubit>().createProject(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      status: _status,
    );
    Navigator.of(context).pop();
  }
}

class _StatusOption extends StatelessWidget {
  final String label;
  final String value;
  final String selectedValue;
  final Color color;
  final ValueChanged<String> onChanged;

  const _StatusOption({
    required this.label,
    required this.value,
    required this.selectedValue,
    required this.color,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = value == selectedValue;
    return Text(
          label,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: isSelected ? color : AppColors.textMuted,
            fontWeight: FontWeight.w800,
          ),
        )
        .paddingSymmetric(8, 12)
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
