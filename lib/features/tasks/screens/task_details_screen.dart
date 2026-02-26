import 'package:flutter/material.dart';
import 'package:sanitrax_staff_app/core/constants/colors.dart';
import 'package:sanitrax_staff_app/features/tasks/models/task_model.dart';

class TaskDetailsScreen extends StatefulWidget {
  final ToiletTask task;
  const TaskDetailsScreen({super.key, required this.task});

  @override
  State<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: const SizedBox(), // Completely blank page
    );
  }
}