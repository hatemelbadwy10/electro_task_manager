class ProjectTaskSummary {
  final int total;
  final int done;
  final int pending;
  final int inProgress;

  const ProjectTaskSummary({
    required this.total,
    required this.done,
    required this.pending,
    required this.inProgress,
  });

  factory ProjectTaskSummary.fromJson(Map<String, dynamic>? json) {
    return ProjectTaskSummary(
      total: int.tryParse('${json?['total'] ?? 0}') ?? 0,
      done: int.tryParse('${json?['done'] ?? 0}') ?? 0,
      pending: int.tryParse('${json?['pending'] ?? 0}') ?? 0,
      inProgress: int.tryParse('${json?['inProgress'] ?? 0}') ?? 0,
    );
  }
}

class ProjectModel {
  final String id;
  final String title;
  final String description;
  final String status;
  final ProjectTaskSummary summary;

  const ProjectModel({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.summary,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['id'].toString(),
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      status: json['status']?.toString() ?? 'pending',
      summary: ProjectTaskSummary.fromJson(
        json['taskSummary'] is Map<String, dynamic>
            ? json['taskSummary'] as Map<String, dynamic>
            : null,
      ),
    );
  }
}
