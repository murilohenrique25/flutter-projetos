import 'package:get/get.dart';

import 'api_service.dart';
import 'storage_service.dart';
import '../../routes/app_routes.dart';

class AuthService extends GetxService {
  final _apiService = Get.put(ApiService());
  final _storageService = Get.put(StorageService());

  final _isLoggedIn = false.obs;
  final _currentUser = Rxn<User>();
  final _isLoading = false.obs;

  bool get isLoggedIn => _isLoggedIn.value;
  User? get currentUser => _currentUser.value;
  bool get isLoading => _isLoading.value;

  @override
  void onInit() {
    super.onInit();
    _checkAuthStatus();
  }

  void _checkAuthStatus() {
    final token = _storageService.getToken();
    final userData = _storageService.getUserData();

    if (token != null && userData != null) {
      _currentUser.value = User.fromJson(userData);
      _isLoggedIn.value = true;
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      _isLoading.value = true;

      // Mock login for demo
      if (email == 'joao@email.com' && password == '123456') {
        final userData = {
          'id': 1,
          'nome': 'João Silva',
          'email': email,
          'telefone': '(11) 98765-4321',
          'role': 'CLIENT'
        };

        await _storageService.saveToken('mock-jwt-token');
        await _storageService.saveUserData(userData);

        _currentUser.value = User.fromJson(userData);
        _isLoggedIn.value = true;

        Get.offAllNamed(AppRoutes.HOME);
        Get.snackbar('Sucesso', 'Login realizado com sucesso!');
        return true;
      } else {
        Get.snackbar('Erro', 'Credenciais inválidas');
        return false;
      }

      /*
      // Real API call would be:
      final response = await _apiService.login(email, password);

      if (response.statusCode == 200) {
        final data = response.data;

        await _storageService.saveToken(data['token']);
        await _storageService.saveUserData(data['user']);

        _currentUser.value = User.fromJson(data['user']);
        _isLoggedIn.value = true;

        Get.offAllNamed(AppRoutes.HOME);
        Get.snackbar('Sucesso', 'Login realizado com sucesso!');
        return true;
      }
      */
    } catch (e) {
      Get.snackbar('Erro', 'Erro ao fazer login: ${e.toString()}');
      return false;
    } finally {
      _isLoading.value = false;
    }
  }

  Future<bool> register(Map<String, dynamic> userData) async {
    try {
      _isLoading.value = true;

      final response = await _apiService.register(userData);

      if (response.statusCode == 201) {
        Get.snackbar('Sucesso', 'Cadastro realizado com sucesso!');
        return true;
      }

      return false;
    } catch (e) {
      Get.snackbar('Erro', 'Erro ao fazer cadastro: ${e.toString()}');
      return false;
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await _storageService.clearStorage();
    _currentUser.value = null;
    _isLoggedIn.value = false;

    Get.offAllNamed(AppRoutes.LOGIN);
    Get.snackbar('Info', 'Logout realizado com sucesso!');
  }
}

class User {
  final int id;
  final String nome;
  final String email;
  final String telefone;
  final String role;

  User({
    required this.id,
    required this.nome,
    required this.email,
    required this.telefone,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      nome: json['nome'],
      email: json['email'],
      telefone: json['telefone'] ?? '',
      role: json['role'] ?? 'CLIENT',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'telefone': telefone,
      'role': role,
    };
  }
}
