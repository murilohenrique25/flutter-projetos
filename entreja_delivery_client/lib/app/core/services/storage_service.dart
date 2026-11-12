import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class StorageService extends GetxService {
  SharedPreferences? _prefs;

  static const String _tokenKey = 'auth_token';
  static const String _userDataKey = 'user_data';
  static const String _cartDataKey = 'cart_data';

  @override
  Future<void> onInit() async {
    super.onInit();
    _prefs = await SharedPreferences.getInstance();
  }

  // Auth methods
  Future<void> saveToken(String token) async {
    await _prefs?.setString(_tokenKey, token);
  }

  String? getToken() {
    return _prefs?.getString(_tokenKey);
  }

  Future<void> saveUserData(Map<String, dynamic> userData) async {
    await _prefs?.setString(_userDataKey, jsonEncode(userData));
  }

  Map<String, dynamic>? getUserData() {
    final userData = _prefs?.getString(_userDataKey);
    if (userData != null) {
      return jsonDecode(userData);
    }
    return null;
  }

  // Cart methods
  Future<void> saveCartData(List<Map<String, dynamic>> cartData) async {
    await _prefs?.setString(_cartDataKey, jsonEncode(cartData));
  }

  List<dynamic>? getCartData() {
    final cartData = _prefs?.getString(_cartDataKey);
    if (cartData != null) {
      return jsonDecode(cartData);
    }
    return null;
  }

  Future<void> clearCartData() async {
    await _prefs?.remove(_cartDataKey);
  }

  // Clear all storage
  Future<void> clearStorage() async {
    await _prefs?.clear();
  }
}