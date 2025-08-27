import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:medb/Settings/constants/sized_box.dart';
import 'package:medb/Settings/utils/p_colors.dart';
import 'package:medb/Settings/utils/p_text_styles.dart';

import '../../common_widgets/custom_appbar.dart';

class AppointmentScreen extends StatelessWidget {
  const AppointmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: "Appointments"),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/lottie/NurseHospital.json', 
              width: 200,
              height: 200,
              fit: BoxFit.contain,
              repeat: true, 
            ),
            SizeBoxH(8),
            Text("No appointsments found", style: PTextStyles.tittleMedium),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
         
        },
        label: Text(
          "Book Appointment",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: PColors.primaryColor,
          ),
        ),
        icon: Icon(Icons.add, color: PColors.primaryColor),
      ),
    );
  }
}

