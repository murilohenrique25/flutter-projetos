import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/services/auth_service.dart';

class AuthController extends GetxController {
  final _authService = Get.find<AuthService>();

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController(text: 'joao@email.com');
  final passwordController = TextEditingController(text: '123456');

  final obscurePassword = true.obs;
  final isLoading = false.obs;

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() {
    obscurePassword.toggle();
  }

  Future<void> login() async {
    if (formKey.currentState!.validate()) {
      isLoading.value = true;

      await _authService.login(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      isLoading.value = false;
    }
  }

  void goToRegister() {
    Get.snackbar('Info', 'Funcionalidade de cadastro seria implementada aqui');
  }
}