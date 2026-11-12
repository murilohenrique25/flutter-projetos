import 'package:get/get.dart';
import '../services/api_service.dart';
import 'package:intl/intl.dart';

class DashboardController extends GetxController {
  final ApiService _apiService = Get.find();

  var isLoading = false.obs;
  var recycledMaterialsQuantity = 0.obs;
  var purchasesQuantity = 0.obs;
  var totalPurchasesValue = 0.0.obs;
  var totalExpensesValue = 0.0.obs;
  var currentDate = ''.obs;

  @override
  void onInit() {
    super.onInit();
    updateCurrentDate();
    loadDashboardData();
  }

  void updateCurrentDate() {
    final now = DateTime.now();
    currentDate.value = DateFormat('dd/MM/yyyy').format(now);
  }

  Future<void> loadDashboardData() async {
    try {
      isLoading.value = true;
      final data = await _apiService.getDashboardData();

      recycledMaterialsQuantity.value = data['recycledMaterialsQuantity'] ?? 0;
      purchasesQuantity.value = data['purchasesQuantity'] ?? 0;
      totalPurchasesValue.value = (data['totalPurchasesValue'] ?? 0).toDouble();
      totalExpensesValue.value = (data['totalExpensesValue'] ?? 0).toDouble();
    } catch (e) {
      Get.snackbar('Erro', 'Erro ao carregar dados: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
