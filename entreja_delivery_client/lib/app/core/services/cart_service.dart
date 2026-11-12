import 'package:get/get.dart';

import 'storage_service.dart';
import '../../data/models/cart_item_model.dart';
import '../../data/models/produto_model.dart';

class CartService extends GetxService {
  final _storageService = Get.find<StorageService>();

  final _items = <CartItem>[].obs;
  final _cupomAplicado = Rxn<String>();
  final _descontoCupom = 0.0.obs;

  List<CartItem> get items => _items;
  String? get cupomAplicado => _cupomAplicado.value;
  double get descontoCupom => _descontoCupom.value;

  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantidade);

  double get subtotal => _items.fold(0, (sum, item) => sum + item.total);

  double get taxaEntrega => 5.0; // Mock value

  double get total => subtotal + taxaEntrega - descontoCupom;

  @override
  void onInit() {
    super.onInit();
    _loadCartFromStorage();
  }

  void _loadCartFromStorage() {
    final cartData = _storageService.getCartData();
    if (cartData != null) {
      _items.value = (cartData as List)
          .map((item) => CartItem.fromJson(item))
          .toList();
    }
  }

  void _saveCartToStorage() {
    final cartData = _items.map((item) => item.toJson()).toList();
    _storageService.saveCartData(cartData);
  }

  void addItem(Produto produto, {int quantidade = 1, String observacoes = ''}) {
    final existingIndex = _items.indexWhere((item) => item.produtoId == produto.id);

    if (existingIndex >= 0) {
      _items[existingIndex].quantidade += quantidade;
      if (observacoes.isNotEmpty) {
        _items[existingIndex].observacoes = observacoes;
      }
    } else {
      final cartItem = CartItem(
        produtoId: produto.id,
        nome: produto.nome,
        preco: produto.precoFinal,
        precoOriginal: produto.preco,
        quantidade: quantidade,
        observacoes: observacoes,
      );
      _items.add(cartItem);
    }

    _saveCartToStorage();
    Get.snackbar('Sucesso', '${produto.nome} adicionado ao carrinho');
  }

  void removeItem(int produtoId) {
    _items.removeWhere((item) => item.produtoId == produtoId);
    _saveCartToStorage();
  }

  void updateQuantity(int produtoId, int novaQuantidade) {
    final index = _items.indexWhere((item) => item.produtoId == produtoId);
    if (index >= 0) {
      if (novaQuantidade <= 0) {
        removeItem(produtoId);
      } else {
        _items[index].quantidade = novaQuantidade;
        _saveCartToStorage();
      }
    }
  }

  void updateObservacoes(int produtoId, String observacoes) {
    final index = _items.indexWhere((item) => item.produtoId == produtoId);
    if (index >= 0) {
      _items[index].observacoes = observacoes;
      _saveCartToStorage();
    }
  }

  void clearCart() {
    _items.clear();
    _cupomAplicado.value = null;
    _descontoCupom.value = 0.0;
    _storageService.clearCartData();
  }

  bool aplicarCupom(String codigo, double desconto) {
    // Mock cupom validation
    final cuponsValidos = ['PROMO10', 'DESCONTO5', 'PRIMEIRA'];

    if (cuponsValidos.contains(codigo.toUpperCase())) {
      _cupomAplicado.value = codigo.toUpperCase();

      if (codigo.toUpperCase() == 'PROMO10') {
        _descontoCupom.value = subtotal * 0.1; // 10%
      } else if (codigo.toUpperCase() == 'DESCONTO5') {
        _descontoCupom.value = 5.0; // R$ 5,00
      } else if (codigo.toUpperCase() == 'PRIMEIRA') {
        _descontoCupom.value = subtotal * 0.2; // 20%
      }

      Get.snackbar('Sucesso', 'Cupom aplicado com sucesso!');
      return true;
    } else {
      Get.snackbar('Erro', 'Cupom inválido ou expirado');
      return false;
    }
  }

  void removerCupom() {
    _cupomAplicado.value = null;
    _descontoCupom.value = 0.0;
  }
}