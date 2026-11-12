import 'package:get/get.dart';
import '../services/api_service.dart';

class AuthController extends GetxController {
  final ApiService _apiService = Get.find();

  var isLoading = false.obs;
  var isLoggedIn = false.obs;

  Future<void> login(String username, String password) async {
    if (username.isEmpty || password.isEmpty) {
      Get.snackbar('Erro', 'Usuário e senha são obrigatórios');
      return;
    }

    try {
      isLoading.value = true;
      //final result = await _apiService.login(username, password);

      //if (result['success'] == true) {
      //  isLoggedIn.value = true;
      Get.offNamed('/dashboard');
      Get.snackbar('Sucesso', 'Login realizado com sucesso!');
      // } else {
      //   Get.snackbar('Erro', 'Credenciais inválidas');
      //  }
    } catch (e) {
      Get.snackbar('Erro', 'Erro ao fazer login: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void logout() {
    isLoggedIn.value = false;
    Get.offAllNamed('/login');
  }
}
