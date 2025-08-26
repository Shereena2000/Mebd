import 'package:flutter/material.dart';
import 'package:medb/Settings/constants/text_styles.dart';
import 'package:medb/Settings/utils/p_colors.dart';

class PTextStyles {
  static TextStyle get displaMedium => getTextStyle(
    color: PColors.black,
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );
  static TextStyle get bodyMedium => getTextStyle(
    color: PColors.black,
    fontSize: 13,
    fontWeight: FontWeight.normal,
  );
}
