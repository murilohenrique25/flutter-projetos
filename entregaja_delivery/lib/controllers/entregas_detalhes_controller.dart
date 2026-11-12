import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/location_service.dart';
import '../services/websocket_service.dart';
import '../services/api_service.dart';
import '../models/storage_service.dart';
import '../models/entrega_model.dart';
import '../controllers/entrega_ativa_controller.dart';
import '../controllers/entregas_selecionadas_controller.dart';
import '../routes/app_pages.dart';

class EntregasDetalhesController extends GetxController {
  final LocationService locationService = Get.find<LocationService>();
  final WebSocketService wsService = Get.find<WebSocketService>();
  final StorageService storage = Get.find<StorageService>();
  final EntregaAtivaController entregaAtivaCtrl =
      Get.find<EntregaAtivaController>();
  final ApiService apiService = ApiService();

  final RxBool isRastreando = false.obs;
  final RxBool isFinalizando = false.obs;
  final RxBool isIniciando = false.obs; // 🆕

  Rx<EntregaModel?> entregaAtual = Rx<EntregaModel?>(null);

  @override
  void onInit() {
    super.onInit();

    if (Get.arguments != null && Get.arguments is EntregaModel) {
      entregaAtual.value = Get.arguments as EntregaModel;

      // Se a entrega já está em rota, reconectar WebSocket e GPS
      if (entregaAtual.value!.isEmRota) {
        isRastreando.value = true;
        entregaAtivaCtrl.iniciarEntrega(entregaAtual.value!);
        _reconectarRastreamento(entregaAtual.value!);
      }
    }
  }

  /// Reconecta WebSocket e GPS para entrega que já estava em rota
  Future<void> _reconectarRastreamento(EntregaModel entrega) async {
    try {
      final usuario = storage.getUsuarioLogado();
      if (usuario == null) return;

      // Garantir que não há rastreamento anterior ativo
      if (locationService.isTracking.value) {
        await locationService.stopTracking();
        await Future.delayed(const Duration(milliseconds: 300));
      }

      wsService.connect(usuario.token, entrega.idEntrega);
      await Future.delayed(const Duration(milliseconds: 500));

      locationService.onLocationUpdate = (lat, lng) {
        if (wsService.isConnected.value) {
          wsService.sendLocation(lat, lng);
        }
      };

      await locationService.startTracking();
    } catch (_) {
      // Falha silenciosa — usuário pode tentar manualmente
    }
  }

  /// Iniciar rastreamento de entrega
  Future<void> iniciarEntrega() async {
    final entrega = entregaAtual.value;
    if (entrega == null) {
      Get.snackbar('Erro', 'Entrega não encontrada');
      return;
    }

    if (isIniciando.value || isRastreando.value) return;

    // Verificar via API se já existe entrega em rota
    final selecionadasCtrl = Get.find<EntregasSelecionadasController>();
    if (selecionadasCtrl.entregasEmRota.isNotEmpty) {
      final emRota = selecionadasCtrl.entregasEmRota.first;
      Get.snackbar(
        'Entrega em andamento',
        'Finalize a entrega #${emRota.idEntrega} antes de iniciar outra.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
        duration: const Duration(seconds: 4),
      );
      return;
    }

    if (entregaAtivaCtrl.temEntregaAtiva &&
        !entregaAtivaCtrl.isEntregaAtiva(entrega.idEntrega)) {
      Get.snackbar(
        'Atenção',
        'Você já tem uma entrega em andamento. Finalize-a primeiro.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
        duration: Duration(seconds: 4),
      );
      return;
    }

    isIniciando.value = true;

    try {
      if (locationService.isTracking.value) {
        await locationService.stopTracking();
        await Future.delayed(Duration(milliseconds: 500));
      }

      // Obter coordenadas GPS atuais
      final position = await locationService.getCurrentPosition();
      if (position == null) {
        Get.snackbar(
          'Erro',
          'Não foi possível obter a localização. Verifique o GPS.',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      // Chamar API PUT /iniciar/{userId}
      final apiResult = await apiService.iniciarEntregas(
        [entrega.idEntrega],
        position.latitude.toString(),
        position.longitude.toString(),
      );

      if (!apiResult['success']) {
        Get.snackbar(
          'Erro',
          apiResult['message'] ?? 'Falha ao iniciar entrega na API',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.error,
          colorText: Get.theme.colorScheme.onError,
        );
        return;
      }

      // Marcar entrega como ativa localmente
      entregaAtivaCtrl.iniciarEntrega(entrega);

      final usuario = storage.getUsuarioLogado();
      if (usuario == null) {
        Get.snackbar(
          'Erro',
          'Usuário não autenticado',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      wsService.connect(usuario.token, entrega.idEntrega);
      await Future.delayed(Duration(milliseconds: 500));

      locationService.onLocationUpdate = (lat, lng) {
        if (wsService.isConnected.value) {
          wsService.sendLocation(lat, lng);
        }
      };

      await locationService.startTracking();

      if (!locationService.isTracking.value) {
        throw Exception('Falha ao iniciar rastreamento GPS');
      }

      isRastreando.value = true;

      Get.snackbar(
        'Entrega Iniciada',
        'Rastreamento em tempo real ativado',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.primary,
        colorText: Get.theme.colorScheme.onPrimary,
        duration: Duration(seconds: 3),
      );
    } catch (e) {
      await locationService.stopTracking();
      wsService.disconnect();
      entregaAtivaCtrl.finalizarEntrega();

      Get.snackbar(
        'Erro',
        'Não foi possível iniciar a entrega. Tente novamente.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
    } finally {
      isIniciando.value = false;
    }
  }

  /// Para o rastreamento e limpa o estado local
  Future<void> _pararRastreamento() async {
    await locationService.stopTracking();
    wsService.disconnect();
    await Future.delayed(const Duration(milliseconds: 500));
    entregaAtivaCtrl.finalizarEntrega();
    isRastreando.value = false;
  }

  /// Finalizar entrega
  Future<void> finalizarEntrega() async {
    final entrega = entregaAtual.value;
    if (entrega == null) {
      Get.snackbar('Erro', 'Entrega não encontrada');
      return;
    }

    if (isFinalizando.value) return;

    final opcao = await Get.dialog<String>(
      AlertDialog(
        title: const Text('O que deseja fazer?'),
        content: const Text('Escolha uma ação para esta entrega.'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Voltar')),
          OutlinedButton(
            onPressed: () => Get.back(result: 'cancelar'),
            style: OutlinedButton.styleFrom(foregroundColor: Colors.orange),
            child: const Text('Cancelar Entrega'),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: 'finalizar'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Finalizar'),
          ),
        ],
      ),
    );

    if (opcao == null) return;

    if (opcao == 'cancelar') {
      await _pararRastreamento();
      Get.snackbar(
        'Entrega cancelada',
        'A entrega voltou para a lista de selecionadas.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
      Get.offAllNamed(AppPages.entregasSelecionadas);
      return;
    }

    isFinalizando.value = true;

    try {
      final response = await apiService.finalizarEntrega(entrega);

      if (response['success']) {
        await _pararRastreamento();
        Get.snackbar(
          'Sucesso',
          'Entrega finalizada com sucesso!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.primary,
          colorText: Get.theme.colorScheme.onPrimary,
          duration: const Duration(seconds: 3),
        );
        Get.offAllNamed(AppPages.entregasSelecionadas);
      } else {
        Get.snackbar(
          'Erro',
          response['message'] ?? 'Falha ao finalizar entrega',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Erro',
        'Erro ao finalizar entrega. Tente novamente.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isFinalizando.value = false;
    }
  }

  /// Verificar se esta entrega é a ativa
  bool get isEntregaAtiva {
    return entregaAtivaCtrl.isEntregaAtiva(entregaAtual.value?.idEntrega ?? 0);
  }

  @override
  Future<void> onClose() async {
    if (isRastreando.value) {
      await locationService.stopTracking();
      wsService.disconnect();
      await Future.delayed(Duration(milliseconds: 300));
    }
    super.onClose();
  }
}
