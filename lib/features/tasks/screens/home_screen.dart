import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:sanitrax_staff_app/features/tasks/screens/task_details_screen.dart';
import '../../../core/constants/colors.dart';

import '../../auth/providers/auth_provider.dart';
import '../providers/task_provider.dart';
import '../models/task_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    context.read<TaskProvider>().stop(); // stop polling
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: _buildHeader(context),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications_none_rounded,
              color: AppColors.lightTextPrimary,
            ),
            onPressed: () {},
          ),
          const SizedBox(width: 12),
        ],
      ),

      // ============================
      // REAL TASKS FROM APPWRITE
      // ============================
      body: Consumer2<AuthProvider, TaskProvider>(
        builder: (context, auth, taskProvider, _) {
          final cleanerId = auth.dbUser?.id ?? "";

          // start polling only once
          if (cleanerId.isNotEmpty) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              taskProvider.start(cleanerId);
            });
          }

          if (taskProvider.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (taskProvider.tasks.isEmpty) {
            return const Center(child: Text("No tasks assigned"));
          }

          return ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            itemCount: taskProvider.tasks.length,
            itemBuilder: (context, index) {
              final task = taskProvider.tasks[index];
              return _buildToiletCard(context: context, task: task);
            },
          );
        },
      ),
    );
  }

  // ============================
  // HEADER WITH USER NAME
  // ============================
  Widget _buildHeader(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final name = auth.dbUser?.name ?? "User";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.location_on_rounded,
              size: 14,
              color: AppColors.primary,
            ),
            const SizedBox(width: 4),
            Text(
              "Mumbai City",
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.lightTextSecondary,
              ),
            ),
          ],
        ),
        Text(
          "Hello, $name 👋",
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.lightTextPrimary,
          ),
        ),
      ],
    );
  }

  // ============================
  // TIME HELPERS
  // ============================
  String formatAssignedTime(DateTime time) {
    return "${time.hour}:${time.minute.toString().padLeft(2, '0')}";
  }

  String getDueText(DateTime? dueAt) {
    if (dueAt == null) return "N/A";

    final diff = dueAt.difference(DateTime.now());

    if (diff.isNegative) return "OVERDUE";

    return "${diff.inMinutes} min";
  }

  // ============================
  // TASK CARD UI
  // ============================
  Widget _buildToiletCard({
    required BuildContext context,
    required ToiletTask task,
  }) {
    bool isInProcess = task.status == "in_progress";
    bool isOverdue = task.dueAt != null && task.dueAt!.isBefore(DateTime.now());

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // top row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          task.id,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(width: 8),
                        _buildPriorityIndicator(task.priority),
                      ],
                    ),
                    _buildStatusBadge(task.status),
                  ],
                ),

                const SizedBox(height: 16),

                Text(
                  task.area,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.lightTextPrimary,
                  ),
                ),
                Text(
                  task.ward,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: AppColors.lightTextSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 16),
                const Divider(height: 1, color: AppColors.border),
                const SizedBox(height: 16),

                // time row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time_rounded,
                          size: 16,
                          color: AppColors.lightTextSecondary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          "Assigned at ${formatAssignedTime(task.assignedAt)}",
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: AppColors.lightTextSecondary,
                          ),
                        ),
                      ],
                    ),

                    Row(
                      children: [
                        Icon(
                          Icons.timer_outlined,
                          size: 16,
                          color: isOverdue
                              ? AppColors.danger
                              : AppColors.warning,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          isOverdue
                              ? "OVERDUE"
                              : "DUE IN: ${getDueText(task.dueAt)}",
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: isOverdue
                                ? AppColors.danger
                                : AppColors.warning,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          // bottom button
          Material(
            color: isInProcess ? AppColors.accent : AppColors.primary,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(24),
              bottomRight: Radius.circular(24),
            ),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TaskDetailsScreen(task: task),
                  ),
                );
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Center(
                  child: Text(
                    isInProcess ? "CONTINUE TASK" : "START CLEANING",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================
  // STATUS BADGE
  // ============================
  Widget _buildStatusBadge(String status) {
    bool isInProcess = status == "in_progress";

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isInProcess
            ? AppColors.warning.withValues(alpha: 0.1)
            : AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status.toUpperCase(),
        style: GoogleFonts.poppins(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: isInProcess ? AppColors.warning : AppColors.primary,
        ),
      ),
    );
  }

  // ============================
  // PRIORITY CHIP
  // ============================
  Widget _buildPriorityIndicator(TaskPriority priority) {
    Color color;
    String label;
    IconData icon;

    switch (priority) {
      case TaskPriority.high:
        color = AppColors.danger;
        label = "HIGH";
        icon = Icons.priority_high_rounded;
        break;
      case TaskPriority.medium:
        color = AppColors.warning;
        label = "MED";
        icon = Icons.remove_rounded;
        break;
      case TaskPriority.low:
        color = AppColors.accent;
        label = "LOW";
        icon = Icons.low_priority_rounded;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          Icon(icon, size: 10, color: color),
          const SizedBox(width: 2),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 9,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
