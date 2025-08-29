import 'dart:convert';
import 'dart:developer';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final _storage = const FlutterSecureStorage();

  // Keys
  static const String _accessTokenKey = 'accessToken';
  static const String _loginKey = 'loginKey';
  static const String _userDetailsKey = 'userDetails';

  // Save complete login data
  Future<void> saveLoginData({
    required String accessToken,
    required String loginKey,
    required Map<String, dynamic> userDetails,
  }) async {
    try {
      log("💾 Saving login data to secure storage");
      log("🔑 Access Token: ${accessToken.isNotEmpty ? 'Present' : 'Missing'}");
      log("🗝️ Login Key: ${loginKey.isNotEmpty ? 'Present' : 'Missing'}");
      
      await _storage.write(key: _accessTokenKey, value: accessToken);
      await _storage.write(key: _loginKey, value: loginKey);
      await _storage.write(key: _userDetailsKey, value: jsonEncode(userDetails));
      
      log("✅ Login data saved successfully");
      
      // Verify data was saved
      final savedToken = await _storage.read(key: _accessTokenKey);
      log("✅ Verification - Token saved: ${savedToken != null && savedToken.isNotEmpty}");
      
    } catch (e) {
      log("❌ Error saving login data: $e");
      throw Exception("Failed to save login data: $e");
    }
  }

  // Save only access token (useful for refresh token scenarios)
  Future<void> saveAccessToken(String accessToken) async {
    try {
      await _storage.write(key: _accessTokenKey, value: accessToken);
      log("💾 Access token updated in secure storage");
    } catch (e) {
      log("❌ Error saving access token: $e");
      throw Exception("Failed to save access token: $e");
    }
  }

  // Getters with better error handling
  Future<String?> getAccessToken() async {
    try {
      final token = await _storage.read(key: _accessTokenKey);
      log("🔍 Retrieved access token: ${token != null && token.isNotEmpty ? 'Present' : 'Missing'}");
      return token;
    } catch (e) {
      log("❌ Error retrieving access token: $e");
      return null;
    }
  }

  Future<String?> getLoginKey() async {
    try {
      final loginKey = await _storage.read(key: _loginKey);
      log("🔍 Retrieved login key: ${loginKey != null && loginKey.isNotEmpty ? 'Present' : 'Missing'}");
      return loginKey;
    } catch (e) {
      log("❌ Error retrieving login key: $e");
      return null;
    }
  }

  Future<Map<String, dynamic>?> getUserDetails() async {
    try {
      final data = await _storage.read(key: _userDetailsKey);
      if (data != null && data.isNotEmpty) {
        final userDetails = jsonDecode(data);
        log("👤 Retrieved user details: ${userDetails['firstName'] ?? 'Unknown'}");
        return userDetails;
      }
      log("👤 No user details found");
      return null;
    } catch (e) {
      log("❌ Error retrieving user details: $e");
      return null;
    }
  }

  // Check if user is logged in (has valid access token)
  Future<bool> isLoggedIn() async {
    try {
      final accessToken = await getAccessToken();
      final loginKey = await getLoginKey();
      
      final isValid = accessToken != null && 
                     accessToken.isNotEmpty && 
                     loginKey != null && 
                     loginKey.isNotEmpty;
      
      log("🔍 User login status: ${isValid ? 'Logged in' : 'Not logged in'}");
      return isValid;
    } catch (e) {
      log("❌ Error checking login status: $e");
      return false;
    }
  }

  // Clear storage (logout)
  Future<void> clear() async {
    try {
      await _storage.deleteAll();
      log("🗑️ Secure storage cleared");
    } catch (e) {
      log("❌ Error clearing storage: $e");
      throw Exception("Failed to clear storage: $e");
    }
  }

  // Debug method to check all stored keys
  Future<void> debugStorage() async {
    try {
      final allKeys = await _storage.readAll();
      log("🔍 All stored keys: ${allKeys.keys.toList()}");
      for (final key in allKeys.keys) {
        final value = allKeys[key];
        log("   $key: ${value != null && value.isNotEmpty ? 'Has value' : 'Empty'}");
      }
    } catch (e) {
      log("❌ Error reading storage: $e");
    }
  }

  // Check if specific token exists
  Future<bool> hasAccessToken() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }

  Future<bool> hasLoginKey() async {
    final key = await getLoginKey();
    return key != null && key.isNotEmpty;
  }
}