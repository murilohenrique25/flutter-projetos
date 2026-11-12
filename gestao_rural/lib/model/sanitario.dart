import 'package:gestao_rural/model/animal.dart';

class Sanitario {
  int id;
  Animal animal;
  String enfermidade;
  String vacina;
  String dataOcorrencia;
  String observacao;

  Sanitario({
    this.id = 0,
    required this.animal,
    required this.enfermidade,
    required this.vacina,
    required this.dataOcorrencia,
    this.observacao = '',
  });

  // Converter para Map (útil para salvar em banco de dados)
  Map<String, dynamic> toMap() {
    return {
      'animal': animal.toMap(),
      'enfermidade': enfermidade,
      'vacina': vacina,
      'dataOcorrencia': dataOcorrencia,
      'observacao': observacao,
    };
  }

  // Criar Sanitário a partir de Map
  factory Sanitario.fromMap(Map<String, dynamic> map) {
    return Sanitario(
      id: map['id'] ?? '',
      animal: Animal.fromMap(map['animal'] ?? {}),
      enfermidade: map['enfermidade'] ?? '',
      vacina: map['vacina'] ?? '',
      dataOcorrencia: map['dataOcorrencia'] ?? '',
      observacao: map['observacao'] ?? '',
    );
  }

  // Método para copiar com modificações
  Sanitario copyWith({
    int? id,
    Animal? animal,
    String? enfermidade,
    String? vacina,
    String? dataOcorrencia,
    String? observacao,
  }) {
    return Sanitario(
      id: id ?? this.id,
      animal: animal ?? this.animal,
      enfermidade: enfermidade ?? this.enfermidade,
      vacina: vacina ?? this.vacina,
      dataOcorrencia: dataOcorrencia ?? this.dataOcorrencia,
      observacao: observacao ?? this.observacao,
    );
  }
}

// Classe para armazenar as opções disponíveis
class SanitarioOptions {
  static const List<String> enfermidades = [
    'Acidente Ofídico',
    'Afecções de Casco',
    'Aftosa',
    'Agenesia ovariana',
    'Anaplasmose',
    'Apatia',
    'ARTRITE',
    'Babesiose',
    'Botulismo',
    'Brucelose',
    'Campilobacteriose',
    'Carbúnculo Sintomático',
    'Ceratoconjuntivite',
    'Cisto folicular',
    'Cisto luteínico',
    'Claudicação',
    'Clostridiose',
    'Cura de Umbigo',
    'Descorna',
    'Diarreia',
    'Diarreia Viral Bovina (BVD)',
    'Doença Ovariana',
    'Eclampsia',
    'Endometrite',
    'Endoparasita',
    'Feridas',
    'Hipocalcemia',
    'Hipoplasia ovariana',
    'Hipotrofia ovariana',
    'Histofilose',
    'Intoxicação',
    'Leptospirose',
    'Leucose Enzoótica Bovina',
    'Mastite',
    'Metrite',
    'Mochação',
    'Morte Súbita',
    'Neoplasia ovariana',
    'Onfalite',
    'Otite',
    'Outras',
    'Ovário acessório e supranumerário',
    'Papilomatose',
    'Paratifo',
    'Pasteurela sp.',
    'Pasteurelose',
    'Patologia não identificada',
    'Piometra',
    'Pneumonia',
    'Prolapso Cervical',
    'Prolapso Uterino',
    'Prolapso Vaginal',
    'Raiva',
    'Remoção de tetos extranumerários',
    'Retenção de Placenta',
    'Rinotraqueíte Infecciosa Bovina (IBR)',
    'Septicemia',
    'Staphylococcus sp.',
    'Terapia de Vaca Seca',
    'Timpanismo',
    'Triconomose',
    'Tripanossomíase',
    'Tuberculose',
  ];

  static const List<String> vacinas = ['Aborvac', 'Aftogen Óleo'];
}
