import 'package:flutter/material.dart';
import 'package:gestao_rural/controllers/animal_controller.dart';
import 'package:gestao_rural/controllers/diagnostico_controller.dart';
import 'package:gestao_rural/database/parto_service.dart';
import 'package:gestao_rural/model/parto.dart';
import 'package:get/get.dart';

class PartoController extends GetxController {
  var partos = <Parto>[].obs;
  var isLoading = false.obs;

  PartoService _partoService = PartoService();

  // Controllers para o modal de confirmação de parto
  final TextEditingController dataPartoController = TextEditingController();
  var pariuStatus = Rxn<bool>();

  // Referências aos controllers
  late AnimalController animalController;
  late DiagnosticoGestacaoController diagnosticoController;

  @override
  void onInit() {
    super.onInit();
    // Garantir que os controllers estão disponíveis
    animalController = Get.find<AnimalController>();
    diagnosticoController = Get.find<DiagnosticoGestacaoController>();
    carregarPartos();
  }

  @override
  void onClose() {
    dataPartoController.dispose();
    super.onClose();
  }

  // Carregar registros de partos baseados nos diagnósticos positivos
  void carregarPartos() async {
    isLoading.value = true;
    try {
      final List<Parto> partosCarregados =
          await _partoService.listarTodos();

      partos.value = partosCarregados;
    } catch (e) {
      print('Erro ao carregar diagnosticos: $e');

      Get.snackbar(
        'Erro',
        'Não foi possível carregar os diagnósticos',
        snackPosition: SnackPosition.BOTTOM,
      );

      partos.value = [];
    } finally {
      isLoading.value = false;
    }
  }
  void abrirModalConfirmacaoParto(Parto parto) {
    // Limpar dados do modal
    pariuStatus.value = null;
    dataPartoController.clear();

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(Get.context!).size.height * 0.8,
            maxWidth: MediaQuery.of(Get.context!).size.width * 0.9,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header fixo
              Container(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Confirmação de Parto',
                        style: TextStyle(
                          color: const Color.fromARGB(255, 20, 120, 10),
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: Icon(Icons.close, size: 20),
                      padding: EdgeInsets.all(4),
                    ),
                  ],
                ),
              ),

              // Conteúdo scrollável
              Flexible(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Informações do animal
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.green[50],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.green[200]!),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Animal: ${parto.animal.nome}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: const Color.fromARGB(255, 20, 120, 10),
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Brinco: ${parto.animal.numeroBrinco}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[700],
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Data Prevista: ${parto.dataPrevisaoParto}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 20),

                      Text(
                        'Pariu?',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 20, 120, 10),
                        ),
                      ),
                      SizedBox(height: 8),

                      Obx(
                        () => Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey[300]!),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                children: [
                                  RadioListTile<bool>(
                                    title: Text(
                                      'Sim',
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    value: true,
                                    groupValue: pariuStatus.value,
                                    onChanged: (value) {
                                      pariuStatus.value = value;
                                    },
                                    activeColor: const Color.fromARGB(
                                      255,
                                      20,
                                      120,
                                      10,
                                    ),
                                    dense: true,
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                  ),
                                  Divider(height: 1, color: Colors.grey[300]),
                                  RadioListTile<bool>(
                                    title: Text(
                                      'Não',
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    value: false,
                                    groupValue: pariuStatus.value,
                                    onChanged: (value) {
                                      pariuStatus.value = value;
                                    },
                                    activeColor: const Color.fromARGB(
                                      255,
                                      20,
                                      120,
                                      10,
                                    ),
                                    dense: true,
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      Obx(
                        () =>
                            pariuStatus.value == true
                                ? Container(
                                  margin: EdgeInsets.only(top: 16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Data do Parto:',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: const Color.fromARGB(
                                            255,
                                            20,
                                            120,
                                            10,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      TextField(
                                        controller: dataPartoController,
                                        decoration: InputDecoration(
                                          hintText: 'dd/mm/aaaa',
                                          hintStyle: TextStyle(
                                            color: Colors.grey[400],
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            borderSide: BorderSide(
                                              color: const Color.fromARGB(
                                                255,
                                                20,
                                                120,
                                                10,
                                              ),
                                            ),
                                          ),
                                          contentPadding: EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 10,
                                          ),
                                          prefixIcon: Icon(
                                            Icons.calendar_today,
                                            color: Colors.grey[600],
                                            size: 20,
                                          ),
                                        ),
                                        keyboardType: TextInputType.datetime,
                                      ),
                                    ],
                                  ),
                                )
                                : SizedBox.shrink(),
                      ),
                    ],
                  ),
                ),
              ),

              // Botões fixos na parte inferior
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                  border: Border(top: BorderSide(color: Colors.grey[200]!)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Get.back(),
                      child: Text(
                        'Cancelar',
                        style: TextStyle(color: Colors.grey[600], fontSize: 15),
                      ),
                    ),
                    SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () => _salvarConfirmacaoParto(parto),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 20, 120, 10),
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Salvar',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }

  void _salvarConfirmacaoParto(Parto parto) {
    if (pariuStatus.value == null) {
      _mostrarErro('Selecione se o animal pariu ou não');
      return;
    }

    if (pariuStatus.value == true && dataPartoController.text.isEmpty) {
      _mostrarErro('Informe a data do parto');
      return;
    }

    // Atualizar o parto na lista
    int index = partos.indexWhere((p) => p.id == parto.id);
    if (index != -1) {
      partos[index] = Parto(
        id: parto.id,
        animal: parto.animal,
        diagnosticoGestacao: parto.diagnosticoGestacao,
        dataPrevisaoParto: parto.dataPrevisaoParto,
        pariu: pariuStatus.value!,
        dataPartoRealizada:
            pariuStatus.value == true ? dataPartoController.text : null,
      );
    }

    Get.back();

    String mensagem =
        pariuStatus.value!
            ? 'Parto confirmado com sucesso!'
            : 'Status atualizado: animal não pariu ainda';

    Get.snackbar(
      'Sucesso',
      mensagem,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  // Mostrar erro
  void _mostrarErro(String mensagem) {
    Get.snackbar(
      'Erro',
      mensagem,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void voltar() {
    Get.back();
  }

  bool get temDiagnosticosPositivos =>
      diagnosticoController.diagnosticos.any((d) => d.prenha);

  // Atualizar partos quando diagnósticos mudarem
  void atualizarPartos() {
    carregarPartos();
  }
}
