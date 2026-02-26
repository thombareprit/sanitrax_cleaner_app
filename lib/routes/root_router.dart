import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../features/auth/providers/auth_provider.dart';
import '../features/auth/screens/welcome_screen.dart';
import '../features/main_wrapper.dart';

class RootRouter extends StatelessWidget {
  const RootRouter({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    // ⏳ While checking session
    if (auth.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // ❌ Not logged in
    if (!auth.isLoggedIn) {
      return const WelcomeScreen();
    }

    // ✅ Logged in
    return const MainWrapper();
  }
}
