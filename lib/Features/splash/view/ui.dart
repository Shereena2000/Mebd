import 'package:flutter/material.dart';
import 'package:medb/Settings/utils/images.dart';
import '../../../Settings/helper/secure_storage.dart';
import '../../../Settings/utils/p_colors.dart';
import '../../../Settings/utils/p_pages.dart';
import 'dart:developer';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final SecureStorageService _storage = SecureStorageService();

  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  Future<void> checkLogin() async {
    try {
      log("🚀 SplashScreen: Checking login status");
      
      // Debug storage content
      await _storage.debugStorage();
      
      final token = await _storage.getAccessToken();
      final loginKey = await _storage.getLoginKey();

      await Future.delayed(const Duration(seconds: 2)); // splash delay

      if (token != null && token.isNotEmpty && loginKey != null && loginKey.isNotEmpty) {
        log("✅ Valid tokens found - navigating to Home");
        if (mounted) {
          // Navigator.pushNamedAndRemoveUntil(
          //   context,
          //   PPages.mainPageUi,
          //   (route) => false,
          // );
           Navigator.pushNamedAndRemoveUntil(
            context,
            PPages.login,
            (route) => false,
          );
        }
      } else {
        log("❌ No valid tokens found - navigating to Login");
        if (mounted) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            PPages.login,
            (route) => false,
          );
        }
      }
    } catch (e) {
      log("❌ Error in checkLogin: $e");
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          PPages.login,
          (route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PColors.colorFFFFFF,
      body: Center(
        child: SizedBox(height: 100, child: Image.asset(Images.logo)),
      ),
    );
  }
}