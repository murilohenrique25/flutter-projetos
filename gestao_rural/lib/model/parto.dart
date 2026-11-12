import 'package:gestao_rural/model/animal.dart';
import 'package:gestao_rural/model/diagnostico_gestacao.dart';

class Parto {
  int id;
  Animal animal;
  DiagnosticoGestacao diagnosticoGestacao;
  String dataPrevisaoParto;
  bool pariu;
  String? dataPartoRealizada;

  Parto({
    this.id = 0,
    required this.animal,
    required this.diagnosticoGestacao,
    required this.dataPrevisaoParto,
    this.pariu = false,
    this.dataPartoRealizada,
  });

  String get statusParto {
    if (pariu) {
      return 'Parto Realizado';
    } else {
      return 'Aguardando Parto';
    }
  }

  String get statusPartoDetalhado {
    if (pariu) {
      return 'Parto realizado em ${dataPartoRealizada ?? 'Data não informada'}';
    } else {
      return 'Aguardando parto previsto para $dataPrevisaoParto';
    }
  }
}
