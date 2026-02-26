import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/colors.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        title: Text(
          "Work History",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
        ),
        centerTitle: false,
      ),
      body: const SizedBox(), // Blank body
    );
  }
}