import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import '../models/entrega_model.dart';
import '../routes/app_pages.dart';
import '../services/api_service.dart';

class EntregasSelecionadasController extends GetxController {
  final ApiService apiService = ApiService();

  final RxList<EntregaModel> entregasSelecionadas = <EntregaModel>[].obs;
  final RxList<EntregaModel> entregasEmRota = <EntregaModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    buscarEntregasSelecionadas();
  }

  Future<void> buscarEntregasSelecionadas() async {
    isLoading.value = true;

    try {
      final response = await apiService.getEntregasSelecionadas();

      if (response['success']) {
        final List<dynamic> data = response['data'];
        final todas = data.map((item) => EntregaModel.fromJson(item)).toList();

        entregasEmRota.value = todas.where((e) => e.isEmRota).toList();
        entregasSelecionadas.value =
            todas.where((e) => e.isSelecionada).toList();

        // Se não tem nenhuma, voltar para disponíveis após o frame
        if (entregasEmRota.isEmpty && entregasSelecionadas.isEmpty) {
          _voltarParaDisponiveis();
        }
      } else {
        entregasSelecionadas.clear();
        entregasEmRota.clear();
        _voltarParaDisponiveis();
      }
    } catch (e) {
      Get.snackbar(
        'Erro',
        'Erro ao buscar entregas: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
      entregasSelecionadas.clear();
      entregasEmRota.clear();
    } finally {
      isLoading.value = false;
    }
  }

  void abrirDetalhes(EntregaModel entrega) {
    Get.toNamed(AppPages.entregasDetalhes, arguments: entrega);
  }

  void _voltarParaDisponiveis() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Get.back();
      Get.snackbar(
        'Sem entregas',
        'Nenhuma entrega selecionada. Selecione entregas disponíveis.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    });
  }

  Future<void> atualizar() async {
    await buscarEntregasSelecionadas();
  }
}
