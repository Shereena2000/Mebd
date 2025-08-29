import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:medb/Features/accounts/view_model/account_view_model.dart';
import 'package:provider/provider.dart';
import '../../../../Service/auth_repository.dart';
import '../../../../Settings/helper/secure_storage.dart';
import '../../../main_screen/model/menu_model.dart';
import '../../../main_screen/view_model/menu_navigation_provider.dart';
import '../../../../Settings/utils/p_pages.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthRepository _authRepository = AuthRepository();
  final SecureStorageService _storage = SecureStorageService();
  final formkey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isPasswordVisible = true;
  bool _isLoading = false;
  String? _loginErrorText;

  bool get isLoading => _isLoading;
  String? get loginErrorText => _loginErrorText;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  set loginErrorText(String? value) {
    _loginErrorText = value;
    notifyListeners();
  }

  Future<Map<String, dynamic>?> loginUser(BuildContext context) async {
    if (!formkey.currentState!.validate()) return null;

    try {
      isLoading = true;
      loginErrorText = null;
      EasyLoading.show(status: 'Logging in...');
      
      final response = await _authRepository.login(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // Validate response contains required fields
      if (response['accessToken'] == null || response['loginKey'] == null) {
        throw Exception("Invalid response: Missing required authentication data");
      }

      // Save tokens to secure storage with null checks
      await _storage.saveLoginData(
        accessToken: response['accessToken'] ?? '',
        loginKey: response['loginKey'] ?? '',
        userDetails: response['userDetails'] ?? {},
      );

      // Handle menu data safely
      if (response['menuData'] != null && 
          response['menuData'] is List && 
          response['menuData'].isNotEmpty &&
          response['menuData'][0]['menus'] != null) {
        
        final menus = (response["menuData"][0]["menus"] as List)
            .map((m) => MenuItemModel.fromJson(m))
            .toList();

        log("Menus loaded: ${menus.length} items");
        if (context.mounted) {
          await context.read<MenuNavigationProvider>().setMenus(menus);
        }


      }
context.read<AccountViewModel>().setUserDetails(response['userDetails']);

      EasyLoading.dismiss();
      isLoading = false;
      loginErrorText = null;
      clearData();

      log("✅ Login Success");
      return response;

    } catch (e) {
      isLoading = false;
      EasyLoading.dismiss();
      
      final errorMessage = e.toString();
      log("❌ Login Error: $errorMessage");
      
      // Handle specific error scenarios
      if (errorMessage.contains("already logged in") || 
          errorMessage.contains("other device") ||
          errorMessage.contains("session exists")) {
        
        return await _handleExistingSession(context, errorMessage);
        
      } else if (errorMessage.contains("Invalid credentials") || 
                 errorMessage.contains("Authentication failed")) {
        
        loginErrorText = "Invalid email or password. Please check your credentials.";
        EasyLoading.showError(loginErrorText!);
        return null;
        
      } else if (errorMessage.contains("Account not verified") || 
                 errorMessage.contains("email verification")) {
        
        loginErrorText = "Please verify your email before logging in.";
        EasyLoading.showError(loginErrorText!);
        return null;
        
      } else if (errorMessage.contains("Network") || 
                 errorMessage.contains("connection")) {
        
        loginErrorText = "Network error. Please check your internet connection.";
        EasyLoading.showError(loginErrorText!);
        return null;
        
      } else {
        // Generic error handling
        loginErrorText = _extractErrorMessage(errorMessage);
        EasyLoading.showError(loginErrorText ?? "Login failed");
        return null;
      }
    }
  }

  // Handle existing session scenario
  Future<Map<String, dynamic>?> _handleExistingSession(BuildContext context, String originalError) async {
    try {
      loginErrorText = "You're logged in elsewhere. Logging out and retrying...";
      notifyListeners();
      
      log("🔄 Attempting to logout and retry login");
      
      // Try to logout first
      await _authRepository.logout();
      await _storage.clear();
      
      // Small delay to ensure logout is processed
      await Future.delayed(const Duration(milliseconds: 500));
      
      EasyLoading.show(status: 'Retrying login...');
      
      // Retry login after logout
      final retryResponse = await _authRepository.login(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      
      // Validate retry response
      if (retryResponse['accessToken'] == null || retryResponse['loginKey'] == null) {
        throw Exception("Invalid retry response: Missing authentication data");
      }
      
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
          await context.read<MenuNavigationProvider>().setMenus(menus);
        }
      }
      
      EasyLoading.dismiss();
      isLoading = false;
      loginErrorText = null;
      clearData();
      
      log("✅ Retry Login Success");
      return retryResponse;
      
    } catch (retryError) {
      isLoading = false;
      EasyLoading.dismiss();
      
      final retryErrorMsg = _extractErrorMessage(retryError.toString());
      loginErrorText = "Failed to resolve login conflict: $retryErrorMsg";
      EasyLoading.showError(loginErrorText ?? "Login failed");
      log("❌ Retry Login Error: $retryError");
      return null;
    }
  }

  // Extract clean error message from exception
  String _extractErrorMessage(String errorMessage) {
    // Remove "Exception: " prefix if present
    if (errorMessage.startsWith("Exception: ")) {
      return errorMessage.substring("Exception: ".length);
    }
    return errorMessage;
  }

  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    notifyListeners();
  }

  void clearData() {
    emailController.clear();
    passwordController.clear();
    loginErrorText = null;
    notifyListeners();
  }

  // Check if user is already logged in (for app startup)
  Future<bool> checkExistingLogin() async {
    try {
      return await _storage.isLoggedIn();
    } catch (e) {
      log("❌ Error checking existing login: $e");
      return false;
    }
  }

  // Perform logout with cleanup
  Future<void> performLogout(BuildContext context) async {
    try {
      isLoading = true;
      EasyLoading.show(status: 'Logging out...');
      
      // Call backend logout
      await _authRepository.logout();
      
      // Clear local storage
      await _storage.clear();
      
      // Clear menu data
      if (context.mounted) {
        await context.read<MenuNavigationProvider>().clearMenus();
      }
      
      // Clear auth repository cookies
      _authRepository.clearCookies();
      
      EasyLoading.dismiss();
      isLoading = false;
      
      log("✅ Logout completed successfully");
      
      // Navigate to login screen
      if (context.mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context, 
          PPages.login, 
          (route) => false,
        );
      }
      
    } catch (e) {
      isLoading = false;
      EasyLoading.dismiss();
      
      log("❌ Logout error: $e");
      
      // Even if backend logout fails, clear local data
      await _storage.clear();
      _authRepository.clearCookies();
      
      if (context.mounted) {
        await context.read<MenuNavigationProvider>().clearMenus();
        Navigator.pushNamedAndRemoveUntil(
          context, 
          PPages.login, 
          (route) => false,
        );
      }
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}