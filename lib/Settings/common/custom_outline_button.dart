import 'package:flutter/material.dart';

import '../constants/text_styles.dart';
import '../utils/p_colors.dart';



class CustomOutlineButton extends StatelessWidget {
  final String text;
  final double? width;
  final double? height;
  final double? borderRaduis;
    final Color? bgcolor;
  final Color? bordercolor;
  final Color? forgcolor;
  final double? padverticle;
  final double? padhorizondal;
  final Function() onPressed;
   final double? fontSize;
  const CustomOutlineButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.width,
    this.height,
    this.bordercolor,
    this.forgcolor,
    this.borderRaduis,
    this.padverticle,
    this.padhorizondal, this.bgcolor, this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.sizeOf(context);
    return ElevatedButton(
      style: OutlinedButton.styleFrom(
        backgroundColor:bgcolor??PColors.primaryColor,
        foregroundColor: forgcolor ?? PColors.primaryColor,
        // padding: EdgeInsets.symmetric(
        //     vertical: padverticle ?? 8, horizontal: padhorizondal ?? 16),
        fixedSize: Size(width ?? size.width - 32, height ?? 55),
        minimumSize: Size(width ?? size.width - 32, height ?? 55),
        maximumSize: Size(width ?? size.width - 32, height ?? 55),
        side: BorderSide(
          width: 1,
          color: bordercolor ?? PColors.primaryColor,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRaduis ?? 24),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: getTextStyle(
          fontSize:fontSize?? 16,
          color: PColors.colorFFFFFF,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
