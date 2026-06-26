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
import '../../controller/projects_cubit.dart';
import '../../controller/projects_state.dart';
import '../widgets/add_project_bottom_sheet.dart';
import '../widgets/project_card.dart';

class ProjectsHomeScreen extends StatelessWidget {
  const ProjectsHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Projects',
        showBack: false,
        actions: [
          CustomIconButton(
            tooltip: 'Profile',
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
              return const CustomLoading(message: 'Loading projects...');
            }

            if (state.status == ProjectsStatus.failure) {
              return CustomErrorView(
                message: state.message ?? 'Could not load projects',
                onRetry: context.read<ProjectsCubit>().loadProjects,
              );
            }

            return RefreshIndicator.adaptive(
              onRefresh: context.read<ProjectsCubit>().refreshProjects,
              child: state.projects.isEmpty
                  ? const SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: SizedBox(
                        height: 520,
                        child: CustomEmptyView(
                          title: 'No projects yet',
                          subtitle:
                              'Projects will appear here when the API returns data.',
                          icon: Icons.folder_open_rounded,
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(18, 12, 18, 112),
                      itemBuilder: (context, index) {
                        final project = state.projects[index];
                        return ProjectCard(
                          project: project,
                          onTap: () => AppRoutes.projectDetails.push(
                            params: {'projectId': project.id},
                            extra: project,
                          ),
                        );
                      },
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 18),
                      itemCount: state.projects.length,
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
        label: const Text('Project'),
      ),
    );
  }
}
