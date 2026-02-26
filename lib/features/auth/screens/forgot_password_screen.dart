import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/colors.dart';
import '../../../shared/widgets/custom_button.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.white),
        title: Text(
          "Reset Password",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Reusing the brand wave
            SizedBox(
              height: 240,
              width: double.infinity,
              child: Image.asset(
                "assets/images/welcome_wave.png",
                fit: BoxFit.cover,
                alignment: Alignment.bottomCenter,
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Forgot your password?",
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.lightTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Enter your registered email or phone. We will send you instructions to reset your password.",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: AppColors.lightTextSecondary,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Input Field
                  Text(
                    "Email or Phone",
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Enter your details",
                      hintStyle: const TextStyle(color: AppColors.lightTextSecondary),
                      prefixIcon: const Icon(Icons.mark_email_read_outlined),
                    ),
                  ),

                  const SizedBox(height: 32),

                  CustomButton(
                    text: "Send Reset Link",
                    onPressed: () {
                      // Show a snackbar or dialog to confirm
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Reset link sent successfully!")),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}