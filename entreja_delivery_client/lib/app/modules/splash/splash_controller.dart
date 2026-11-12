import 'package:get/get.dart';

import '../../core/services/auth_service.dart';
import '../../routes/app_routes.dart';

class SplashController extends GetxController {
 final _authService = Get.find<AuthService>();

@override
void onInit() {
  super.onInit();
  _initializeApp();
}

void _initializeApp() async {
//  await Future.delayed(Duration(seconds: 2));

  if (_authService.isLoggedIn) {
    Get.offAllNamed(AppRoutes.HOME);
  } else {
    Get.offAllNamed(AppRoutes.LOGIN);
  }
}
}
