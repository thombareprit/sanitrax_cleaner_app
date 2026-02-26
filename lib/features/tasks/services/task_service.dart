import 'package:appwrite/appwrite.dart';
import '../../../core/appwrite/appwrite_client.dart';
import '../models/task_model.dart';

class TaskService {
  final Databases _db = AppwriteClient.databases;

  final String databaseId = "sanitrax_db";
  final String taskTable = "cleaningtasks";
  final String toiletsTable = "toilets";

  // 🔥 GET TASKS FOR CLEANER
  Future<List<ToiletTask>> getTasksForCleaner(String cleanerId) async {
    try {
      final res = await _db.listDocuments(
        databaseId: databaseId,
        collectionId: taskTable,
        queries: [
          Query.equal("assignedTo", cleanerId),
          Query.orderDesc("\$createdAt"),
        ],
      );

      List<ToiletTask> tasks = [];

      for (var doc in res.documents) {
        // fetch toilet info
        final toiletDoc = await _db.getDocument(
          databaseId: databaseId,
          collectionId: toiletsTable,
          documentId: doc.data['toiletId'],
        );

        tasks.add(ToiletTask.fromMap(doc.data, toiletDoc.data));
      }

      // sort by priority
      tasks.sort(
        (a, b) => _priorityWeight(b.priority) - _priorityWeight(a.priority),
      );

      return tasks;
    } catch (e) {
      print("TASK FETCH ERROR: $e");
      return [];
    }
  }

  int _priorityWeight(TaskPriority p) {
    switch (p) {
      case TaskPriority.high:
        return 3;
      case TaskPriority.medium:
        return 2;
      case TaskPriority.low:
        return 1;
    }
  }
}
