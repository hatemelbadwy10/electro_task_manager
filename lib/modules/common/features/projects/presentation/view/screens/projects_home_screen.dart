import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../core/config/extensions/all_extensions.dart';
import '../../../../../../../core/config/router/app_route.dart';
import '../../../../../../../core/config/router/route_manager.dart';
import '../../../../../../../core/config/theme/app_colors.dart';
import '../../../../../../../core/config/theme/app_colors_extension.dart';
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
import '../../controller/projects_filter.dart';
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

            return Column(
              children: [
                _ProjectsFilterBar(
                  selectedFilter: state.selectedFilter,
                  onChanged: context.read<ProjectsCubit>().changeFilter,
                  counts: {
                    for (final filter in ProjectsFilter.values)
                      filter: state.countFor(filter),
                  },
                ),
                Expanded(
                  child: RefreshIndicator.adaptive(
                    onRefresh: context.read<ProjectsCubit>().refreshProjects,
                    child: state.projects.isEmpty
                        ? SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: SizedBox(
                              height: 520,
                              child: CustomEmptyView(
                                title: LocaleKeys.projects_no_projects_yet.tr(),
                                subtitle: LocaleKeys.projects_no_projects_desc
                                    .tr(),
                                icon: Icons.folder_open_rounded,
                              ),
                            ),
                          )
                        : state.filteredProjects.isEmpty
                        ? SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: SizedBox(
                              height: 520,
                              child: CustomEmptyView(
                                title: LocaleKeys.projects_filter_empty.tr(),
                                subtitle: LocaleKeys.projects_filter_empty_desc
                                    .tr(),
                                icon: Icons.filter_alt_off_rounded,
                              ),
                            ),
                          )
                        : ListAnimator(
                            customPadding: const EdgeInsets.fromLTRB(
                              18,
                              12,
                              18,
                              112,
                            ),
                            verticalOffset: 34,
                            horizontalOffset: 24,
                            data: List.generate(state.filteredProjects.length, (
                              index,
                            ) {
                              final project = state.filteredProjects[index];
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
                                          context
                                              .read<ProjectsCubit>()
                                              .syncProject(projectModel);
                                        },
                                      ),
                                    );
                                  },
                                ),
                              );
                            }),
                          ),
                  ),
                ),
              ],
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

class _ProjectsFilterBar extends StatelessWidget {
  final ProjectsFilter selectedFilter;
  final ValueChanged<ProjectsFilter> onChanged;
  final Map<ProjectsFilter, int> counts;

  const _ProjectsFilterBar({
    required this.selectedFilter,
    required this.onChanged,
    required this.counts,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    const filters = ProjectsFilter.values;

    return SizedBox(
      height: 66,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(18, 4, 18, 10),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = filter == selectedFilter;
          final label = filter.label();
          final count = counts[filter] ?? 0;

          return AnimatedContainer(
            duration: extensionTransitionDuration,
            curve: Curves.easeOutCubic,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              gradient: isSelected
                  ? const LinearGradient(
                      colors: [AppColors.primary, AppColors.primaryContainer],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
              color: isSelected ? null : colors.cardSurface,
              border: Border.all(
                color: isSelected
                    ? Colors.white.withValues(alpha: 0.22)
                    : colors.cardBorder,
              ),
              boxShadow: [
                BoxShadow(
                  blurRadius: isSelected ? 24 : 18,
                  offset: const Offset(0, 10),
                  color: (isSelected ? AppColors.primary : Colors.black)
                      .withValues(alpha: isSelected ? 0.24 : 0.06),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: isSelected ? Colors.white : colors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                8.gap,
                AnimatedContainer(
                  duration: extensionTransitionDuration,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.white.withValues(alpha: 0.18)
                        : AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    '$count',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: isSelected ? Colors.white : AppColors.primary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ).paddingSymmetric(14, 10),
          ).onTap(
            () => onChanged(filter),
            borderRadius: BorderRadius.circular(18),
          );
        },
        separatorBuilder: (_, _) => 10.gap,
        itemCount: filters.length,
      ),
    );
  }
}
