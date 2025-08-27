import 'dart:convert';
import 'dart:developer';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final _storage = const FlutterSecureStorage();

  // Keys
  static const String _accessTokenKey = 'accessToken';
  static const String _loginKey = 'loginKey';
  static const String _userDetailsKey = 'userDetails';

  // Save tokens + user details
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
      return await _storage.read(key: _loginKey);
    } catch (e) {
      log("❌ Error retrieving login key: $e");
      return null;
    }
  }

  Future<Map<String, dynamic>?> getUserDetails() async {
    try {
      final data = await _storage.read(key: _userDetailsKey);
      if (data != null && data.isNotEmpty) {
        return jsonDecode(data);
      }
      return null;
    } catch (e) {
      log("❌ Error retrieving user details: $e");
      return null;
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
}