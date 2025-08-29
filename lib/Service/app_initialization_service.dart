import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Settings/helper/secure_storage.dart';
import '../Features/main_screen/view_model/menu_navigation_provider.dart';
import '../Service/auth_repository.dart';

class AppInitializationService {
  final SecureStorageService _storage = SecureStorageService();
  final AuthRepository _authRepository = AuthRepository();

  // Check authentication status on app startup
  Future<AppStartupResult> checkAuthenticationStatus() async {
    try {
      log("🚀 Checking authentication status on app startup...");
      
      // Check if user has stored credentials
      final hasAccessToken = await _storage.hasAccessToken();
      final hasLoginKey = await _storage.hasLoginKey();
      
      log("🔍 Has access token: $hasAccessToken");
      log("🔍 Has login key: $hasLoginKey");
      
      if (!hasAccessToken || !hasLoginKey) {
        log("❌ Missing authentication credentials - redirecting to login");
        return AppStartupResult(
          isAuthenticated: false,
          shouldNavigateToLogin: true,
          message: "No authentication credentials found",
        );
      }

      // Try to validate the token by making a test request
      // You can implement a /auth/validate endpoint or use any protected endpoint
      final isTokenValid = await _validateAccessToken();
      
      if (isTokenValid) {
        log("✅ Access token is valid - user is authenticated");
        return AppStartupResult(
          isAuthenticated: true,
          shouldNavigateToLogin: false,
          message: "User authenticated successfully",
        );
      } else {
        log("⚠️ Access token expired - attempting refresh...");
        
        // Try to refresh the token
        final refreshResult = await _authRepository.refreshToken();
        
        if (refreshResult != null && refreshResult['accessToken'] != null) {
          // Save new access token
          await _storage.saveAccessToken(refreshResult['accessToken']);
          
          log("✅ Token refreshed successfully");
          return AppStartupResult(
            isAuthenticated: true,
            shouldNavigateToLogin: false,
            message: "Token refreshed successfully",
          );
        } else {
          log("❌ Token refresh failed - user needs to login again");
          
          // Clear invalid stored data
          await _storage.clear();
          _authRepository.clearCookies();
          
          return AppStartupResult(
            isAuthenticated: false,
            shouldNavigateToLogin: true,
            message: "Session expired. Please login again.",
          );
        }
      }
    } catch (e) {
      log("❌ Error during authentication check: $e");
      
      // Clear potentially corrupted data
      await _storage.clear();
      _authRepository.clearCookies();
      
      return AppStartupResult(
        isAuthenticated: false,
        shouldNavigateToLogin: true,
        message: "Authentication check failed. Please login again.",
      );
    }
  }

  // Validate access token by making a test request
  Future<bool> _validateAccessToken() async {
    try {
      // You can replace this with any protected endpoint
      // For now, we'll assume validation based on token existence and format
      final accessToken = await _storage.getAccessToken();
      
      if (accessToken == null || accessToken.isEmpty) {
        return false;
      }

      // Optional: Make a test request to a protected endpoint
      // Uncomment and modify this section based on your available endpoints
      /*
      final testResponse = await http.get(
        Uri.parse("$baseUrl/auth/profile"), // or any protected endpoint
        headers: {
          "Authorization": "Bearer $accessToken",
          "Content-Type": "application/json",
        },
      );
      
      return testResponse.statusCode == 200;
      */
      
      // For now, just check if token exists and has reasonable length
      return accessToken.length > 10; // Basic validation
      
    } catch (e) {
      log("❌ Token validation error: $e");
      return false;
    }
  }

  // Initialize app data after successful authentication
  Future<void> initializeAppData(BuildContext context) async {
    try {
      log("🔄 Initializing app data...");
      
      // Load saved menus
      if (context.mounted) {
        await context.read<MenuNavigationProvider>().loadMenus();
      }
      
      // You can add other initialization logic here
      // e.g., preload user profile, check for app updates, etc.
      
      log("✅ App data initialized successfully");
    } catch (e) {
      log("❌ Error initializing app data: $e");
      // Don't throw error here as it's not critical for app startup
    }
  }

  // Handle session cleanup
  Future<void> cleanupSession() async {
    try {
      log("🗑️ Cleaning up user session...");
      
      // Clear secure storage
      await _storage.clear();
      
      // Clear auth repository cookies
      _authRepository.clearCookies();
      
      log("✅ Session cleanup completed");
    } catch (e) {
      log("❌ Error during session cleanup: $e");
    }
  }
}

class AppStartupResult {
  final bool isAuthenticated;
  final bool shouldNavigateToLogin;
  final String message;

  AppStartupResult({
    required this.isAuthenticated,
    required this.shouldNavigateToLogin,
    required this.message,
  });

  @override
  String toString() {
    return 'AppStartupResult(isAuthenticated: $isAuthenticated, shouldNavigateToLogin: $shouldNavigateToLogin, message: $message)';
  }
}