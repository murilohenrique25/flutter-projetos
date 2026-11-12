import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/shopping_controller.dart';

class ShoppingPage extends StatelessWidget {
  final ShoppingController controller = Get.find();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController unitValueController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Nova Compra',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cabeçalho de Data/Hora
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Obx(
                () => Row(
                  children: [
                    const Icon(Icons.access_time, color: Colors.grey),
                    const SizedBox(width: 8),
                    Text(
                      'Data/Hora: ${controller.currentDateTime.value}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Dropdowns e Campos de Texto
            Obx(
              () => DropdownButtonFormField<String>(
                value:
                    controller.selectedMaterial.value.isEmpty
                        ? null
                        : controller.selectedMaterial.value,
                decoration: InputDecoration(
                  labelText: 'Material Reciclável',
                  labelStyle: TextStyle(color: Colors.green.shade700),
                  prefixIcon: Icon(
                    Icons.recycling,
                    color: Colors.green.shade700,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.green.shade700),
                  ),
                ),
                items:
                    controller.materials
                        .map(
                          (material) => DropdownMenuItem(
                            value: material,
                            child: Text(material),
                          ),
                        )
                        .toList(),
                onChanged:
                    (value) => controller.selectedMaterial.value = value ?? '',
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: quantityController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Peso',
                      labelStyle: TextStyle(color: Colors.grey.shade700),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.green.shade700),
                      ),
                      suffixText: 'Kg',
                    ),
                    onChanged:
                        (value) =>
                            controller.quantity.value =
                                double.tryParse(value) ?? 0.0,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: unitValueController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Preço/Kg',
                      labelStyle: TextStyle(color: Colors.grey.shade700),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.green.shade700),
                      ),
                      prefixText: 'R\$ ',
                    ),
                    onChanged:
                        (value) =>
                            controller.unitValue.value =
                                double.tryParse(value) ?? 0.0,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Obx(
              () => DropdownButtonFormField<String>(
                value:
                    controller.selectedUnit.value.isEmpty
                        ? null
                        : controller.selectedUnit.value,
                decoration: InputDecoration(
                  labelText: 'Unidade de Medida',
                  labelStyle: TextStyle(color: Colors.green.shade700),
                  prefixIcon: Icon(
                    Icons.straighten,
                    color: Colors.green.shade700,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.green.shade700),
                  ),
                ),
                items:
                    controller.units
                        .map(
                          (unit) => DropdownMenuItem(
                            value: unit['type'] as String,
                            child: Text(
                              '${unit['type']} - R\$ ${unit['value']}',
                            ),
                          ),
                        )
                        .toList(),
                onChanged:
                    (value) => controller.selectedUnit.value = value ?? '',
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {
                  controller.addItem();
                  quantityController.clear();
                  unitValueController.clear();
                },
                icon: const Icon(Icons.add_circle_outline),
                label: const Text('Adicionar Item'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Itens da Compra:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // Lista de Itens
            Expanded(
              child: Obx(
                () => ListView.builder(
                  itemCount: controller.purchaseItems.length,
                  itemBuilder: (context, index) {
                    final item = controller.purchaseItems[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 4,
                      ),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        leading: CircleAvatar(
                          backgroundColor: Colors.green.withOpacity(0.1),
                          child: Icon(
                            Icons.local_shipping,
                            color: Colors.green.shade700,
                          ),
                        ),
                        title: Text(
                          item.recyclableMaterial,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          '${item.quantity.toStringAsFixed(2)} ${item.unit} x R\$ ${item.unitValue.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'R\$ ${item.totalValue.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => controller.removeItem(index),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // Total e Botão Finalizar
            Obx(
              () => Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 4,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total:',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'R\$ ${controller.getTotalPurchaseValue().toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Obx(
              () => Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: const LinearGradient(
                    colors: [Colors.green, Colors.lightGreen],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
                child: ElevatedButton(
                  onPressed:
                      controller.isLoading.value
                          ? null
                          : () => controller.finalizePurchase(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child:
                      controller.isLoading.value
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                            'Finalizar Compra',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
