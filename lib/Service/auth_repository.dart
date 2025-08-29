import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

class AuthRepository {
  final String baseUrl = "https://testapi.medb.co.in/api/auth";
  
  // Store cookies for refresh token handling
  final Map<String, String> _cookies = {};

  // Save cookies from response headers
  void _saveCookiesFromResponse(http.Response response) {
    final setCookieHeader = response.headers['set-cookie'];
    if (setCookieHeader != null) {
      final cookies = setCookieHeader.split(',');
      for (final cookie in cookies) {
        final trimmedCookie = cookie.trim();
        if (trimmedCookie.contains('=')) {
          final parts = trimmedCookie.split('=');
          if (parts.length >= 2) {
            final name = parts[0].trim();
            final value = parts[1].split(';')[0].trim();
            _cookies[name] = value;
            log("🍪 Saved cookie: $name");
          }
        }
      }
    }
  }

  // Get cookie string for requests
  String _getCookieString() {
    return _cookies.entries.map((e) => '${e.key}=${e.value}').join('; ');
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/login');
      
      log("🔄 Making login request to: $url");
      log("📧 Email: $email");

      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode({
          "email": email,
          "password": password,
        }),
      );

      log("📱 Response Status Code: ${response.statusCode}");
      log("📱 Response Headers: ${response.headers}");
      log("📱 Response Body: ${response.body}");

      if (response.statusCode == 200) {
        // Save cookies (including refresh token)
        _saveCookiesFromResponse(response);
        
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        
        // Extract loginKey from cookies
        String? loginKey = _extractLoginKeyFromCookies(response.headers);
        
        // Validate required fields
        if (responseData['accessToken'] == null) {
          throw Exception("Server response missing accessToken");
        }
        if (loginKey == null) {
          throw Exception("Server response missing loginKey in cookies");
        }
        
        // Add loginKey to response data
        responseData['loginKey'] = loginKey;
        
        log("✅ Extracted loginKey from cookies: ${loginKey.substring(0, 20)}...");
        
        return responseData;
      } else {
        // Handle different status codes
        String errorMessage;
        try {
          final errorData = jsonDecode(response.body);
          errorMessage = errorData["message"] ?? "Login failed";
        } catch (e) {
          errorMessage = "Login failed with status: ${response.statusCode}";
        }
        throw Exception(errorMessage);
      }
    } catch (e) {
      log("❌ Login Exception: $e");
      rethrow;
    }
  }

  // Helper method to extract loginKey from Set-Cookie header
  String? _extractLoginKeyFromCookies(Map<String, String> headers) {
    try {
      final setCookieHeader = headers['set-cookie'];
      if (setCookieHeader == null) return null;
      
      log("🍪 Set-Cookie header: $setCookieHeader");
      
      final cookies = setCookieHeader.split(',');
      
      for (final cookie in cookies) {
        final trimmedCookie = cookie.trim();
        if (trimmedCookie.startsWith('loginKey=')) {
          final loginKeyPart = trimmedCookie.substring('loginKey='.length);
          final semicolonIndex = loginKeyPart.indexOf(';');
          final loginKey = semicolonIndex != -1 
              ? loginKeyPart.substring(0, semicolonIndex)
              : loginKeyPart;
          
          log("✅ Found loginKey in cookies: ${loginKey.substring(0, 20)}...");
          return loginKey;
        }
      }
      
      log("❌ loginKey not found in cookies");
      return null;
    } catch (e) {
      log("❌ Error extracting loginKey from cookies: $e");
      return null;
    }
  }

  // Refresh access token using refresh token cookie
  Future<Map<String, dynamic>?> refreshToken() async {
    try {
      final url = Uri.parse('$baseUrl/refresh-token');
      
      Map<String, String> headers = {
        "Content-Type": "application/json",
        "Accept": "application/json",
      };

      // Include refresh token cookie
      final cookieString = _getCookieString();
      if (cookieString.isNotEmpty) {
        headers['Cookie'] = cookieString;
      } else {
        log("❌ No refresh token cookie available");
        return null;
      }

      log("🔄 Attempting token refresh with cookies: $cookieString");
      
      final response = await http.post(url, headers: headers);
      
      log("🔄 Refresh token response status: ${response.statusCode}");
      log("🔄 Refresh token response body: ${response.body}");

      if (response.statusCode == 200) {
        // Save new cookies from refresh response
        _saveCookiesFromResponse(response);
        
        final responseData = jsonDecode(response.body);
        log("✅ Token refreshed successfully");
        return responseData;
      } else {
        log("❌ Token refresh failed with status: ${response.statusCode}");
        
        // If refresh fails, clear stored cookies
        _cookies.clear();
        return null;
      }
    } catch (e) {
      log("❌ Exception during token refresh: $e");
      _cookies.clear();
      return null;
    }
  }

  Future<Map<String, dynamic>> register({
    required String firstName,
    required String middleName,
    required String lastName,
    required String email,
    required String contactNo,
    required String password,
    required String confirmPassword,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/register');

      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode({
          "firstName": firstName,
          "middleName": middleName,
          "lastName": lastName,
          "email": email,
          "contactNo": contactNo,
          "password": password,
          "confirmPassword": confirmPassword,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        String errorMessage;
        try {
          final errorData = jsonDecode(response.body);
          errorMessage = errorData["message"] ?? "Registration failed";
        } catch (e) {
          errorMessage = "Registration failed with status: ${response.statusCode}";
        }
        throw Exception(errorMessage);
      }
    } catch (e) {
      log("❌ Registration Exception: $e");
      rethrow;
    }
  }

  Future<Map<String, dynamic>> logout() async {
    try {
      final url = Uri.parse('$baseUrl/logout');

      Map<String, String> headers = {
        "Content-Type": "application/json",
        "Accept": "application/json",
      };

      // Include refresh token cookie for proper logout
      final cookieString = _getCookieString();
      if (cookieString.isNotEmpty) {
        headers['Cookie'] = cookieString;
      }

      final response = await http.post(url, headers: headers);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        // Clear stored cookies after successful logout
        _cookies.clear();
        
        log("✅ Logout Success: ${data['message']}");
        return data;
      } else {
        // Even if logout fails on server, clear local cookies
        _cookies.clear();
        throw Exception("Logout failed: ${response.body}");
      }
    } catch (e) {
      // Clear cookies even on exception
      _cookies.clear();
      log("❌ Logout Exception: $e");
      rethrow;
    }
  }

  // Check if refresh token exists
  bool hasRefreshToken() {
    return _cookies.containsKey('refreshToken') && _cookies['refreshToken']!.isNotEmpty;
  }

  // Clear all stored cookies
  void clearCookies() {
    _cookies.clear();
    log("🗑️ All cookies cleared");
  }
}