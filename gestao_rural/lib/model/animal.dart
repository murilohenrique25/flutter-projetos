class Animal {
  int id;
  String numeroBrinco;
  String nome;
  String lote;
  double pesoNascimento;
  String dataNascimento;
  String raca;
  int quantidadeCios;
  int quantidadePartos;
  String dataInseminacao;
  String dataParto;

  Animal({
    this.id = 0, // Mudança aqui: removido 'required' e tornado opcional
    required this.numeroBrinco,
    required this.nome,
    required this.lote,
    required this.pesoNascimento,
    required this.dataNascimento,
    required this.raca,
    this.quantidadeCios = 0,
    this.quantidadePartos = 0,
    this.dataInseminacao = '',
    this.dataParto = '',
  });

  // Converter para Map (útil para salvar em banco de dados)
  Map<String, dynamic> toMap() {
    return {
      'numeroBrinco': numeroBrinco,
      'nome': nome,
      'lote': lote,
      'pesoNascimento': pesoNascimento,
      'dataNascimento': dataNascimento,
      'raca': raca,
      'quantidadeCios': quantidadeCios,
      'quantidadePartos': quantidadePartos,
      'dataInseminacao': dataInseminacao,
      'dataParto': dataParto,
    };
  }

  // Criar Animal a partir de Map
  factory Animal.fromMap(Map<String, dynamic> map) {
    return Animal(
      id: map['id'] ?? 0, // Agora o id será passado corretamente
      numeroBrinco: map['numeroBrinco'] ?? '',
      nome: map['nome'] ?? '',
      lote: map['lote'] ?? '',
      pesoNascimento: map['pesoNascimento']?.toDouble() ?? 0.0,
      dataNascimento: map['dataNascimento'] ?? '',
      raca: map['raca'] ?? '',
      quantidadeCios: map['quantidadeCios'] ?? 0,
      quantidadePartos: map['quantidadePartos'] ?? 0,
      dataInseminacao: map['dataInseminacao'] ?? '',
      dataParto: map['dataParto'] ?? '',
    );
  }

  // Método para copiar com modificações
  Animal copyWith({
    int? id,
    String? numeroBrinco,
    String? nome,
    String? lote,
    double? pesoNascimento,
    String? dataNascimento,
    String? raca,
    int? quantidadeCios,
    int? quantidadePartos,
    String? dataInseminacao,
    String? dataParto,
  }) {
    return Animal(
      id: id ?? this.id,
      numeroBrinco: numeroBrinco ?? this.numeroBrinco,
      nome: nome ?? this.nome,
      lote: lote ?? this.lote,
      pesoNascimento: pesoNascimento ?? this.pesoNascimento,
      dataNascimento: dataNascimento ?? this.dataNascimento,
      raca: raca ?? this.raca,
      quantidadeCios: quantidadeCios ?? this.quantidadeCios,
      quantidadePartos: quantidadePartos ?? this.quantidadePartos,
      dataInseminacao: dataInseminacao ?? this.dataInseminacao,
      dataParto: dataParto ?? this.dataParto,
    );
  }
}
