class TaskModel {
  final String id;
  final String projectId;
  final String title;
  final String status;
  final String priority;
  final DateTime? createdAt;

  const TaskModel({
    required this.id,
    required this.projectId,
    required this.title,
    required this.status,
    required this.priority,
    this.createdAt,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'].toString(),
      projectId: (json['projectId'] ?? json['project_id']).toString(),
      title: json['title']?.toString() ?? '',
      status: json['status']?.toString() ?? 'pending',
      priority: json['priority']?.toString() ?? 'medium',
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? ''),
    );
  }
}
