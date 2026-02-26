import 'dart:io';
import 'dart:async';
import 'dart:developer' as dev;

import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:sanitrax_staff_app/core/constants/colors.dart';
import 'package:sanitrax_staff_app/features/tasks/models/task_model.dart';

class TaskDetailsScreen extends StatefulWidget {
  final ToiletTask task;
  const TaskDetailsScreen({super.key, required this.task});

  @override
  State<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  final Map<String, File?> _beforeImages = {
    "Floor": null,
    "Urinal": null,
    "Toilet": null,
    "Basin": null,
    "Other": null,
  };

  final Map<String, File?> _afterImages = {
    "Floor": null,
    "Urinal": null,
    "Toilet": null,
    "Basin": null,
    "Other": null,
  };

  final ImagePicker _picker = ImagePicker();

  Timer? _timer;
  int _secondsElapsed = 0;
  bool isTimerStarted = false;

  DateTime? startTime;
  DateTime? endTime;

  final TextEditingController _remarksController = TextEditingController();

  final List<Map<String, dynamic>> _checklist = [
    {"task": "Sanitize Toilet Seats", "isDone": false},
    {"task": "Clean Urinals & Bowls", "isDone": false},
    {"task": "Refill Soap Dispensers", "isDone": false},
    {"task": "Dry the Floor", "isDone": false},
    {"task": "Check Water Supply", "isDone": false},
    {"task": "Clean Mirrors & Sinks", "isDone": false},
    {"task": "Empty Trash Bins", "isDone": false},
  ];

  @override
  void dispose() {
    _timer?.cancel();
    _remarksController.dispose();
    super.dispose();
  }

  // ======================
  // TIMER
  // ======================
  void _toggleTimer() {
    if (!isTimerStarted) {
      setState(() {
        isTimerStarted = true;
        startTime = DateTime.now();
      });

      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() => _secondsElapsed++);
      });
    }
  }

  String _formatDuration(int totalSeconds) {
    int minutes = totalSeconds ~/ 60;
    int seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  String _formatDateTime(DateTime? dt) {
    if (dt == null) return "N/A";
    return "${dt.hour}:${dt.minute.toString().padLeft(2, '0')}";
  }

  // ======================
  // UI
  // ======================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        title: Text(
          "Duty: ${widget.task.id}",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFullInfoCard(),
            const SizedBox(height: 20),

            _buildCompactPhotoRow("1. Before Photos", _beforeImages, true),

            const SizedBox(height: 20),
            _buildTimerSection(),

            const SizedBox(height: 20),
            Text(
              "2. Checklist (Min. 1 required)",
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),

            ..._checklist.map(_buildChecklistItem),

            const SizedBox(height: 20),

            if (isTimerStarted)
              _buildCompactPhotoRow("3. After Photos", _afterImages, false),

            const SizedBox(height: 24),

            Text(
              "Remarks / Issues / Material Needed",
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: _remarksController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: "e.g. Broken flush, need soap...",
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 40),
            _buildBottomActionButton(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // ======================
  // HEADER CARD
  // ======================
  Widget _buildFullInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.task.id,
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  widget.task.priority.name.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          Text(
            widget.task.area, //?? "Unknown Area",
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          Text(
            widget.task.ward, // ?? "",
            style: const TextStyle(color: Colors.white70),
          ),

          const Divider(color: Colors.white24, height: 24),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _infoTile(
                Icons.access_time,
                "Due: ${_formatDateTime(widget.task.dueAt)}",
              ),
              _infoTile(Icons.star, "Rating: 4.8"),
              _infoTile(Icons.location_on, "Zone: 04"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoTile(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.amber, size: 14),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(color: Colors.white, fontSize: 11)),
      ],
    );
  }

  // ======================
  // PHOTO GRID
  // ======================
  Widget _buildCompactPhotoRow(
    String title,
    Map<String, File?> imageMap,
    bool isBefore,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: imageMap.keys.map((category) {
            File? image = imageMap[category];
            bool isUploaded = image != null;

            return Column(
              children: [
                GestureDetector(
                  onTap: () => _showImageSourceOptions(category, isBefore),
                  child: Container(
                    width: (MediaQuery.of(context).size.width - 80) / 5,
                    height: (MediaQuery.of(context).size.width - 80) / 5,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isUploaded
                            ? AppColors.accent
                            : AppColors.primary.withValues(alpha: 0.15),
                      ),
                      image: isUploaded
                          ? DecorationImage(
                              image: FileImage(image),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: isUploaded
                        ? const Icon(Icons.check, color: Colors.white, size: 16)
                        : Icon(
                            Icons.add_a_photo_outlined,
                            size: 18,
                            color: AppColors.primary.withValues(alpha: 0.4),
                          ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  category,
                  style: const TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }

  // ======================
  // TIMER UI
  // ======================
  Widget _buildTimerSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Cleaning Duration",
                style: TextStyle(fontSize: 11, color: Colors.grey),
              ),
              Text(
                _formatDuration(_secondsElapsed),
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: isTimerStarted ? null : _toggleTimer,
            style: ElevatedButton.styleFrom(
              backgroundColor: isTimerStarted
                  ? Colors.grey[200]
                  : AppColors.primary,
            ),
            child: Text(isTimerStarted ? "Running..." : "Start Timer"),
          ),
        ],
      ),
    );
  }

  Widget _buildChecklistItem(Map<String, dynamic> item) {
    return CheckboxListTile(
      value: item['isDone'],
      onChanged: (val) => setState(() => item['isDone'] = val),
      title: Text(item['task'], style: const TextStyle(fontSize: 13)),
      activeColor: AppColors.primary,
      dense: true,
      controlAffinity: ListTileControlAffinity.leading,
    );
  }

  // ======================
  // COMPLETE BUTTON
  // ======================
  Widget _buildBottomActionButton() {
    bool hasBefore = _beforeImages.values.any((e) => e != null);
    bool hasAfter = _afterImages.values.any((e) => e != null);
    bool atLeastOneChecked = _checklist.any((e) => e['isDone']);

    bool canClick =
        hasBefore && hasAfter && isTimerStarted && atLeastOneChecked;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: canClick
            ? () {
                endTime = DateTime.now();
                dev.log("Task completed for ${widget.task.id}");
                Navigator.pop(context);
              }
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: canClick ? AppColors.accent : Colors.grey[300],
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: Text(
          "COMPLETE MISSION",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  // ======================
  // IMAGE PICKER
  // ======================
  Future<void> _showImageSourceOptions(String category, bool isBefore) async {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera),
              title: const Text('Camera'),
              onTap: () {
                Navigator.pop(context);
                _pickTaskImage(category, ImageSource.camera, isBefore);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickTaskImage(category, ImageSource.gallery, isBefore);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickTaskImage(
    String category,
    ImageSource source,
    bool isBefore,
  ) async {
    final XFile? pickedFile = await _picker.pickImage(
      source: source,
      imageQuality: 50,
    );

    if (pickedFile != null) {
      setState(() {
        if (isBefore) {
          _beforeImages[category] = File(pickedFile.path);
        } else {
          _afterImages[category] = File(pickedFile.path);
        }
      });
    }
  }
}
