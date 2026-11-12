import 'package:get/get.dart';
import '../services/api_service.dart';
import '../controllers/auth_controller.dart';
import '../controllers/dashboard_controller.dart';
import '../controllers/shopping_controller.dart';
import '../controllers/unit_controller.dart';
import '../controllers/expense_controller.dart';

// Importa suas páginas
import '../pages/login_page.dart';
import '../pages/dashboard_page.dart';
import '../pages/shopping_page.dart';
import '../pages/unit_page.dart';
import '../pages/expense_page.dart';
import '../pages/receipt_page.dart';

class AppRoutes {
  static const login = '/login';
  static const dashboard = '/dashboard';
  static const shopping = '/shopping';
  static const units = '/units';
  static const expenses = '/expenses';
  static const receipt = '/receipt';

  static final pages = [
    GetPage(name: login, page: () => LoginPage()),
    GetPage(name: dashboard, page: () => DashboardPage()),
    GetPage(name: shopping, page: () => ShoppingPage()),
    GetPage(name: units, page: () => UnitPage()),
    GetPage(name: expenses, page: () => ExpensePage()),
    GetPage(name: receipt, page: () => ReceiptPage()),
  ];

  static final initialBinding = BindingsBuilder(() {
    Get.put(ApiService());
    Get.put(AuthController());
    Get.put(DashboardController());
    Get.put(ShoppingController());
    Get.put(UnitController());
    Get.put(ExpenseController());
  });
}
