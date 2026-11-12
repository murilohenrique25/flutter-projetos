import 'package:gestao_rural/database/animal_service.dart';
import 'package:gestao_rural/model/animal.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class AnimalController extends GetxController {
  // Lista observável de animais
  var animais = <Animal>[].obs;
  var isLoading = false.obs;

  final AnimalService _animalService = AnimalService();

  // Controllers para o formulário
  final TextEditingController numeroBrincoController = TextEditingController();
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController loteController = TextEditingController();
  final TextEditingController pesoNascimentoController =
      TextEditingController();
  final TextEditingController dataNascimentoController =
      TextEditingController();
  final TextEditingController racaController = TextEditingController();
  final TextEditingController quantidadeCiosController =
      TextEditingController();
  final TextEditingController quantidadePartosController =
      TextEditingController();
  final TextEditingController dataInseminacaoController =
      TextEditingController();
  final TextEditingController dataPartoController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    carregarAnimais();
  }

  @override
  void onClose() {
    // Limpar controllers
    numeroBrincoController.dispose();
    nomeController.dispose();
    loteController.dispose();
    pesoNascimentoController.dispose();
    dataNascimentoController.dispose();
    racaController.dispose();
    quantidadeCiosController.dispose();
    quantidadePartosController.dispose();
    dataInseminacaoController.dispose();
    dataPartoController.dispose();
    super.onClose();
  }

  Future<void> carregarAnimais() async {
    isLoading.value = true;
    try {
      final List<Animal> animaisCarregados = await _animalService.listarTodos();

      animais.value = animaisCarregados;
    } catch (e) {
      print('Erro ao carregar animais: $e');

      Get.snackbar(
        'Erro',
        'Não foi possível carregar os animais',
        snackPosition: SnackPosition.BOTTOM,
      );

      animais.value = [];
    } finally {
      isLoading.value = false;
    }
  }

  // Adicionar novo animal
  Future<void> adicionarAnimal() async {
    if (_validarFormulario()) {
      // Mostra loading durante o salvamento
      isLoading.value = true;

      try {
        final novoAnimal = Animal(
          numeroBrinco: numeroBrincoController.text,
          nome: nomeController.text,
          lote: loteController.text,
          pesoNascimento: double.tryParse(pesoNascimentoController.text) ?? 0.0,
          dataNascimento: dataNascimentoController.text,
          raca: racaController.text,
          quantidadeCios: int.tryParse(quantidadeCiosController.text) ?? 0,
          quantidadePartos: int.tryParse(quantidadePartosController.text) ?? 0,
          dataInseminacao: dataInseminacaoController.text,
          dataParto: dataPartoController.text,
        );

        // Salva no banco de dados
        final int id = await _animalService.inserir(novoAnimal);

        // Se salvou com sucesso, atualiza o ID do animal
        final animalSalvo = novoAnimal.copyWith(id: id);

        // Adiciona à lista local
        animais.add(animalSalvo);

        // Limpa o formulário
        _limparFormulario();

        // Volta para a tela anterior
        Get.back();

        // Mostra mensagem de sucesso
        Get.snackbar(
          'Sucesso',
          'Animal cadastrado com sucesso!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 3),
        );
      } catch (e) {
        // Trata erros de salvamento
        print('Erro ao salvar animal: $e');

        Get.snackbar(
          'Erro',
          'Não foi possível cadastrar o animal. Tente novamente.',
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

  // Método para excluir animal
  Future<void> excluirAnimal(Animal animal) async {
    // Confirmação antes de excluir
    final bool? confirmar = await Get.dialog<bool>(
      AlertDialog(
        title: Text('Confirmar exclusão'),
        content: Text('Deseja realmente excluir o animal "${animal.nome}"?'),
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
        await _animalService.deletar(animal.id);

        // Remove da lista local
        animais.removeWhere((a) => a.id == animal.id);

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
          'Não foi possível excluir o animal. Tente novamente.',
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

  // Método para atualizar animal existente
  Future<void> atualizarAnimal(Animal animal) async {
    if (_validarFormulario()) {
      isLoading.value = true;

      try {
        final animalAtualizado = animal.copyWith(
          numeroBrinco: numeroBrincoController.text,
          nome: nomeController.text,
          lote: loteController.text,
          pesoNascimento: double.tryParse(pesoNascimentoController.text) ?? 0.0,
          dataNascimento: dataNascimentoController.text,
          raca: racaController.text,
          quantidadeCios: int.tryParse(quantidadeCiosController.text) ?? 0,
          quantidadePartos: int.tryParse(quantidadePartosController.text) ?? 0,
          dataInseminacao: dataInseminacaoController.text,
          dataParto: dataPartoController.text,
        );

        // Atualiza no banco de dados
        await _animalService.atualizar(animalAtualizado);

        // Atualiza na lista local
        final index = animais.indexWhere((a) => a.id == animal.id);
        if (index != -1) {
          animais[index] = animalAtualizado;
        }

        _limparFormulario();
        Get.back();

        Get.snackbar(
          'Sucesso',
          'Animal atualizado com sucesso!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 3),
        );
      } catch (e) {
        print('Erro ao atualizar animal: $e');

        Get.snackbar(
          'Erro',
          'Não foi possível atualizar o animal. Tente novamente.',
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
    if (numeroBrincoController.text.isEmpty) {
      _mostrarErro('Número do brinco é obrigatório');
      return false;
    }
    if (nomeController.text.isEmpty) {
      _mostrarErro('Nome é obrigatório');
      return false;
    }
    if (loteController.text.isEmpty) {
      _mostrarErro('Lote é obrigatório');
      return false;
    }
    if (pesoNascimentoController.text.isEmpty) {
      _mostrarErro('Peso no nascimento é obrigatório');
      return false;
    }
    if (dataNascimentoController.text.isEmpty) {
      _mostrarErro('Data de nascimento é obrigatória');
      return false;
    }
    if (racaController.text.isEmpty) {
      _mostrarErro('Raça é obrigatória');
      return false;
    }

    // Verificar se número do brinco já existe
    if (animais.any(
      (animal) => animal.numeroBrinco == numeroBrincoController.text,
    )) {
      _mostrarErro('Já existe um animal com esse número de brinco');
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
    numeroBrincoController.clear();
    nomeController.clear();
    loteController.clear();
    pesoNascimentoController.clear();
    dataNascimentoController.clear();
    racaController.clear();
    quantidadeCiosController.clear();
    quantidadePartosController.clear();
    dataInseminacaoController.clear();
    dataPartoController.clear();
  }

  // Abrir tela de cadastro
  void abrirCadastroAnimal() {
    _limparFormulario();
    Get.toNamed('/cadastro-animal');
  }

  // Voltar para tela anterior
  void voltar() {
    Get.back();
  }
}
