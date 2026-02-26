import 'package:appwrite/appwrite.dart';
// import 'package:appwrite/models.dart';
import '../../../core/appwrite/appwrite_client.dart';
import '../../auth/models/user_model.dart';

class UserDbService {
  final Databases _db = AppwriteClient.databases;

  final String databaseId = "sanitrax_db";
  final String cleanersTable = "cleaners";
  final String supervisorsTable = "supervisors";

  // 🔥 FETCH USER BY EMAIL (FINAL)
  Future<UserModel?> getUserByEmail(String email) async {
    try {
      print("🔍 Searching DB user with email: $email");

      // ---------------- CLEANERS ----------------
      final cleaners = await _db.listDocuments(
        databaseId: databaseId,
        collectionId: cleanersTable,
        queries: [Query.equal("email", email)],
      );

      print("👷 cleaners found: ${cleaners.documents.length}");

      if (cleaners.documents.isNotEmpty) {
        print("✅ Matched CLEANER");
        return UserModel.fromMap(
          cleaners.documents.first.data,
          role: "cleaner",
        );
      }

      // ---------------- SUPERVISORS ----------------
      final supervisors = await _db.listDocuments(
        databaseId: databaseId,
        collectionId: supervisorsTable,
        queries: [Query.equal("email", email)],
      );

      print("🧑‍💼 supervisors found: ${supervisors.documents.length}");

      if (supervisors.documents.isNotEmpty) {
        print("✅ Matched SUPERVISOR");
        return UserModel.fromMap(
          supervisors.documents.first.data,
          role: "supervisor",
        );
      }

      print("❌ No DB user found for email");

      return null;
    } catch (e) {
      print("🔥 DB ERROR: $e");
      return null;
    }
  }
}
