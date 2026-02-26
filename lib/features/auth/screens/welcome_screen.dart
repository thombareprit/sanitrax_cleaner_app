import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sanitrax_staff_app/features/auth/providers/auth_provider.dart';
// import 'package:sanitrax_staff_app/features/main_wrapper.dart';
import '../../../core/constants/colors.dart';
import '../../../shared/widgets/custom_button.dart';
import 'login_screen.dart';
import 'signup_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
    void initState() {
      super.initState();

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted) return;

        final auth = context.read<AuthProvider>();

        if (auth.isLoggedIn) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/main',
            (route) => false,
          );
        }
      });
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            width: double.infinity,
            child: Image.asset(
              "assets/images/welcome_wave.png",
              fit: BoxFit.cover,
              alignment: Alignment.bottomCenter,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Text(
                    "Elevating Urban\nHygiene Standards",
                    style: GoogleFonts.poppins(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: AppColors.lightTextPrimary,
                      height: 1.2,
                    ),
                  ),
                  const Spacer(),
                  CustomButton(
                    text: "Sign In",
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                    ),
                  ),
                  const SizedBox(height: 12),
                  CustomButton(
                    text: "Create Account",
                    isOutline: true,
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SignUpScreen()),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
