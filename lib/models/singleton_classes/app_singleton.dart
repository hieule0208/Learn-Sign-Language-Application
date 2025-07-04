import 'package:shared_preferences/shared_preferences.dart';

class AppSingleton {
  static final AppSingleton _instance = AppSingleton._internal();

  AppSingleton._internal();

  factory AppSingleton() => _instance;

  static const String _isLoginKey = 'isLoggedIn';
  static const String _userIdKey = 'userId';

  bool _isLogin = false;
  String? _userId = "";

  // Getters
  bool get isLogin => _isLogin;
  String? get userId => _userId;

  // Setters + lưu SharedPreferences
  Future<void> setLoginStatus(bool status) async {
    _isLogin = status;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoginKey, status);
  }

  Future<void> setUserId(String? userId) async {
    _userId = userId;
    final prefs = await SharedPreferences.getInstance();
    if (userId != null) {
      await prefs.setString(_userIdKey, userId);
    } else {
      await prefs.remove(_userIdKey);
    }
  }

  // Load dữ liệu khi khởi động app
  Future<void> loadFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    _isLogin = prefs.getBool(_isLoginKey) ?? false;
    _userId = prefs.getString(_userIdKey) ?? "";
  }

  // Xoá khi logout
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_isLoginKey);
    await prefs.remove(_userIdKey);
    _isLogin = false;
    _userId = "";
  }
}
