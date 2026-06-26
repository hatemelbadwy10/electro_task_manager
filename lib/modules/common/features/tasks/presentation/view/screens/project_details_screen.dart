import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../core/config/theme/app_colors.dart';
import '../../../../../../../core/utils/toaster_utils.dart';
import '../../../../../../../core/utils/project_status_resolver.dart';
import '../../../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../../../core/widgets/custom_empty_view.dart';
import '../../../../../../../core/widgets/custom_error_view.dart';
import '../../../../../../../core/widgets/custom_loading.dart';
import '../../../../../../../core/widgets/custom_page.dart';
import '../../../../../../../core/widgets/custom_surface.dart';
import '../../../../../../../core/widgets/list_animator.dart';
import '../../../../../../../core/resources/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../projects/data/models/project_model.dart';
import '../../../data/models/task_model.dart';
import '../../controller/tasks_cubit.dart';
import '../../controller/tasks_state.dart';
import '../widgets/add_task_bottom_sheet.dart';
import '../widgets/task_card.dart';

class ProjectDetailsScreen extends StatefulWidget {
  final String projectId;
  final ProjectModel? project;
  final void Function(ProjectModel project)? onProjectSaved;

  const ProjectDetailsScreen({
    super.key,
    required this.projectId,
    this.project,
    this.onProjectSaved,
  });

  @override
  State<ProjectDetailsScreen> createState() => _ProjectDetailsScreenState();
}

class _ProjectDetailsScreenState extends State<ProjectDetailsScreen> {
  ProjectModel? _resolvedProject;

  @override
  void initState() {
    super.initState();
    _resolvedProject = widget.project;
  }

  void _syncProjectFromTasks(List<TaskModel> tasks) {
    final project = _resolvedProject;
    if (project == null) return;

    final nextProject = ProjectStatusResolver.fromTasks(project, tasks);
    final hasChanged =
        project.status != nextProject.status ||
        project.summary.total != nextProject.summary.total ||
        project.summary.done != nextProject.summary.done ||
        project.summary.pending != nextProject.summary.pending ||
        project.summary.inProgress != nextProject.summary.inProgress;

    if (hasChanged) {
      setState(() {
        _resolvedProject = nextProject;
      });
      widget.onProjectSaved?.call(nextProject);
    }
  }

  @override
  Widget build(BuildContext context) {
    context.locale; // Force rebuild on locale change
    return Scaffold(
      appBar: CustomAppBar(
        title: _resolvedProject?.title ?? LocaleKeys.projects_project.tr(),
      ),
      body: CustomPage(
        child: BlocConsumer<TasksCubit, TasksState>(
          listener: (context, state) {
            if (state.status == TasksStatus.failure && state.message != null) {
              Toaster.error(state.message!);
            }
            _syncProjectFromTasks(state.tasks);
          },
          builder: (context, state) {
            if (state.status == TasksStatus.loading ||
                state.status == TasksStatus.initial) {
              return CustomLoading(message: LocaleKeys.common_loading.tr());
            }

            if (state.status == TasksStatus.failure && state.tasks.isEmpty) {
              return CustomErrorView(
                message: state.message ?? LocaleKeys.tasks_could_not_load.tr(),
                onRetry: context.read<TasksCubit>().loadTasks,
              );
            }

            final content = <Widget>[
              if (_resolvedProject != null) ...[
                CustomSurface(
                  child: Text(
                    _resolvedProject!.description,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(color: AppColors.textMuted),
                  ),
                ),
                const SizedBox(height: 14),
              ],
              if (state.tasks.isEmpty)
                SizedBox(
                  height: 420,
                  child: CustomEmptyView(
                    title: LocaleKeys.tasks_no_tasks_yet.tr(),
                    subtitle: LocaleKeys.tasks_no_tasks_desc.tr(),
                    icon: Icons.task_alt_rounded,
                  ),
                )
              else
                ...state.tasks.map(
                  (task) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: TaskCard(task: task),
                  ),
                ),
            ];

            return RefreshIndicator.adaptive(
              onRefresh: context.read<TasksCubit>().refreshTasks,
              child: ListAnimator(
                customPadding: const EdgeInsets.fromLTRB(16, 4, 16, 96),
                verticalOffset: 26,
                horizontalOffset: 22,
                data: content,
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: Text(LocaleKeys.tasks_add_task.tr()),
        onPressed: () {
          showModalBottomSheet<void>(
            context: context,
            isScrollControlled: true,
            useSafeArea: true,
            builder: (_) => BlocProvider.value(
              value: context.read<TasksCubit>(),
              child: const AddTaskBottomSheet(),
            ),
          );
        },
      ),
    );
  }
}
