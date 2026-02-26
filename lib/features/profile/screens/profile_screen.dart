import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sanitrax_staff_app/features/auth/providers/auth_provider.dart';
// import 'package:sanitrax_staff_app/routes/app_routes.dart';
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
      body: auth.isLoading
          ? const Center(child: CircularProgressIndicator())
          : user == null
          ? const Center(child: Text("User profile not found"))
          : Column(
              children: [
                _buildProfileHeader(user.name, user.averageRating ?? 4.5),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(20),
                    children: [
                      _buildInfoCard(
                        "Email Address",
                        authUser?.email ?? "-",
                        Icons.email_outlined,
                      ),
                      _buildInfoCard(
                        "Phone Number",
                        user.phone ?? "-",
                        Icons.phone_android_outlined,
                      ),
                      _buildInfoCard(
                        "Ward",
                        user.wardId,
                        Icons.location_city_outlined,
                      ),
                      _buildInfoCard(
                        "Role",
                        user.role.toUpperCase(),
                        Icons.badge_outlined,
                      ),
                      const SizedBox(height: 20),
                      _buildLogoutButton(context),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildProfileHeader(String name, double rating) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 60, bottom: 30),
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.white.withValues(alpha: 0.2),
            child: Text(
              name.isNotEmpty ? name[0].toUpperCase() : "U",
              style: GoogleFonts.poppins(
                fontSize: 32,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            name,
            style: GoogleFonts.poppins(
              fontSize: 22,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              5,
              (index) => Icon(
                index < rating.round()
                    ? Icons.star_rounded
                    : Icons.star_border_rounded,
                color: Colors.amber,
                size: 22,
              ),
            ),
          ),

          const SizedBox(height: 4),
          Text(
            "${rating.toStringAsFixed(1)} Service Rating",
            style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String label, String value, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 22),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: AppColors.lightTextSecondary,
                ),
              ),
              Text(
                value,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.lightTextPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return TextButton.icon(
      onPressed: () async {
        await Provider.of<AuthProvider>(context, listen: false).logout();

        if (!context.mounted) return;

        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      },
      icon: const Icon(Icons.logout_rounded, color: AppColors.danger),
      label: Text(
        "Logout Account",
        style: GoogleFonts.poppins(
          color: AppColors.danger,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
