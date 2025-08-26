import 'package:flutter/material.dart';
import 'package:medb/Settings/utils/p_text_styles.dart';
import '../../Settings/utils/p_colors.dart';

class AuthNavigationText extends StatelessWidget {
  final String text;
  final Color? textColor;
  final String buttonText;
  final VoidCallback onTap;
  const AuthNavigationText({
    super.key,
    required this.text,
    required this.buttonText,
    this.textColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(text, style: PTextStyles.bodyMedium),
        GestureDetector(
          onTap: onTap,
          child: Text(
            buttonText,
            style: PTextStyles.bodyMedium.copyWith(color: PColors.primaryColor,fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
