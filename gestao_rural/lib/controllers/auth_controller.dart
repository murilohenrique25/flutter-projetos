import 'package:gestao_rural/routes/app_routes.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  Future<void> login(String user, String password) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      if (user == 'admin' && password == 'admin') {
        Get.toNamed(AppRoutes.fazenda);
      } else {
        errorMessage.value = 'Usuario ou senha inválido';
      }
    } catch (e) {
      errorMessage.value = 'Erro na conexão';
    } finally {
      isLoading.value = false;
    }
  }

  void logout() {
    // Aqui você adicionaria a lógica para limpar dados de sessão, tokens, etc.
    Get.offAllNamed('/login');
  }
}
