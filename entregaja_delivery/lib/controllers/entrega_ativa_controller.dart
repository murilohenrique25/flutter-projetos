import 'package:get/get.dart';
import '../models/entrega_model.dart';

class EntregaAtivaController extends GetxController {
  // Entrega que está sendo realizada no momento
  final Rxn<EntregaModel> entregaAtiva = Rxn<EntregaModel>();

  // Se há uma entrega em andamento
  bool get temEntregaAtiva => entregaAtiva.value != null;

  // Iniciar uma entrega
  void iniciarEntrega(EntregaModel entrega) {
    if (temEntregaAtiva) {
      Get.snackbar(
        'Atenção',
        'Você já tem uma entrega em andamento. Finalize-a antes de iniciar outra.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
        duration: Duration(seconds: 4),
      );
      return;
    }

    entregaAtiva.value = entrega;
    print('🚀 Entrega iniciada: ${entrega.idEntrega}');
  }

  // Finalizar a entrega ativa
  void finalizarEntrega() {
    if (entregaAtiva.value != null) {
      print('✅ Entrega finalizada: ${entregaAtiva.value!.idEntrega}');
      entregaAtiva.value = null;
    }
  }

  // Verificar se uma entrega específica está ativa
  bool isEntregaAtiva(int idEntrega) {
    return entregaAtiva.value?.idEntrega == idEntrega;
  }
}
