import 'package:gestao_rural/controllers/animal_controller.dart';
import 'package:gestao_rural/controllers/avalicao_ginecogolica_controller.dart';
import 'package:gestao_rural/controllers/diagnostico_controller.dart';
import 'package:gestao_rural/controllers/fazenda_controller.dart';
import 'package:gestao_rural/controllers/inseminacao_controller.dart';
import 'package:gestao_rural/controllers/parto_controller.dart';
import 'package:gestao_rural/controllers/sanitario_controller.dart';
import 'package:gestao_rural/views/animal/animal_listagem_view.dart';
import 'package:gestao_rural/views/animal/cadastro_animal_view.dart';
import 'package:gestao_rural/views/avaliacao-ginecologica/cadastro_avaliacao_ginecologica_view.dart';
import 'package:gestao_rural/views/avaliacao-ginecologica/listagem_avaliacao_ginecologica_view.dart';
import 'package:gestao_rural/views/dg/cadastro_diagnostico_gestacao.dart';
import 'package:gestao_rural/views/dg/listagem_diagnostico_gestacao.dart';
import 'package:gestao_rural/views/fazenda_view.dart';
import 'package:gestao_rural/views/inseminacao/cadastro_inseminacao.dart';
import 'package:gestao_rural/views/inseminacao/listagem_inseminacao.dart';
import 'package:gestao_rural/views/login_view.dart';
import 'package:gestao_rural/views/parto/listagem_parto_view.dart';
import 'package:gestao_rural/views/sanitario/cadastro_sanitario_view.dart';
import 'package:gestao_rural/views/sanitario/sanitario_listagem_view.dart';
import 'package:get/get.dart';

class AppRoutes {
  static const initial = '/login';
  static const fazenda = '/fazenda';
  static const listaAnimais = '/lista-animais';
  static const cadastradoAnimal = '/cadastro-animal';
  static const listaSanitarios = '/lista-sanitarios';
  static const cadastroSanitario = '/cadastro-sanitario';
  static const cadastroAvaliacaoGinecologica = '/cadastro-avaliacao';
  static const listagemAvaliacoesGinecologica = '/lista-avaliacoes';
  static const cadastroInseminacao = '/cadastro-inseminacao';
  static const listagemInseminacao = '/lista-inseminacao';
  static const cadastroDiagnostico = '/cadastro-diagnostico';
  static const listagemDiagnostico = '/lista-diagnostico';
  static const listagemParto = '/lista-partos';

  static final routes = [
    GetPage(
      name: initial,
      page: () => LoginView(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: fazenda,
      page: () => FazendaView(),
      binding: BindingsBuilder(() {
        Get.put(FazendaController());
      }),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: listaAnimais,
      page: () => AnimaisListagemView(),
      binding: BindingsBuilder(() {
        Get.put(AnimalController());
      }),
    ),
    GetPage(
      name: cadastradoAnimal,
      page: () => CadastroAnimalView(),
      binding: BindingsBuilder(() {
        Get.put(AnimalController());
      }),
    ),
    GetPage(
      name: listaSanitarios,
      page: () => SanitariosListagemView(),
      binding: BindingsBuilder(() {
        Get.put(AnimalController());
        Get.put(SanitarioController());
      }),
    ),
    GetPage(
      name: cadastroSanitario,
      page: () => CadastroSanitarioView(),
      binding: BindingsBuilder(() {
        Get.put(AnimalController());
        Get.put(SanitarioController());
      }),
    ),
    GetPage(
      name: cadastroAvaliacaoGinecologica,
      page: () => CadastroAvaliacaoGinecologicaView(),
      binding: BindingsBuilder(() {
        Get.put(AnimalController());
        Get.put(AvalicaoGinecologicaController());
      }),
    ),
    GetPage(
      name: listagemAvaliacoesGinecologica,
      page: () => AvalicaoGinecologicaListagemView(),
      binding: BindingsBuilder(() {
        Get.put(AnimalController());
        Get.put(AvalicaoGinecologicaController());
      }),
    ),
    GetPage(
      name: listagemInseminacao,
      page: () => InseminacaoListagemView(),
      binding: BindingsBuilder(() {
        Get.put(AnimalController());
        Get.put(InseminacaoController());
      }),
    ),
    GetPage(
      name: cadastroInseminacao,
      page: () => CadastroInseminacaoView(),
      binding: BindingsBuilder(() {
        Get.put(AnimalController());
        Get.put(InseminacaoController());
      }),
    ),
    GetPage(
      name: cadastroDiagnostico,
      page: () => CadastroDiagnosticoGestacaoView(),
      binding: BindingsBuilder(() {
        Get.put(AnimalController());
        Get.put(InseminacaoController());
        Get.put(DiagnosticoGestacaoController());
      }),
    ),
    GetPage(
      name: listagemDiagnostico,
      page: () => DiagnosticoGestacaoListagemView(),
      binding: BindingsBuilder(() {
        Get.put(AnimalController());
        Get.put(InseminacaoController());
        Get.put(DiagnosticoGestacaoController());
      }),
    ),
    GetPage(
      name: listagemParto,
      page: () => PartoListagemView(),
      binding: BindingsBuilder(() {
        Get.put(AnimalController());
        Get.put(InseminacaoController());
        Get.put(DiagnosticoGestacaoController());
        Get.put(PartoController());
      }),
    ),
  ];
}
