import 'package:gestao_rural/database/sanitario_service.dart';
import 'package:gestao_rural/model/animal.dart';
import 'package:gestao_rural/model/sanitario.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:gestao_rural/controllers/animal_controller.dart';

class SanitarioController extends GetxController {
  // Lista observável de registros sanitários
  var sanitarios = <Sanitario>[].obs;
  var isLoading = false.obs;
  SanitarioService _sanitarioService = SanitarioService();

  // Dados para formulário
  var animalSelecionado = Rxn<Animal>();
  var enfermidadeSelecionada = ''.obs;
  var vacinaSelecionada = ''.obs;
  final TextEditingController dataOcorrenciaController =
      TextEditingController();
  final TextEditingController observacaoController = TextEditingController();

  // Referência ao controller de animais
  late AnimalController animalController;

  @override
  void onInit() {
    super.onInit();
    // Garantir que o AnimalController está disponível
    animalController = Get.find<AnimalController>();
    carregarSanitarios();
  }

  @override
  void onClose() {
    dataOcorrenciaController.dispose();
    observacaoController.dispose();
    super.onClose();
  }

  // Carregar registros sanitários
  void carregarSanitarios() async {
    isLoading.value = true;
    try {
      final List<Sanitario> sanitariosCarregados =
          await _sanitarioService.listarTodos();

      sanitarios.value = sanitariosCarregados;
    } catch (e) {
      print('Erro ao carregar sanitarios: $e');

      Get.snackbar(
        'Erro',
        'Não foi possível carregar os sanitários',
        snackPosition: SnackPosition.BOTTOM,
      );

      sanitarios.value = [];
    } finally {
      isLoading.value = false;
    }
  }

  // Adicionar novo registro sanitário
  Future<void> adicionarSanitario() async {
    if (_validarFormulario()) {
      isLoading.value = true;
      try {
        final novoSanitario = Sanitario(
          animal: animalSelecionado.value!,
          enfermidade: enfermidadeSelecionada.value,
          vacina: vacinaSelecionada.value,
          dataOcorrencia: dataOcorrenciaController.text,
          observacao: observacaoController.text,
        );

        // Salva no banco de dados
        final int id = await _sanitarioService.inserir(novoSanitario);

        final sanitarioSalvo = novoSanitario.copyWith(id: id);

        sanitarios.add(sanitarioSalvo);
        _limparFormulario();
        Get.back();
        Get.snackbar(
          'Sucesso',
          'Registro sanitário cadastrado com sucesso!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      } catch (e) {
        // Trata erros de salvamento

        Get.snackbar(
          'Erro',
          'Não foi possível cadastrar o santário. Tente novamente.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 3),
        );
      } finally {
        isLoading.value = false;
      }
    }
  }

  // Remover registro sanitário
  void removerSanitario(Sanitario sanitario) async {
    final bool? confirmar = await Get.dialog<bool>(
      AlertDialog(
        title: Text('Confirmar exclusão'),
        content: Text(
          'Deseja realmente remover o registro sanitário do animal "${sanitario.animal.nome}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text('Excluir'),
          ),
        ],
      ),
    );
    if (confirmar == true) {
      isLoading.value = true;

      try {
        // Remove do banco de dados
        await _sanitarioService.deletar(sanitario.id);

        // Remove da lista local
        sanitarios.removeWhere((a) => a.id == sanitario.id);

        Get.snackbar(
          'Sucesso',
          'Animal excluído com sucesso!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 3),
        );
      } catch (e) {
        Get.snackbar(
          'Erro',
          'Não foi possível excluir o sanitário. Tente novamente.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 3),
        );
      } finally {
        isLoading.value = false;
      }
    }
  }

  // Validar formulário
  bool _validarFormulario() {
    if (animalSelecionado.value == null) {
      _mostrarErro('Selecione um animal');
      return false;
    }
    if (enfermidadeSelecionada.value.isEmpty) {
      _mostrarErro('Selecione uma enfermidade');
      return false;
    }
    if (vacinaSelecionada.value.isEmpty) {
      _mostrarErro('Selecione uma vacina');
      return false;
    }
    if (dataOcorrenciaController.text.isEmpty) {
      _mostrarErro('Data de ocorrência é obrigatória');
      return false;
    }
    return true;
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

  // Limpar formulário
  void _limparFormulario() {
    animalSelecionado.value = null;
    enfermidadeSelecionada.value = '';
    vacinaSelecionada.value = '';
    dataOcorrenciaController.clear();
    observacaoController.clear();
  }

  // Abrir tela de cadastro
  void abrirCadastroSanitario() {
    _limparFormulario();
    Get.toNamed('/cadastro-sanitario');
  }

  // Voltar para tela anterior
  void voltar() {
    Get.back();
  }

  // Selecionar animal
  void selecionarAnimal(Animal animal) {
    animalSelecionado.value = animal;
  }

  // Selecionar enfermidade
  void selecionarEnfermidade(String enfermidade) {
    enfermidadeSelecionada.value = enfermidade;
  }

  // Selecionar vacina
  void selecionarVacina(String vacina) {
    vacinaSelecionada.value = vacina;
  }

  // Obter lista de animais disponíveis
  List<Animal> get animaisDisponiveis => animalController.animais;
}
