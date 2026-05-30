import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_constants.dart';

/// Thin wrapper around SharedPreferences for typed access.
class LocalStorageService {
  LocalStorageService._();
  static final LocalStorageService instance = LocalStorageService._();

  Future<void> saveToken(String token) async {
    final p = await SharedPreferences.getInstance();
    await p.setString(AppConstants.keyToken, token);
  }

  Future<String?> getToken() async {
    final p = await SharedPreferences.getInstance();
    return p.getString(AppConstants.keyToken);
  }

  Future<void> saveUserId(String id) async {
    final p = await SharedPreferences.getInstance();
    await p.setString(AppConstants.keyUserId, id);
  }

  Future<String?> getUserId() async {
    final p = await SharedPreferences.getInstance();
    return p.getString(AppConstants.keyUserId);
  }

  Future<void> saveUserName(String name) async {
    final p = await SharedPreferences.getInstance();
    await p.setString(AppConstants.keyUserName, name);
  }

  Future<String?> getUserName() async {
    final p = await SharedPreferences.getInstance();
    return p.getString(AppConstants.keyUserName);
  }

  Future<void> saveUserRole(String role) async {
    final p = await SharedPreferences.getInstance();
    await p.setString(AppConstants.keyUserRole, role);
  }

  Future<String?> getUserRole() async {
    final p = await SharedPreferences.getInstance();
    return p.getString(AppConstants.keyUserRole);
  }

  Future<void> saveLocation(String location) async {
    final p = await SharedPreferences.getInstance();
    await p.setString(AppConstants.keyLocation, location);
  }

  Future<String?> getLocation() async {
    final p = await SharedPreferences.getInstance();
    return p.getString(AppConstants.keyLocation);
  }

  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  /// Clears all user session data
  Future<void> clearSession() async {
    final p = await SharedPreferences.getInstance();
    await p.remove(AppConstants.keyToken);
    await p.remove(AppConstants.keyUserId);
    await p.remove(AppConstants.keyUserName);
    await p.remove(AppConstants.keyUserRole);
    await p.remove(AppConstants.keyLocation);
  }
}