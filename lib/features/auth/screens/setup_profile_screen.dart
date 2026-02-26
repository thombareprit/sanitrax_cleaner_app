import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sanitrax_staff_app/features/main_wrapper.dart';
import '../../../core/constants/colors.dart';
import '../../../shared/widgets/custom_button.dart';
// Import Wrapper

class SetupProfileScreen extends StatelessWidget {
  const SetupProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        title: const Text("Complete Profile"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Personalize your workspace", 
              style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold)
            ),
            const SizedBox(height: 8),
            Text(
              "Tell us where you'll be working so we can sync your tasks.", 
              style: GoogleFonts.poppins(color: AppColors.lightTextSecondary)
            ),
            
            const SizedBox(height: 32),
            _buildField("Full Name", "Enter your name", Icons.person_outline),
            const SizedBox(height: 20),
            _buildField("Work City", "e.g. Mumbai", Icons.location_city_outlined),
            const SizedBox(height: 20),
            _buildField("Primary Area/Zone", "e.g. Marine Drive", Icons.map_outlined),
            
            const SizedBox(height: 40),
            CustomButton(
              text: "Finish Setup", 
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context, 
                  MaterialPageRoute(builder: (_) => const MainWrapper()),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(String label, String hint, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label, 
          style: GoogleFonts.poppins(
            fontSize: 13, 
            fontWeight: FontWeight.w600, 
            color: AppColors.primary
          )
        ),
        const SizedBox(height: 8),
        TextField(
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, size: 22),
          ),
        ),
      ],
    );
  }
}