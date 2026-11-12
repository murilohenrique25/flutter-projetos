class CartItem {
  final int produtoId;
  final String nome;
  final double preco;
  final double precoOriginal;
  int quantidade;
  String observacoes;

  CartItem({
    required this.produtoId,
    required this.nome,
    required this.preco,
    required this.precoOriginal,
    required this.quantidade,
    this.observacoes = '',
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      produtoId: json['produtoId'],
      nome: json['nome'],
      preco: json['preco'].toDouble(),
      precoOriginal: json['precoOriginal'].toDouble(),
      quantidade: json['quantidade'],
      observacoes: json['observacoes'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'produtoId': produtoId,
      'nome': nome,
      'preco': preco,
      'precoOriginal': precoOriginal,
      'quantidade': quantidade,
      'observacoes': observacoes,
    };
  }

  double get total => preco * quantidade;

  bool get temPromocao => preco < precoOriginal;

  double get economiaTotal => (precoOriginal - preco) * quantidade;
}