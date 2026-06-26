import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../core/config/router/app_route.dart';
import '../../../../../../../core/config/router/route_manager.dart';
import '../../../../../../../core/config/theme/app_colors.dart';
import '../../../../../../../core/utils/toaster_utils.dart';
import '../../../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../../../core/widgets/custom_empty_view.dart';
import '../../../../../../../core/widgets/custom_error_view.dart';
import '../../../../../../../core/widgets/custom_loading.dart';
import '../../../../../../../core/widgets/custom_page.dart';
import '../../../../../../../core/widgets/list_animator.dart';
import '../../../../../../../core/resources/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../controller/projects_cubit.dart';
import '../../controller/projects_state.dart';
import '../widgets/add_project_bottom_sheet.dart';
import '../widgets/project_card.dart';
import '../../../../tasks/presentation/args/project_details_args.dart';

class ProjectsHomeScreen extends StatelessWidget {
  const ProjectsHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.locale; // Force rebuild on locale change
    return Scaffold(
      appBar: CustomAppBar(
        title: LocaleKeys.projects_title.tr(),
        showBack: false,
        actions: [
          CustomIconButton(
            tooltip: LocaleKeys.profile_title.tr(),
            onTap: AppRoutes.profile.push,
            icon: Icons.person_outline_rounded,
          ),
        ],
      ),
      body: CustomPage(
        child: BlocConsumer<ProjectsCubit, ProjectsState>(
          listener: (context, state) {
            if (state.status == ProjectsStatus.failure &&
                state.message != null) {
              Toaster.error(state.message!);
            }
          },
          builder: (context, state) {
            if (state.status == ProjectsStatus.loading ||
                state.status == ProjectsStatus.initial) {
              return CustomLoading(message: LocaleKeys.common_loading.tr());
            }

            if (state.status == ProjectsStatus.failure) {
              return CustomErrorView(
                message:
                    state.message ?? LocaleKeys.projects_could_not_load.tr(),
                onRetry: context.read<ProjectsCubit>().loadProjects,
              );
            }

            return RefreshIndicator.adaptive(
              onRefresh: context.read<ProjectsCubit>().refreshProjects,
              child: state.projects.isEmpty
                  ? SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: SizedBox(
                        height: 520,
                        child: CustomEmptyView(
                          title: LocaleKeys.projects_no_projects_yet.tr(),
                          subtitle: LocaleKeys.projects_no_projects_desc.tr(),
                          icon: Icons.folder_open_rounded,
                        ),
                      ),
                    )
                  : ListAnimator(
                      customPadding: const EdgeInsets.fromLTRB(18, 12, 18, 112),
                      verticalOffset: 34,
                      horizontalOffset: 24,
                      data: List.generate(state.projects.length, (index) {
                        final project = state.projects[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 18),
                          child: ProjectCard(
                            project: project,
                            onDelete: () => context
                                .read<ProjectsCubit>()
                                .deleteProject(project.id),
                            onTap: () {
                              AppRoutes.projectDetails.push(
                                params: {'projectId': project.id},
                                extra: ProjectDetailsArgs(
                                  project: project,
                                  onProjectSaved: (projectModel) {
                                    context.read<ProjectsCubit>().syncProject(
                                      projectModel,
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        );
                      }),
                    ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showModalBottomSheet<void>(
            context: context,
            isScrollControlled: true,
            useSafeArea: true,
            builder: (_) => BlocProvider.value(
              value: context.read<ProjectsCubit>(),
              child: const AddProjectBottomSheet(),
            ),
          );
        },
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: Text(LocaleKeys.projects_project.tr()),
      ),
    );
  }
}
