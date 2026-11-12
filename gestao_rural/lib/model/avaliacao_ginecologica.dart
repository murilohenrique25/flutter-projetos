import 'package:gestao_rural/model/animal.dart';

class AvaliacaoGinecologica {
  int id;
  Animal animal;
  String dataOcorrencia;
  String descricao;

  AvaliacaoGinecologica({
    required this.animal,
    required this.descricao,
    required this.dataOcorrencia,
    this.id = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'animal': animal.toMap(),
      'descicao': descricao,
      'dataOcorrencia': dataOcorrencia,
    };
  }

  factory AvaliacaoGinecologica.fromMap(Map<String, dynamic> map) {
    return AvaliacaoGinecologica(
      id: map['id'] ?? '',
      animal: Animal.fromMap(map['animal'] ?? {}),
      descricao: map['descricao'] ?? '',
      dataOcorrencia: map['descricao'] ?? '',
    );
  }
}
