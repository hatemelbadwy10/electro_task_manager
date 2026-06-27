import 'package:easy_localization/easy_localization.dart';

import '../../../../../../../core/resources/locale_keys.g.dart';
import '../../data/models/project_model.dart';

enum ProjectsFilter { all, active, pending, done }

extension ProjectsFilterX on ProjectsFilter {
  String label() {
    switch (this) {
      case ProjectsFilter.all:
        return LocaleKeys.projects_filter_all.tr();
      case ProjectsFilter.active:
        return LocaleKeys.projects_status_active.tr();
      case ProjectsFilter.pending:
        return LocaleKeys.projects_status_pending.tr();
      case ProjectsFilter.done:
        return LocaleKeys.projects_filter_completed.tr();
    }
  }

  bool matches(ProjectModel project) {
    switch (this) {
      case ProjectsFilter.all:
        return true;
      case ProjectsFilter.active:
        return project.status == 'inProgress';
      case ProjectsFilter.pending:
        return project.status == 'pending';
      case ProjectsFilter.done:
        return project.status == 'done';
    }
  }
}
