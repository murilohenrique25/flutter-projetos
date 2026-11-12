import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/api_service.dart';
import '../models/purchase_item.dart';
import 'package:intl/intl.dart';

class ShoppingController extends GetxController {
  final ApiService _apiService = Get.find();

  var isLoading = false.obs;
  var materials = <String>[].obs;
  var units = <Map<String, dynamic>>[].obs;
  var purchaseItems = <PurchaseItem>[].obs;
  var currentDateTime = ''.obs;

  var selectedMaterial = ''.obs;
  var quantity = 0.0.obs;
  var unitValue = 0.0.obs;
  var selectedUnit = ''.obs;

  @override
  void onInit() {
    super.onInit();
    updateCurrentDateTime();
    loadMaterials();
    loadUnits();
  }

  void updateCurrentDateTime() {
    final now = DateTime.now();
    currentDateTime.value = DateFormat('dd/MM/yyyy HH:mm').format(now);
  }

  Future<void> loadMaterials() async {
    try {
      final data = await _apiService.getMaterials();
      materials.value = data.map((item) => item['name'].toString()).toList();
    } catch (e) {
      Get.snackbar('Erro', 'Erro ao carregar materiais recicláveis: $e');
    }
  }

  Future<void> loadUnits() async {
    try {
      final data = await _apiService.getUnits();
      units.value = List<Map<String, dynamic>>.from(data);
    } catch (e) {
      Get.snackbar('Erro', 'Erro ao carregar unidades: $e');
    }
  }

  void addItem() {
    if (selectedMaterial.isEmpty ||
        quantity.value <= 0 ||
        unitValue.value <= 0 ||
        selectedUnit.isEmpty) {
      Get.snackbar('Erro', 'Preencha todos os campos');
      return;
    }

    final totalValue = quantity.value * unitValue.value;
    final item = PurchaseItem(
      recyclableMaterial: selectedMaterial.value,
      quantity: quantity.value,
      unitValue: unitValue.value,
      totalValue: totalValue,
      unit: selectedUnit.value,
    );

    purchaseItems.add(item);
    clearFields();
  }

  void removeItem(int index) {
    purchaseItems.removeAt(index);
  }

  void clearFields() {
    selectedMaterial.value = '';
    quantity.value = 0.0;
    unitValue.value = 0.0;
    selectedUnit.value = '';
  }

  double getTotalPurchaseValue() {
    return purchaseItems.fold(0.0, (sum, item) => sum + item.totalValue);
  }

  Future<void> finalizePurchase() async {
    if (purchaseItems.isEmpty) {
      Get.snackbar('Erro', 'Adicione pelo menos um item');
      return;
    }

    try {
      isLoading.value = true;
      final purchase = {
        'items': purchaseItems.map((item) => item.toJson()).toList(),
        'totalValue': getTotalPurchaseValue(),
        'date': DateTime.now().toIso8601String(),
      };

      await _apiService.savePurchase(purchase);

      Get.dialog(
        AlertDialog(
          title: Text('Compra de Recicláveis Finalizada'),
          content: Text('Deseja emitir recibo para o fornecedor?'),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
                purchaseItems.clear();
                Get.snackbar('Sucesso', 'Compra salva com sucesso!');
              },
              child: Text('Não'),
            ),
            ElevatedButton(
              onPressed: () {
                Get.back();
                Get.toNamed(
                  '/receipt',
                  arguments: {
                    'items': purchaseItems.toList(),
                    'total': getTotalPurchaseValue(),
                  },
                );
              },
              child: Text('Sim'),
            ),
          ],
        ),
      );
    } catch (e) {
      Get.snackbar('Erro', 'Erro ao finalizar compra: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
