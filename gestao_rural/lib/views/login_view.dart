import 'package:flutter/material.dart';
import 'package:gestao_rural/controllers/auth_controller.dart';
import 'package:gestao_rural/widgets/animated_button.dart';
import 'package:gestao_rural/widgets/glass_container.dart';
import 'package:get/get.dart';

class LoginView extends StatelessWidget {
  final loginController = TextEditingController();
  final passwordController = TextEditingController();
  final obscureText = true.obs;
  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 4, 17, 6),
              Color.fromARGB(255, 0, 75, 25),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TweenAnimationBuilder(
                      tween: Tween<double>(begin: 0, end: 1),
                      duration: Duration(seconds: 1),
                      builder: (context, value, child) {
                        return Transform.scale(scale: value, child: child);
                      },
                      child: Container(
                        height: 120,
                        width: 120,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(25),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.lock_outline_rounded,
                          size: 50,
                          color: Color.fromRGBO(23, 6, 175, 1),
                        ),
                      ),
                    ),
                    SizedBox(height: 40),

                    GlassContainer(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          children: [
                            Text(
                              'Bem-vindo',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 24),

                            // Campo de email com animação
                            TextFormField(
                              controller: loginController,
                              decoration: InputDecoration(
                                labelText: 'Usuário',
                                prefixIcon: Icon(
                                  Icons.supervised_user_circle,
                                  color: Colors.white70,
                                ),
                                labelStyle: TextStyle(color: Colors.white70),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.white30),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.1),
                              ),
                              style: TextStyle(color: Colors.white),
                              keyboardType: TextInputType.emailAddress,
                            ),
                            SizedBox(height: 16),

                            // Campo de senha com animação
                            Obx(() {
                              return TextFormField(
                                controller: passwordController,
                                obscureText: obscureText.value,
                                decoration: InputDecoration(
                                  labelText: 'Senha',
                                  prefixIcon: Icon(
                                    Icons.lock,
                                    color: Colors.white70,
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      obscureText.value
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Colors.white70,
                                    ),
                                    onPressed:
                                        () =>
                                            obscureText.value =
                                                !obscureText.value,
                                  ),
                                  labelStyle: TextStyle(color: Colors.white70),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: Colors.white30,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: Colors.white),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white.withOpacity(0.1),
                                ),
                                style: TextStyle(color: Colors.white),
                              );
                            }),
                            SizedBox(height: 24),

                            // Botão de login animado
                            Obx(
                              () => AnimatedButton(
                                text:
                                    authController.isLoading.value
                                        ? 'Entrando...'
                                        : 'Entrar',
                                onPressed:
                                    authController.isLoading.value
                                        ? null
                                        : () => authController.login(
                                          loginController.text,
                                          passwordController.text,
                                        ),
                              ),
                            ),

                            // Mensagem de erro
                            Obx(
                              () =>
                                  authController.errorMessage.value.isNotEmpty
                                      ? Padding(
                                        padding: const EdgeInsets.only(
                                          top: 16.0,
                                        ),
                                        child: Text(
                                          authController.errorMessage.value,
                                          style: TextStyle(
                                            color: Colors.red[300],
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      )
                                      : SizedBox.shrink(),
                            ),
                            SizedBox(height: 24),
                            Text(
                              '1.0.1',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
