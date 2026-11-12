import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/expense_controller.dart';

class ExpensePage extends StatelessWidget {
  final ExpenseController controller = Get.find();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController valueController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Nova Despesa',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.red.shade700,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Ícone de Despesa
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.receipt_long,
                size: 50,
                color: Colors.red.shade700,
              ),
            ),
            const SizedBox(height: 24),

            // Campo de Nome
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Nome da Despesa',
                hintText: 'Ex: Gasolina, Aluguel...',
                prefixIcon: const Icon(Icons.note_alt, color: Colors.red),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Campo de Valor
            TextField(
              controller: valueController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Valor Pago',
                prefixIcon: const Icon(Icons.attach_money, color: Colors.red),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixText: 'R\$ ',
              ),
            ),
            const SizedBox(height: 24),

            // Botão Salvar
            Obx(
              () => SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed:
                      controller.isLoading.value
                          ? null
                          : () {
                            final value =
                                double.tryParse(valueController.text) ?? 0.0;
                            controller.saveExpense(nameController.text, value);
                          },
                  icon:
                      controller.isLoading.value
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Icon(Icons.save, color: Colors.white),
                  label: Text(
                    controller.isLoading.value
                        ? 'Salvando...'
                        : 'Salvar Despesa',
                    style: const TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade700,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
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
