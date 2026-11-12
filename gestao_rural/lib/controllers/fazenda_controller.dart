import 'package:gestao_rural/database/animal_service.dart';
import 'package:gestao_rural/database/inseminacao_service.dart';
import 'package:get/get.dart';

class FazendaController extends GetxController {
  final isLoading = false.obs;
  final totalVacas = 0.obs;
  final vacasInseminadas = 0.obs;

  final AnimalService _animalService = AnimalService();
  final InseminacaoService _inseminacaoService = InseminacaoService();

  // Método para buscar dados do servidor
  void fetchData() async {
    isLoading.value = true;
    // Simulação de requisição
    totalVacas.value = await _animalService.contarAnimais();
    vacasInseminadas.value = await _inseminacaoService.contarInseminacoes();
    isLoading.value = false;
  }

  // Métodos para navegação

  void abrirListaAnimais() {
    Get.toNamed('/lista-animais');
  }

  void abrirSanitario() {
    Get.toNamed('/lista-sanitarios');
  }

  void abrirInseminacoes() {
    Get.toNamed('/lista-inseminacao');
  }

  void abrirAvGinecologica() {
    Get.toNamed('/lista-avaliacoes');
  }

  void abrirDiagnostico() {
    Get.toNamed('/lista-diagnostico');
  }

  void abrirPartos() {
    Get.toNamed('/lista-partos');
  }

  @override
  void onInit() {
    fetchData();
    super.onInit();
  }
}
