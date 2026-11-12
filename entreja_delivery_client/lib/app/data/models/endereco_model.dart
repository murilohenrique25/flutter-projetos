class Endereco {
  final String logradouro;
  final String numero;
  final String? complemento;
  final String bairro;
  final String cidade;
  final String cep;
  final String? pontoReferencia;

  Endereco({
    required this.logradouro,
    required this.numero,
    this.complemento,
    required this.bairro,
    required this.cidade,
    required this.cep,
    this.pontoReferencia,
  });

  factory Endereco.fromJson(Map<String, dynamic> json) {
    return Endereco(
      logradouro: json['logradouro'],
      numero: json['numero'],
      complemento: json['complemento'],
      bairro: json['bairro'],
      cidade: json['cidade'],
      cep: json['cep'],
      pontoReferencia: json['pontoReferencia'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'logradouro': logradouro,
      'numero': numero,
      'complemento': complemento,
      'bairro': bairro,
      'cidade': cidade,
      'cep': cep,
      'pontoReferencia': pontoReferencia,
    };
  }

  String get enderecoCompleto {
    String endereco = '$logradouro, $numero';
    if (complemento?.isNotEmpty == true) endereco += ', $complemento';
    endereco += ', $bairro, $cidade - $cep';
    return endereco;
  }
}