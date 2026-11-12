import 'package:flutter/material.dart';
import 'package:gestao_rural/controllers/animal_controller.dart';
import 'package:gestao_rural/database/avaliacao_ginecologica.dart';
import 'package:gestao_rural/model/animal.dart';
import 'package:gestao_rural/model/avaliacao_ginecologica.dart';
import 'package:get/get.dart';

class AvalicaoGinecologicaController extends GetxController {
  var avaliacoes = <AvaliacaoGinecologica>[].obs;
  var isLoading = false.obs;
  AvaliacaoGinecologicaService _avaliacaoGinecologicaService =
      AvaliacaoGinecologicaService();

  var animalSelecionado = Rxn<Animal>();
  // Dados para formulário
  var avalaicaoSelecionada = Rxn<AvaliacaoGinecologica>();
  final TextEditingController dataOcorrenciaController =
      TextEditingController();
  final TextEditingController descricaoController = TextEditingController();

  // Referência ao controller de animais
  late AnimalController animalController;

  void abrirCadastroAvaliacao() {
    _limparFormulario();
    Get.toNamed('/cadastro-avaliacao');
  }

  @override
  void onInit() {
    super.onInit();
    // Garantir que o AnimalController está disponível
    animalController = Get.find<AnimalController>();
    carregarAvaliacoes();
  }

  @override
  void onClose() {
    dataOcorrenciaController.dispose();
    descricaoController.dispose();
    super.onClose();
  }

  // Carregar registros avaliacao
  void carregarAvaliacoes() async {
    isLoading.value = true;
    try {
      final List<AvaliacaoGinecologica> animaisCarregados =
          await _avaliacaoGinecologicaService.listarTodos();

      avaliacoes.value = animaisCarregados;
    } catch (e) {
      print('Erro ao carregar avaliações: $e');

      Get.snackbar(
        'Erro',
        'Não foi possível carregar as avaliações',
        snackPosition: SnackPosition.BOTTOM,
      );

      avaliacoes.value = [];
    } finally {
      isLoading.value = false;
    }
  }

  void adicionarAvaliacao() async {
    if (_validarFormulario()) {
      isLoading.value = true;

      try {
        final novaAvaliacao = AvaliacaoGinecologica(
          animal: animalSelecionado.value!,
          dataOcorrencia: dataOcorrenciaController.text,
          descricao: descricaoController.text,
        );

        await _avaliacaoGinecologicaService.inserir(novaAvaliacao);

        avaliacoes.add(novaAvaliacao);
        _limparFormulario();
        Get.back();
        Get.snackbar(
          'Sucesso',
          'Avaliação ginecológica cadastrada com sucesso!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      } catch (e) {
        // Trata erros de salvamento
        print('Erro ao salvar Avaliação ginecológica: $e');

        Get.snackbar(
          'Erro',
          'Não foi possível cadastrar avaliação ginecológica. Tente novamente.',
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

  void _limparFormulario() {
    animalSelecionado.value = null;
    dataOcorrenciaController.clear();
    descricaoController.clear();
  }

  // Validar formulário
  bool _validarFormulario() {
    if (animalSelecionado.value == null) {
      _mostrarErro('Selecione um animal');
      return false;
    }

    if (dataOcorrenciaController.text.isEmpty) {
      _mostrarErro('Data de ocorrência é obrigatória');
      return false;
    }

    if (descricaoController.text.isEmpty) {
      _mostrarErro('Descrição do diagnóstico é obrigatória');
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

  void removerAvaliacao(AvaliacaoGinecologica av) async {
    final bool? confirmar = await Get.dialog<bool>(
      AlertDialog(
        title: Text('Confirmar Remoção'),
        content: Text(
          'Deseja realmente remover o registro de avaliação do animal ${av.animal.nome}?',
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
        await _avaliacaoGinecologicaService.deletar(av.id);

        // Remove da lista local
        avaliacoes.removeWhere((a) => a.id == av.id);

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
          'Não foi possível excluir avaliação. Tente novamente.',
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

  void voltar() {
    Get.back();
  }

  void selecionarAnimal(Animal animal) {
    animalSelecionado.value = animal;
  }

  // Obter lista de animais disponíveis
  List<Animal> get animaisDisponiveis => animalController.animais;
}
