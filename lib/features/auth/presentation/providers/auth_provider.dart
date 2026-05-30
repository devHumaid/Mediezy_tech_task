import 'package:flutter/material.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/models/user_model.dart';
import '../../../../shared/services/local_storage_service.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class AuthProvider extends ChangeNotifier {
  final AuthRemoteDataSource _dataSource = AuthRemoteDataSource();
  final LocalStorageService  _storage    = LocalStorageService.instance;

  AuthStatus  _status       = AuthStatus.initial;
  String?     _errorMessage;
  UserModel?  _currentUser;

  AuthStatus  get status          => _status;
  String?     get errorMessage    => _errorMessage;
  UserModel?  get currentUser     => _currentUser;
  bool        get isAuthenticated => _status == AuthStatus.authenticated;

  Future<void> checkLoginStatus() async {
    final loggedIn = await _storage.isLoggedIn();
    if (loggedIn) {
      _currentUser = UserModel(
        token:     await _storage.getToken(),
        userId:    await _storage.getUserId(),
        firstName: await _storage.getUserName(),
        role:      await _storage.getUserRole(),
        location:  await _storage.getLocation(),
      );
      _status = AuthStatus.authenticated;
    } else {
      _status = AuthStatus.unauthenticated;
    }
    notifyListeners();
  }

  Future<void> login({required String mobileNumber, required String password}) async {
    _setLoading();
    try {
      final user = await _dataSource.login(mobileNumber: mobileNumber, password: password);
      if (user.token != null) await _storage.saveToken(user.token!);
      if (user.userId != null) await _storage.saveUserId(user.userId!);
      if (user.fullName.isNotEmpty) await _storage.saveUserName(user.fullName);
      if (user.role != null) await _storage.saveUserRole(user.role!);
      if (user.location != null) await _storage.saveLocation(user.location!);
      _currentUser  = user;
      _status       = AuthStatus.authenticated;
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _status = AuthStatus.error;
    }
    notifyListeners();
  }

  Future<bool> register({
    required String firstName, required String lastName,
    required String email,     required String password,
    required String address,   required String dob,
    required String mobileNumber, required String doj, required String location,
  }) async {
    _setLoading();
    try {
      await _dataSource.register(
        firstName: firstName, lastName: lastName, email: email,
        password: password, address: address, dob: dob,
        mobileNumber: mobileNumber, doj: doj, location: location,
      );
      _status = AuthStatus.unauthenticated;
      _errorMessage = null;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _status = AuthStatus.error;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await _storage.clearSession();
    _currentUser  = null;
    _status       = AuthStatus.unauthenticated;
    _errorMessage = null;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    if (_status == AuthStatus.error) _status = AuthStatus.unauthenticated;
    notifyListeners();
  }

  void _setLoading() {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();
  }
}