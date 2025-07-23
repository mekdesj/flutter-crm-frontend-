import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decode/jwt_decode.dart';
import '../services/api_services.dart';

class AuthProvider extends ChangeNotifier {
  final _storage = const FlutterSecureStorage();

  bool isLoggedIn = false;
  String? token;
  String? role;
  String? username;

  Future<bool> login(String usernameInput, String password) async {
    print("🔐 Attempting login with username: $usernameInput");

    try {
      final response = await ApiService.login(usernameInput, password);
      print("📥 Login response: $response");

      if (response != null && response['token'] != null) {
        token = response['token'];
        print("✅ Token received: $token");

        try {
          Map<String, dynamic> payload = Jwt.parseJwt(token!);
          print("🔍 Decoded JWT payload: $payload");

          username = payload['sub'];
          List rolesList = payload['roles'];
          role = rolesList.isNotEmpty ? rolesList[0] : null;

          print("🎭 Extracted role: $role");
          print("👤 Extracted username: $username");
        } catch (e) {
          print("❌ JWT decode error: $e");
          role = null;
          username = null;
        }

        isLoggedIn = token != null && role != null;

        if (isLoggedIn) {
          await _storage.write(key: 'token', value: token!);
          await _storage.write(key: 'role', value: role!);
          if (username != null) {
            await _storage.write(key: 'username', value: username!);
          }
        } else {
          print("⚠️ Login failed: token or role is null.");
        }

        notifyListeners();
        return isLoggedIn;
      } else {
        print("❌ Login failed: response null or token missing.");
        return false;
      }
    } catch (e) {
      print("💥 Exception during login: $e");
      return false;
    }
  }

  Future<void> logout() async {
    token = null;
    role = null;
    username = null;
    isLoggedIn = false;
    await _storage.deleteAll();
    notifyListeners();
  }

  Future<void> checkLogin() async {
    token = await _storage.read(key: 'token');
    role = await _storage.read(key: 'role');
    username = await _storage.read(key: 'username');
    isLoggedIn = token != null && role != null;
    notifyListeners();
  }
}
