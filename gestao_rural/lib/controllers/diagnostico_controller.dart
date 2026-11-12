import 'package:flutter/material.dart';
import 'package:gestao_rural/controllers/animal_controller.dart';
import 'package:gestao_rural/controllers/inseminacao_controller.dart';
import 'package:gestao_rural/database/animal_service.dart';
import 'package:gestao_rural/database/diagnostico_gestacao_service.dart';
import 'package:gestao_rural/database/parto_service.dart';
import 'package:gestao_rural/model/animal.dart';
import 'package:gestao_rural/model/inseminacao.dart';
import 'package:gestao_rural/model/diagnostico_gestacao.dart';
import 'package:gestao_rural/model/parto.dart';
import 'package:get/get.dart';

class DiagnosticoGestacaoController extends GetxController {
  var diagnosticos = <DiagnosticoGestacao>[].obs;
  var isLoading = false.obs;
  final DiagnosticoGestacaoService _diagnosticoGestacaoService =
      DiagnosticoGestacaoService();

  final AnimalService _animalService = AnimalService();
  final PartoService _partoService = PartoService();

  var animalSelecionado = Rxn<Animal>();
  var inseminacaoSelecionada = Rxn<Inseminacao>();
  var diagnosticoSelecionado = Rxn<DiagnosticoGestacao>();

  // Dados para formulário
  final TextEditingController dataDiagnosticoController =
      TextEditingController();
  var prenhaStatus = Rxn<bool>();

  // Opções de prenha
  final List<Map<String, dynamic>> opcoesPrenha = [
    {'label': 'Sim - Prenha Confirmada', 'value': true},
    {'label': 'Não - Não Prenha', 'value': false},
  ];

  // Referências aos controllers
  late AnimalController animalController;
  late InseminacaoController inseminacaoController;

  void abrirCadastroDiagnostico() {
    _limparFormulario();
    Get.toNamed('/cadastro-diagnostico');
  }

  @override
  void onInit() {
    super.onInit();
    // Garantir que os controllers estão disponíveis
    animalController = Get.find<AnimalController>();
    inseminacaoController = Get.find<InseminacaoController>();
    carregarDiagnosticos();
  }

  @override
  void onClose() {
    dataDiagnosticoController.dispose();
    super.onClose();
  }

  // Carregar registros de diagnóstico
  void carregarDiagnosticos() async {
    isLoading.value = true;
    try {
      final List<DiagnosticoGestacao> animaisCarregados =
          await _diagnosticoGestacaoService.listarTodos();

      diagnosticos.value = animaisCarregados;
    } catch (e) {
      print('Erro ao carregar diagnosticos: $e');

      Get.snackbar(
        'Erro',
        'Não foi possível carregar os diagnósticos',
        snackPosition: SnackPosition.BOTTOM,
      );

      diagnosticos.value = [];
    } finally {
      isLoading.value = false;
    }
  }

  void adicionarDiagnostico() async {
    if (_validarFormulario()) {
      isLoading.value = true;

      try {
        Animal animal = animalSelecionado.value!;
        final novoDiagnostico = DiagnosticoGestacao(
          animal: animal,
          inseminacao: inseminacaoSelecionada.value!,
          prenha: prenhaStatus.value!,
          dataDiagnostico: dataDiagnosticoController.text,
        );

        int id = await _diagnosticoGestacaoService.inserir(novoDiagnostico);
        novoDiagnostico.id = id;
        if (prenhaStatus.value!) {
          animal.quantidadeCios = animal.quantidadeCios + 1;
          await _animalService.atualizar(animal);
          Parto parto = Parto(
            animal: animal,
            diagnosticoGestacao: novoDiagnostico,
            dataPrevisaoParto: _calcularDataPrevisaoParto(
              inseminacaoSelecionada.value!.dataInseminacao,
            ),
          );
          await _partoService.inserir(parto);
        }

        diagnosticos.add(novoDiagnostico);
        _limparFormulario();
        Get.back();
        Get.snackbar(
          'Sucesso',
          'Diagnóstico de gestação cadastrado com sucesso!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      } catch (e) {
        // Trata erros de salvamento
        print('Erro ao salvar diagnóstico: $e');

        Get.snackbar(
          'Erro',
          'Não foi possível cadastrar o diagnóstico. Tente novamente.',
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

  String _calcularDataPrevisaoParto(String dataInseminacao) {
    try {
      // Assumindo formato dd/MM/yyyy
      List<String> partes = dataInseminacao.split('/');
      DateTime dataInsemin = DateTime(
        int.parse(partes[2]),
        int.parse(partes[1]),
        int.parse(partes[0]),
      );

      DateTime dataPrevisao = dataInsemin.add(Duration(days: 280));

      return '${dataPrevisao.day.toString().padLeft(2, '0')}/${dataPrevisao.month.toString().padLeft(2, '0')}/${dataPrevisao.year}';
    } catch (e) {
      return 'Data não calculada';
    }
  }

  void _limparFormulario() {
    animalSelecionado.value = null;
    inseminacaoSelecionada.value = null;
    dataDiagnosticoController.clear();
    prenhaStatus.value = null;
  }

  // Validar formulário
  bool _validarFormulario() {
    if (animalSelecionado.value == null) {
      _mostrarErro('Selecione um animal');
      return false;
    }

    if (inseminacaoSelecionada.value == null) {
      _mostrarErro('Selecione uma inseminação');
      return false;
    }

    if (dataDiagnosticoController.text.isEmpty) {
      _mostrarErro('Data do diagnóstico é obrigatória');
      return false;
    }

    if (prenhaStatus.value == null) {
      _mostrarErro('Selecione o status da prenha');
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

  void removerDiagnostico(DiagnosticoGestacao diagnostico) async {
    final bool? confirmar = await Get.dialog<bool>(
      AlertDialog(
        title: Text('Confirmar Remoção'),
        content: Text(
          'Deseja realmente remover o registro de diagnóstico do animal ${diagnostico.animal.nome}?',
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
        await _diagnosticoGestacaoService.deletar(diagnostico.id);

        // Remove da lista local
        diagnosticos.removeWhere((a) => a.id == diagnostico.id);

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
          'Não foi possível excluir o diagnóstico. Tente novamente.',
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
    // Filtrar inseminações do animal selecionado
    inseminacaoSelecionada.value = null;
  }

  void selecionarInseminacao(Inseminacao inseminacao) {
    inseminacaoSelecionada.value = inseminacao;
  }

  void selecionarPrenhaStatus(bool status) {
    prenhaStatus.value = status;
  }

  // Obter lista de animais disponíveis
  List<Animal> get animaisDisponiveis => animalController.animais;

  // Obter inseminações do animal selecionado
  List<Inseminacao> get inseminacoesDoAnimal {
    if (animalSelecionado.value == null) return [];
    return inseminacaoController.inseminacoes
        .where(
          (inseminacao) => inseminacao.animal.id == animalSelecionado.value!.id,
        )
        .toList();
  }

  bool get temAnimaisCadastrados => animalController.animais.isNotEmpty;

  String get statusPrenhaTexto {
    if (prenhaStatus.value == null) return '';
    return prenhaStatus.value! ? 'Prenha Confirmada' : 'Não Prenha';
  }
}
