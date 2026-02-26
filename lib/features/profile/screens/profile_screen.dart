import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanitrax_staff_app/features/auth/providers/auth_provider.dart';
import '../../../core/constants/colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final user = auth.dbUser;
    final authUser = auth.authUser;

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: const SizedBox(), // Blank page
    );
  }
}
