class PurchaseItem {
  final String recyclableMaterial;
  final double quantity;
  final double unitValue;
  final double totalValue;
  final String unit;

  PurchaseItem({
    required this.recyclableMaterial,
    required this.quantity,
    required this.unitValue,
    required this.totalValue,
    required this.unit,
  });

  Map<String, dynamic> toJson() {
    return {
      'recyclableMaterial': recyclableMaterial,
      'quantity': quantity,
      'unitValue': unitValue,
      'totalValue': totalValue,
      'unit': unit,
    };
  }
}
