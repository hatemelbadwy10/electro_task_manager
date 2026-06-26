import '../../../projects/data/models/project_model.dart';

class ProjectDetailsArgs {
  final ProjectModel? project;
  final void Function(ProjectModel project)? onProjectSaved;

  const ProjectDetailsArgs({this.project, this.onProjectSaved});
}
