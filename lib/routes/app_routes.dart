import 'package:flutter/material.dart';

import '../features/auth/screens/login_screen.dart';
import '../features/auth/screens/welcome_screen.dart';
import '../features/tasks/screens/home_screen.dart';
import '../features/main_wrapper.dart';

class AppRoutes {
  static const String welcome = "/welcome";
  static const String login = "/login";
  static const String home = "/home";
  static const String main = "/main";

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case welcome:
        return MaterialPageRoute(builder: (_) => const WelcomeScreen());

      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());

      case main:
        return MaterialPageRoute(builder: (_) => const MainWrapper());

      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text("Route not found"))),
        );
    }
  }
}
