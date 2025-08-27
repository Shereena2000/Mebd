import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import '../../../../Service/auth_repository.dart';
import '../../../../Settings/helper/secure_storage.dart';
import '../../../main_screen/model/menu_model.dart';
import '../../../main_screen/view_model/menu_navigation_provider.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthRepository _authRepository = AuthRepository();
  final SecureStorageService _storage = SecureStorageService();
  final formkey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isPasswordVisible = true;
  String? _loginErrorText;
  String? get loginErrorText => _loginErrorText;

  set loginErrorText(String? value) {
    _loginErrorText = value;
    notifyListeners();
  }

  Future<Map<String, dynamic>?> loginUser(BuildContext context) async {
    if (!formkey.currentState!.validate()) return null;

    try {
      EasyLoading.show(status: 'Logging in...');
      
      final response = await _authRepository.login(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // ✅ Check if response contains required fields
      if (response['accessToken'] == null || response['loginKey'] == null) {
        throw Exception("Invalid response: Missing required authentication data");
      }

      // ✅ Save tokens to secure storage with null checks
      await _storage.saveLoginData(
        accessToken: response['accessToken'] ?? '',
        loginKey: response['loginKey'] ?? '',
        userDetails: response['userDetails'] ?? {},
      );

      // ✅ Handle menu data safely
      if (response['menuData'] != null && 
          response['menuData'] is List && 
          response['menuData'].isNotEmpty &&
          response['menuData'][0]['menus'] != null) {
        
        final menus = (response["menuData"][0]["menus"] as List)
            .map((m) => MenuItemModel.fromJson(m))
            .toList();

        log("Menus: $menus");
        if (context.mounted) {
         await   context.read<MenuNavigationProvider>().setMenus(menus);
        }
      }

      EasyLoading.dismiss();
      loginErrorText = null;
      clearData();

      // ✅ Log important fields
      log("✅ Login Success");
      log("Access Token: ${response['accessToken']}");
      log("Login Key: ${response['loginKey']}");
      log("User Details: ${response['userDetails']}");

      return response;
    } catch (e) {
      EasyLoading.dismiss();
      final errorMessage = e.toString();
      
      // ✅ Handle "already logged in" error
      if (errorMessage.contains("already logged in") || errorMessage.contains("other device")) {
        loginErrorText = "You're logged in elsewhere. Logging out and retrying...";
        log("🔄 Attempting to logout and retry login");
        
        try {
          // Try to logout first
          await _authRepository.logout();
          await _storage.clear(); // Clear local storage too
          
          EasyLoading.show(status: 'Retrying login...');
          
          // Retry login after logout
          final retryResponse = await _authRepository.login(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          );
          
          // Save the retry response
          await _storage.saveLoginData(
            accessToken: retryResponse['accessToken'] ?? '',
            loginKey: retryResponse['loginKey'] ?? '',
            userDetails: retryResponse['userDetails'] ?? {},
          );
          
          // Handle menu data for retry
          if (retryResponse['menuData'] != null && 
              retryResponse['menuData'] is List && 
              retryResponse['menuData'].isNotEmpty &&
              retryResponse['menuData'][0]['menus'] != null) {
            
            final menus = (retryResponse["menuData"][0]["menus"] as List)
                .map((m) => MenuItemModel.fromJson(m))
                .toList();

            if (context.mounted) {
              context.read<MenuNavigationProvider>().setMenus(menus);
            }
          }
          
          EasyLoading.dismiss();
          loginErrorText = null;
          clearData();
          
          log("✅ Retry Login Success");
          return retryResponse;
          
        } catch (retryError) {
          EasyLoading.dismiss();
          loginErrorText = "Failed to resolve login conflict: $retryError";
          EasyLoading.showError(loginErrorText ?? "Login failed");
          log("❌ Retry Login Error: $retryError");
          return null;
        }
      } else {
        loginErrorText = errorMessage;
        log("❌ Login Error: $e");
        EasyLoading.showError(loginErrorText ?? "Something went wrong");
        return null;
      }
    }
  }

  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    notifyListeners();
  }

  void clearData() {
    emailController.clear();
    passwordController.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}