class Produto {
  final int id;
  final String nome;
  final String descricao;
  final double preco;
  final bool promocao;
  final double? precoPromocao;
  final int categoriaId;
  final String categoria;
  final String? imagem;
  final bool ativo;

  Produto({
    required this.id,
    required this.nome,
    required this.descricao,
    required this.preco,
    required this.promocao,
    this.precoPromocao,
    required this.categoriaId,
    required this.categoria,
    this.imagem,
    required this.ativo,
  });

  factory Produto.fromJson(Map<String, dynamic> json) {
    return Produto(
      id: json['id'],
      nome: json['nome'],
      descricao: json['descricao'],
      preco: json['preco'].toDouble(),
      promocao: json['promocao'] ?? false,
      precoPromocao: json['precoPromocao']?.toDouble(),
      categoriaId: json['categoriaId'],
      categoria: json['categoria'] ?? '',
      imagem: json['imagem'],
      ativo: json['ativo'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'descricao': descricao,
      'preco': preco,
      'promocao': promocao,
      'precoPromocao': precoPromocao,
      'categoriaId': categoriaId,
      'categoria': categoria,
      'imagem': imagem,
      'ativo': ativo,
    };
  }

  double get precoFinal => promocao && precoPromocao != null ? precoPromocao! : preco;

  double get economia => promocao && precoPromocao != null ? preco - precoPromocao! : 0.0;

  double get percentualDesconto => promocao && precoPromocao != null 
      ? ((preco - precoPromocao!) / preco) * 100 
      : 0.0;
}