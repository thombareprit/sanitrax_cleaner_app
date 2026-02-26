import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanitrax_staff_app/features/tasks/providers/task_provider.dart';
import 'package:sanitrax_staff_app/routes/app_routes.dart';
import 'package:sanitrax_staff_app/routes/root_router.dart';

import 'core/theme/app_theme.dart';
import 'features/auth/providers/auth_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()..checkSession()),
        ChangeNotifierProvider(create: (_) => TaskProvider()),
      ],
      child: const SanitrixApp(),
    ),
  );
}

class SanitrixApp extends StatelessWidget {
  const SanitrixApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const RootRouter(),
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}
