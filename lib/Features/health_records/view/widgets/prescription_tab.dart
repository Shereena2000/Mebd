import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../../Settings/utils/p_text_styles.dart';

class PrescriptionsTab extends StatelessWidget {
  const PrescriptionsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF8F9FA),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
         Lottie.asset(
              'assets/lottie/empty.json',
              width: 200,
              height: 200,
              fit: BoxFit.contain,
              repeat: true, 
            ),
          const SizedBox(height: 16),
      Text(
            "No prescriptions available",
            style:  PTextStyles.tittleMedium
          ),
          const SizedBox(height: 24),
          
        ],
      ),
    );
  }
}

