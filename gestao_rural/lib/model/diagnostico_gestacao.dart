import 'package:gestao_rural/model/animal.dart';
import 'package:gestao_rural/model/inseminacao.dart';

class DiagnosticoGestacao {
  int id;
  Animal animal;
  Inseminacao inseminacao;
  bool prenha;
  String dataDiagnostico;

  DiagnosticoGestacao({
    this.id = 0,
    required this.animal,
    required this.inseminacao,
    required this.prenha,
    required this.dataDiagnostico,
  });

  Map<String, dynamic> toJson() {
    return {
      'animal': animal.toMap(),
      'inseminacao': inseminacao.toMap(),
      'prenha': prenha,
      'dataDiagnostico': dataDiagnostico,
    };
  }

  factory DiagnosticoGestacao.fromJson(Map<String, dynamic> json) {
    return DiagnosticoGestacao(
      id: json['id'],
      animal: Animal.fromMap(json['animal']),
      inseminacao: Inseminacao.fromMap(json['inseminacao']),
      prenha: json['prenha'],
      dataDiagnostico: json['dataDiagnostico'],
    );
  }

  String get statusPrenhaTexto => prenha ? 'Prenha' : 'Não Prenha';

  String get statusPrenhaDetalhado => prenha ? 'Prenha Confirmada' : 'Não Prenha';
}