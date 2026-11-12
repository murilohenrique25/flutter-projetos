import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/dashboard_controller.dart';
import '../controllers/auth_controller.dart';
import '../widgets/custom_drawer.dart'; // Importa o novo drawer

class DashboardPage extends StatelessWidget {
  final DashboardController dashboardController = Get.find();
  final AuthController authController = Get.find();

  @override
  Widget build(BuildContext
  context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => authController.logout(),
          ),
        ],
      ),
      drawer: CustomDrawer(),
      body: Obx(() => dashboardController.isLoading.value
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () => dashboardController.loadDashboardData(),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Cabeçalho com a data
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today, color: Colors.green.shade700),
                          const SizedBox(width: 12),
                          Text(
                            'Data: ${dashboardController.currentDate.value}',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.green.shade900),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Grid de Cartões de Métricas
                    Expanded(
                      child: GridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        children: [
                          _buildDashboardCard(
                            'Recicláveis Comprados',
                            dashboardController.recycledMaterialsQuantity.value.toString() + ' Kg',
                            Icons.recycling,
                            Colors.green,
                          ),
                          _buildDashboardCard(
                            'Compras Realizadas',
                            dashboardController.purchasesQuantity.value.toString(),
                            Icons.shopping_bag_outlined,
                            Colors.blue,
                          ),
                          _buildDashboardCard(
                            'Total Pago em Recicláveis',
                            'R\$ ${dashboardController.totalPurchasesValue.value.toStringAsFixed(2)}',
                            Icons.monetization_on_outlined,
                            Colors.orange,
                          ),
                          _buildDashboardCard(
                            'Total Despesas',
                            'R\$ ${dashboardController.totalExpensesValue.value.toStringAsFixed(2)}',
                            Icons.receipt_long_outlined,
                            Colors.red,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Botões de Ação
                    Row(
                      children: [
                        Expanded(
                          child: _buildActionButton(
                            'Comprar Recicláveis',
                            Icons.add_shopping_cart,
                            () => Get.toNamed('/shopping'),
                            Colors.green.shade700,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildActionButton(
                            'Nova Despesa',
                            Icons.receipt,
                            () => Get.toNamed('/expenses'),
                            Colors.red.shade700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: _buildActionButton(
                        'Cadastrar Unidade',
                        Icons.straighten,
                        () => Get.toNamed('/units'),
                        Colors.blue.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            )),
    );
  }

  Widget _buildDashboardCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: color.withOpacity(0.1),
              child: Icon(icon, size: 30, color: color),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.grey.shade800),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(String label, IconData icon, VoidCallback onPressed, Color color) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: Colors.white),
      label: Text(label, style: const TextStyle(color: Colors.white, fontSize: 14)),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
      ),
    );
  }
}