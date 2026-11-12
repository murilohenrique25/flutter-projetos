import 'package:get/get.dart';
import '../services/api_service.dart';

class UnitController extends GetxController {
  final ApiService _apiService = Get.find();

  var isLoading = false.obs;

  Future<void> saveUnit(String type, double value) async {
    if (type.isEmpty || value <= 0) {
      Get.snackbar('Erro', 'Preencha todos os campos corretamente');
      return;
    }

    try {
      isLoading.value = true;
      await _apiService.saveUnit(type, value);
      Get.snackbar('Sucesso', 'Unidade salva com sucesso!');
      Get.back();
    } catch (e) {
      Get.snackbar('Erro', 'Erro ao salvar unidade: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
