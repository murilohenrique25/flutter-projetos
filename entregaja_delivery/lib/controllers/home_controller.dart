import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import '../services/api_service.dart';
import '../routes/app_pages.dart';
import '../models/entrega_model.dart';

class HomeController extends GetxController {
  final ApiService _apiService = ApiService();
  final isLoading = false.obs;
  final data = <Map<String, int>>[].obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchData();
    _verificarEntregasAtivas();
  }

  /// Verifica se há entregas em rota ou selecionadas e redireciona
  Future<void> _verificarEntregasAtivas() async {
    try {
      final response = await _apiService.getEntregasSelecionadas();
      if (!response['success']) return;

      final List<dynamic> data = response['data'];
      final todas = data.map((e) => EntregaModel.fromJson(e)).toList();

      final emRota = todas.where((e) => e.isEmRota).toList();
      final selecionadas = todas.where((e) => e.isSelecionada).toList();

      if (emRota.isNotEmpty) {
        // Tem entrega em rota — abrir direto nos detalhes
        SchedulerBinding.instance.addPostFrameCallback((_) {
          Get.toNamed(AppPages.entregasDetalhes, arguments: emRota.first);
        });
      } else if (selecionadas.isNotEmpty) {
        // Tem entregas selecionadas — abrir lista
        SchedulerBinding.instance.addPostFrameCallback((_) {
          Get.toNamed(AppPages.entregasSelecionadas);
        });
      }
    } catch (_) {
      // Silencioso — não bloquear a home em caso de erro
    }
  }

  Future<void> fetchData() async {
    isLoading.value = true;
    errorMessage.value = '';
    data.clear();

    try {
      final List<Map<String, int>> response = await _apiService.getData();
      print(response);
      data.assignAll(response);
    } catch (e) {
      errorMessage.value = 'Erro ao buscar dados: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  // 🔧 CORRIGIR - buscar entregas e passar a lista
  Future<void> executeAction1() async {
    isLoading.value = true;

    try {
      // Buscar entregas do tipo "Venda Balcão"
      final response = await _apiService.getEntregas('Venda Balcão');

      if (response['success']) {
        final List<dynamic> data = response['data'];
        final List<EntregaModel> entregas =
            data.map((item) => EntregaModel.fromJson(item)).toList();

        // Passar a LISTA de entregas como argumento
        Get.toNamed(AppPages.entregas, arguments: entregas);
      } else {
        Get.snackbar(
          'Erro',
          'Falha ao buscar entregas',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Erro',
        'Erro ao buscar entregas: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // 🔧 CORRIGIR - buscar entregas e passar a lista
  Future<void> executeAction2() async {
    isLoading.value = true;

    try {
      // Buscar entregas do tipo "Manipulação"
      final response = await _apiService.getEntregas('Manipulação');

      if (response['success']) {
        final List<dynamic> data = response['data'];
        final List<EntregaModel> entregas =
            data.map((item) => EntregaModel.fromJson(item)).toList();

        // Passar a LISTA de entregas como argumento
        Get.toNamed(AppPages.entregas, arguments: entregas);
      } else {
        Get.snackbar(
          'Erro',
          'Falha ao buscar entregas',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Erro',
        'Erro ao buscar entregas: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  int getQuantidadePorTipo(String tipo) {
    return data.firstWhere(
      (element) => element.containsKey(tipo),
      orElse: () => {tipo: 0},
    )[tipo]!;
  }
}
