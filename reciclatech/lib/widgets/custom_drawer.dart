import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';

class CustomDrawer extends StatelessWidget {
  final AuthController authController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.green.shade700, Colors.green.shade500],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Icon(Icons.local_shipping, size: 50, color: Colors.white),
                const SizedBox(height: 8),
                const Text(
                  'Sistema de Reciclagem',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          _buildDrawerItem(
            icon: Icons.dashboard,
            title: 'Dashboard',
            onTap: () {
              Get.back();
              Get.offNamed('/dashboard');
            },
          ),
          _buildDrawerItem(
            icon: Icons.add_shopping_cart,
            title: 'Nova Compra',
            onTap: () {
              Get.back();
              Get.toNamed('/shopping');
            },
          ),
          _buildDrawerItem(
            icon: Icons.straighten,
            title: 'Cadastrar Unidade',
            onTap: () {
              Get.back();
              Get.toNamed('/units');
            },
          ),
          _buildDrawerItem(
            icon: Icons.receipt_long,
            title: 'Nova Despesa',
            onTap: () {
              Get.back();
              Get.toNamed('/expenses');
            },
          ),
          const Divider(),
          _buildDrawerItem(
            icon: Icons.logout,
            title: 'Sair',
            color: Colors.red,
            onTap: () => authController.logout(),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? color,
  }) {
    return ListTile(
      leading: Icon(icon, color: color ?? Colors.grey.shade700),
      title: Text(
        title,
        style: TextStyle(color: color ?? Colors.grey.shade800),
      ),
      onTap: onTap,
    );
  }
}
