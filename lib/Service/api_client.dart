import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../Settings/helper/secure_storage.dart';

class ApiClient {
  final SecureStorageService _storage = SecureStorageService();
  final String baseUrl = "https://testapi.medb.co.in/api";
  
  // Store cookies for refresh token
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

  // Enhanced request method with automatic token refresh
  Future<http.Response> _makeRequest({
    required String method,
    required String endpoint,
    Map<String, String>? additionalHeaders,
    String? body,
    bool isAuthRequest = false,
  }) async {
    final url = Uri.parse("$baseUrl/$endpoint");
    
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
    };

    // Add cookies for refresh token
    final cookieString = _getCookieString();
    if (cookieString.isNotEmpty) {
      headers['Cookie'] = cookieString;
    }

    // Add authorization header for protected routes
    if (!isAuthRequest) {
      final accessToken = await _storage.getAccessToken();
      if (accessToken != null && accessToken.isNotEmpty) {
        headers['Authorization'] = 'Bearer $accessToken';
      }
    }

    // Add additional headers
    if (additionalHeaders != null) {
      headers.addAll(additionalHeaders);
    }

    log("🌐 Making $method request to: $url");
    log("📋 Headers: $headers");

    http.Response response;
    
    switch (method.toUpperCase()) {
      case 'GET':
        response = await http.get(url, headers: headers);
        break;
      case 'POST':
        response = await http.post(url, headers: headers, body: body);
        break;
      case 'PUT':
        response = await http.put(url, headers: headers, body: body);
        break;
      case 'DELETE':
        response = await http.delete(url, headers: headers);
        break;
      default:
        throw Exception("Unsupported HTTP method: $method");
    }

    // Save cookies from response
    _saveCookiesFromResponse(response);

    log("📱 Response Status: ${response.statusCode}");
    log("📱 Response Body: ${response.body}");

    // Handle 401 Unauthorized - attempt token refresh
    if (response.statusCode == 401 && !isAuthRequest) {
      log("🔄 Access token expired, attempting refresh...");
      
      final refreshSuccess = await _refreshAccessToken();
      if (refreshSuccess) {
        log("✅ Token refreshed successfully, retrying original request...");
        
        // Retry the original request with new token
        final newAccessToken = await _storage.getAccessToken();
        if (newAccessToken != null) {
          headers['Authorization'] = 'Bearer $newAccessToken';
          
          switch (method.toUpperCase()) {
            case 'GET':
              response = await http.get(url, headers: headers);
              break;
            case 'POST':
              response = await http.post(url, headers: headers, body: body);
              break;
            case 'PUT':
              response = await http.put(url, headers: headers, body: body);
              break;
            case 'DELETE':
              response = await http.delete(url, headers: headers);
              break;
          }
          
          log("🔄 Retry response status: ${response.statusCode}");
        }
      } else {
        log("❌ Token refresh failed, user needs to login again");
        // Handle logout scenario - clear storage and redirect to login
        await _storage.clear();
        throw TokenRefreshException("Session expired. Please login again.");
      }
    }

    return response;
  }

  // Refresh access token using refresh token cookie
  Future<bool> _refreshAccessToken() async {
    try {
      final url = Uri.parse("$baseUrl/auth/refresh-token");
      
      Map<String, String> headers = {
        "Content-Type": "application/json",
        "Accept": "application/json",
      };

      // Include refresh token cookie
      final cookieString = _getCookieString();
      if (cookieString.isNotEmpty) {
        headers['Cookie'] = cookieString;
      } else {
        log("❌ No refresh token cookie found");
        return false;
      }

      log("🔄 Attempting token refresh...");
      
      final response = await http.post(url, headers: headers);
      
      log("🔄 Refresh token response status: ${response.statusCode}");
      log("🔄 Refresh token response body: ${response.body}");

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        
        // Save new access token
        final newAccessToken = responseData['accessToken'];
        if (newAccessToken != null) {
          await _storage.saveAccessToken(newAccessToken);
          
          // Update cookies from refresh response
          _saveCookiesFromResponse(response);
          
          log("✅ Access token refreshed successfully");
          return true;
        } else {
          log("❌ No access token in refresh response");
          return false;
        }
      } else {
        log("❌ Token refresh failed with status: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      log("❌ Exception during token refresh: $e");
      return false;
    }
  }

  // Public methods for different HTTP operations
  Future<Map<String, dynamic>> get(String endpoint) async {
    final response = await _makeRequest(method: 'GET', endpoint: endpoint);
    
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("GET request failed: ${response.body}");
    }
  }

  Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> data, {bool isAuthRequest = false}) async {
    final response = await _makeRequest(
      method: 'POST', 
      endpoint: endpoint, 
      body: jsonEncode(data),
      isAuthRequest: isAuthRequest,
    );
    
    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      String errorMessage;
      try {
        final errorData = jsonDecode(response.body);
        errorMessage = errorData["message"] ?? "Request failed";
      } catch (e) {
        errorMessage = "Request failed with status: ${response.statusCode}";
      }
      throw Exception(errorMessage);
    }
  }

  Future<Map<String, dynamic>> put(String endpoint, Map<String, dynamic> data) async {
    final response = await _makeRequest(
      method: 'PUT', 
      endpoint: endpoint, 
      body: jsonEncode(data),
    );
    
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("PUT request failed: ${response.body}");
    }
  }

  Future<Map<String, dynamic>> delete(String endpoint) async {
    final response = await _makeRequest(method: 'DELETE', endpoint: endpoint);
    
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("DELETE request failed: ${response.body}");
    }
  }

  // Initialize cookies from login response
  void initializeCookiesFromResponse(http.Response response) {
    _saveCookiesFromResponse(response);
  }

  // Clear cookies on logout
  void clearCookies() {
    _cookies.clear();
    log("🗑️ Cookies cleared");
  }
}

// Custom exception for token refresh failures
class TokenRefreshException implements Exception {
  final String message;
  TokenRefreshException(this.message);
  
  @override
  String toString() => message;
}