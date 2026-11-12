import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/unit_controller.dart';

class UnitPage extends StatelessWidget {
  final UnitController controller = Get.find();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController valueController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cadastro de Unidade',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Ícone de Unidade
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.straighten,
                size: 50,
                color: Colors.blue.shade700,
              ),
            ),
            const SizedBox(height: 24),

            // Campo de Tipo de Unidade
            TextField(
              controller: typeController,
              decoration: InputDecoration(
                labelText: 'Tipo de Unidade',
                hintText: 'Ex: KG, Litro, Unidade...',
                prefixIcon: const Icon(Icons.class_, color: Colors.blue),
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
                labelText: 'Valor',
                prefixIcon: const Icon(
                  Icons.monetization_on,
                  color: Colors.blue,
                ),
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
                            controller.saveUnit(typeController.text, value);
                          },
                  icon:
                      controller.isLoading.value
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Icon(Icons.save, color: Colors.white),
                  label: Text(
                    controller.isLoading.value
                        ? 'Salvando...'
                        : 'Salvar Unidade',
                    style: const TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade700,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                  ),
                ),
              ),
            ),
            const Spacer(),

            // Texto de exemplo
            Text(
              'Exemplos: Kg, Tonelada, Fardo, Saco',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
