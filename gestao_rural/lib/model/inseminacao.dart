import 'package:gestao_rural/model/animal.dart';

class Inseminacao {
  int id;
  Animal animal;
  String tipoInseminacao;
  String dataInseminacao;

  Inseminacao({
    required this.animal,
    required this.tipoInseminacao,
    required this.dataInseminacao,
    this.id = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'animal': animal.toMap(),
      'tipoInseminacao': tipoInseminacao,
      'dataInseminacao': dataInseminacao,
    };
  }

  factory Inseminacao.fromMap(Map<String, dynamic> map) {
    return Inseminacao(
      id: map['id'] ?? '',
      animal: Animal.fromMap(map['animal'] ?? {}),
      tipoInseminacao: map['tipoInseminacao'] ?? '',
      dataInseminacao: map['dataInseminacao'] ?? '',
    );
  }
}
