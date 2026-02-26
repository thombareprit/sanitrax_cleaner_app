import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import '../../../core/appwrite/appwrite_client.dart';

class AuthService {
  final Account _account = AppwriteClient.account;

  // LOGIN
  Future<User?> login({required String email, required String password}) async {
    try {
      await _account.createEmailPasswordSession(
        email: email,
        password: password,
      );

      return await _account.get();
    } catch (e) {
      rethrow;
    }
  }

  // GET CURRENT USER
  Future<User?> getCurrentUser() async {
    try {
      return await _account.get();
    } catch (_) {
      return null;
    }
  }

  // LOGOUT
  Future<void> logout() async {
    await _account.deleteSession(sessionId: 'current');
  }
}
