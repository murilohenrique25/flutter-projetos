import 'package:get/get.dart';
import '../services/api_service.dart';

class ExpenseController extends GetxController {
  final ApiService _apiService = Get.find();

  var isLoading = false.obs;

  Future<void> saveExpense(String name, double value) async {
    if (name.isEmpty || value <= 0) {
      Get.snackbar('Erro', 'Preencha todos os campos corretamente');
      return;
    }

    try {
      isLoading.value = true;
      await _apiService.saveExpense(name, value);
      Get.snackbar('Sucesso', 'Despesa salva com sucesso!');
      Get.back();
    } catch (e) {
      Get.snackbar('Erro', 'Erro ao salvar despesa: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
