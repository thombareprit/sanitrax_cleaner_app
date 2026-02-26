enum TaskPriority { high, medium, low }

class ToiletTask {
  final String id;
  final String toiletId;
  final String title;
  final String description;

  final String area;
  final String ward;

  final TaskPriority priority;
  final String status;

  final DateTime assignedAt;
  final DateTime? dueAt;

  ToiletTask({
    required this.id,
    required this.toiletId,
    required this.title,
    required this.description,
    required this.area,
    required this.ward,
    required this.priority,
    required this.status,
    required this.assignedAt,
    required this.dueAt,
  });

  // 🔁 map from Appwrite document
  factory ToiletTask.fromMap(
    Map<String, dynamic> map,
    Map<String, dynamic> toilet,
  ) {
    return ToiletTask(
      id: map['\$id'],
      toiletId: map['toiletId'],
      title: map['taskTitle'] ?? "",
      description: map['taskDescription'] ?? "",
      priority: _mapPriority(map['priority']),
      status: map['status'] ?? "pending",
      assignedAt: DateTime.parse(map['\$createdAt']),
      dueAt: map['dueAt'] != null ? DateTime.parse(map['dueAt']) : null,
      area: toilet['area'] ?? '',
      ward: toilet['area'] ?? '',
    );
  }

  static TaskPriority _mapPriority(String? p) {
    switch (p) {
      case "high":
        return TaskPriority.high;
      case "medium":
        return TaskPriority.medium;
      default:
        return TaskPriority.low;
    }
  }
}
