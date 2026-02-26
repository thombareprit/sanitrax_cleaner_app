import 'package:flutter/material.dart';
import 'package:appwrite/models.dart';
// import 'package:provider/provider.dart';
// import 'package:sanitrax_staff_app/features/tasks/providers/task_provider.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';
import '../../tasks/services/user_db_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  final UserDbService _userDbService = UserDbService();

  User? _authUser;
  UserModel? _dbUser;

  bool _isLoading = false;

  User? get authUser => _authUser;
  UserModel? get dbUser => _dbUser;

  bool get isLoading => _isLoading;
  bool get isLoggedIn => _authUser != null;

  // =========================
  // INIT SESSION
  // =========================
  Future<void> checkSession() async {
    _isLoading = true;
    notifyListeners();

    _authUser = await _authService.getCurrentUser();

    if (_authUser != null) {
      _dbUser = await _userDbService.getUserByEmail(_authUser!.email);
    }

    _isLoading = false;
    notifyListeners();
  }

  // =========================
  // LOGIN
  // =========================
  Future<bool> login(String email, String password) async {
    try {
      _isLoading = true;
      notifyListeners();

      _authUser = await _authService.login(email: email, password: password);

      // 🔥 fetch cleaner/supervisor record
      _dbUser = await _userDbService.getUserByEmail(_authUser!.email);

      _isLoading = false;
      notifyListeners();

      return true;
    } catch (e) {
      debugPrint("⚠️ Login error: $e");
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // =========================
  // LOGOUT
  // =========================
  Future<void> logout() async {
    await _authService.logout();
    _authUser = null;
    _dbUser = null;

    notifyListeners();
  }
}
