enum TaskPriority { high, medium, low }

class ToiletTask {
  final String id;
  final String area;
  final String ward;
  final String status;
  final String assignedTime;
  final String due;
  final TaskPriority priority; // New Field

  ToiletTask({
    required this.id,
    required this.area,
    required this.ward,
    required this.status,
    required this.assignedTime,
    required this.due,
    required this.priority,
  });
}

final List<ToiletTask> mockToiletTasks = [
  ToiletTask(
    id: "SN-TX-101",
    area: "Marine Drive",
    ward: "Ward No. 62",
    status: "In Process",
    assignedTime: "08:00 AM",
    due: "10 mins",
    priority: TaskPriority.high, // 🔥 Urgent
  ),
  ToiletTask(
    id: "SN-TX-104",
    area: "Gateway of India",
    ward: "Ward No. 04",
    status: "Assigned",
    assignedTime: "09:15 AM",
    due: "45 mins",
    priority: TaskPriority.medium,
  ),
  ToiletTask(
    id: "SN-TX-209",
    area: "Colaba Causeway",
    ward: "Ward No. 12",
    status: "Assigned",
    assignedTime: "10:00 AM",
    due: "Overdue",
    priority: TaskPriority.low,
  ),
  ToiletTask(
    id: "SN-TX-298",
    area: "Colaba Causeway 2",
    ward: "Ward No. 17",
    status: "Assigned",
    assignedTime: "10:00 AM",
    due: "Overdue",
    priority: TaskPriority.low,
  ),
];
