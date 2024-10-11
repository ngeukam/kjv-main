import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AuthHelper {
  static Future<bool> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    return token.isNotEmpty && _isTokenValid(token);
  }

  static bool _isTokenValid(String token) {
    final parts = token.split('.');
    if (parts.length != 3) return false;

    final payload = utf8.decode(base64Url.decode(base64Url.normalize(parts[1])));
    final Map<String, dynamic> payloadMap = jsonDecode(payload);

    final exp = payloadMap['exp'];
    if (exp != null) {
      final expiryDate = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
      return expiryDate.isAfter(DateTime.now());
    }
    return false;
  }
}
