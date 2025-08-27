import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Settings/helper/secure_storage.dart';

class ApiClient {
  final SecureStorageService _storage = SecureStorageService();
  final String baseUrl = "https://testapi.medb.co.in/api";

  Future<Map<String, dynamic>> getSecureData(String endpoint) async {
    final token = await _storage.getAccessToken();

    final response = await http.get(
      Uri.parse("$baseUrl/$endpoint"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Request failed: ${response.body}");
    }
  }
}
