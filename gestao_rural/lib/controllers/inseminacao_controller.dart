import 'package:flutter/material.dart';
import 'package:gestao_rural/controllers/animal_controller.dart';
import 'package:gestao_rural/database/animal_service.dart';
import 'package:gestao_rural/database/inseminacao_service.dart';
import 'package:gestao_rural/model/animal.dart';
import 'package:gestao_rural/model/inseminacao.dart';
import 'package:get/get.dart';

class InseminacaoController extends GetxController {
  var inseminacoes = <Inseminacao>[].obs;
  var isLoading = false.obs;
  final InseminacaoService _inseminacaoService = InseminacaoService();
  final AnimalService _animalService = AnimalService();

  var animalSelecionado = Rxn<Animal>();
  // Dados para formulário
  var inseminacaoSelecionada = Rxn<Inseminacao>();
  final TextEditingController dataInseminacaoController =
      TextEditingController();
  var tipoInseminacaoSelecionado = Rxn<String>();

  // Tipos de inseminação disponíveis
  final List<String> tiposInseminacao = ['IA', 'IATF'];

  // Referência ao controller de animais
  late AnimalController animalController;

  void abrirCadastroInseminacao() {
    _limparFormulario();
    Get.toNamed('/cadastro-inseminacao');
  }

  @override
  void onInit() {
    super.onInit();
    // Garantir que o AnimalController está disponível
    animalController = Get.find<AnimalController>();
    carregarInseminacoes();
  }

  @override
  void onClose() {
    dataInseminacaoController.dispose();
    super.onClose();
  }

  // Carregar registros de inseminação
  void carregarInseminacoes() async {
    isLoading.value = true;
    try {
      final List<Inseminacao> inseminacaoCarregadas =
          await _inseminacaoService.listarTodos();

      inseminacoes.value = inseminacaoCarregadas;
    } catch (e) {
      print('Erro ao carregar inseminações: $e');

      Get.snackbar(
        'Erro',
        'Não foi possível carregar as inseminações',
        snackPosition: SnackPosition.BOTTOM,
      );

      inseminacoes.value = [];
    } finally {
      isLoading.value = false;
    }
  }

  void adicionarInseminacao() async {
    if (_validarFormulario()) {
      isLoading.value = true;
      try {
        Animal animal = animalSelecionado.value!;
        final novaInseminacao = Inseminacao(
          animal: animal,
          dataInseminacao: dataInseminacaoController.text,
          tipoInseminacao: tipoInseminacaoSelecionado.value!,
        );
        await _inseminacaoService.inserir(novaInseminacao);
        animal.dataInseminacao = dataInseminacaoController.text;
        await _animalService.atualizar(animal);
        inseminacoes.add(novaInseminacao);
        _limparFormulario();
        Get.back();
        Get.snackbar(
          'Sucesso',
          'Registro de inseminação cadastrado com sucesso!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      } catch (e) {
        // Trata erros de salvamento
        print('Erro ao salvar inseminação: $e');

        Get.snackbar(
          'Erro',
          'Não foi possível cadastrar a inseminação. Tente novamente.',
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
    dataInseminacaoController.clear();
    tipoInseminacaoSelecionado.value = null;
  }

  // Validar formulário
  bool _validarFormulario() {
    if (animalSelecionado.value == null) {
      _mostrarErro('Selecione um animal');
      return false;
    }

    if (dataInseminacaoController.text.isEmpty) {
      _mostrarErro('Data da inseminação é obrigatória');
      return false;
    }

    if (tipoInseminacaoSelecionado.value == null) {
      _mostrarErro('Selecione o tipo de inseminação');
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

  // Remover registro sanitário
  void removerInseminacao(Inseminacao inseminacao) async {
    final bool? confirmar = await Get.dialog<bool>(
      AlertDialog(
        title: Text('Confirmar Remoção'),
        content: Text(
          'Deseja realmente remover o registro de inseminação do animal ${inseminacao.animal.nome}?',
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
        await _inseminacaoService.deletar(inseminacao.id);

        // Remove da lista local
        inseminacoes.removeWhere((a) => a.id == inseminacao.id);

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
          'Não foi possível excluir a inseminação. Tente novamente.',
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

  void selecionarTipoInseminacao(String tipo) {
    tipoInseminacaoSelecionado.value = tipo;
  }

  // Obter lista de animais disponíveis
  List<Animal> get animaisDisponiveis => animalController.animais;
}
