import 'package:flutter/material.dart';
import 'package:medb/Settings/constants/text_styles.dart';
import 'package:medb/Settings/utils/p_colors.dart';

class PTextStyles {
  static TextStyle get displaMedium => getTextStyle(
    color: PColors.black,
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );
  static TextStyle get labelMedium => getTextStyle(
    color: PColors.black,
    fontSize: 18,
    fontWeight: FontWeight.w500,
  );
   static TextStyle get tittleMedium  => getTextStyle(
    color: PColors.teal,
    fontSize: 15,
    fontWeight: FontWeight.w500,
  );
  static TextStyle get labelSmall => getTextStyle(
    color: PColors.black,
    fontSize: 12,
    fontWeight: FontWeight.normal,
  );
  static TextStyle get bodySmall => getTextStyle(
    color: const Color.fromARGB(255, 13, 57, 234),
    fontSize: 12,
    fontWeight: FontWeight.w600,
  );
  static TextStyle get bodyMedium => getTextStyle(
    color: PColors.black,
    fontSize: 13,
    fontWeight: FontWeight.normal,
  );
}
