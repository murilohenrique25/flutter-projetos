import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:get/get.dart';

class LocationService extends GetxService {
  StreamSubscription<Position>? _positionStreamSubscription;
  final Rx<Position?> currentPosition = Rx<Position?>(null);
  final RxBool isTracking = false.obs;

  Function(double lat, double lng)? onLocationUpdate;

  Future<bool> requestPermissions() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever) {
        Get.snackbar(
          'Permissão Negada',
          'Ative a permissão de localização nas configurações',
          snackPosition: SnackPosition.BOTTOM,
        );
        await openAppSettings();
        return false;
      }

      return permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always;
    } catch (e) {
      print('❌ Erro ao solicitar permissões: $e');
      return false;
    }
  }

  Future<void> startTracking() async {
    if (isTracking.value) {
      print('⚠️ Rastreamento já ativo. Reiniciando...');
      await stopTracking();
      await Future.delayed(Duration(milliseconds: 500));
    }

    bool hasPermission = await requestPermissions();
    if (!hasPermission) return;

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.snackbar('GPS Desativado', 'Ative o GPS do seu dispositivo');
      return;
    }

    try {
      isTracking.value = true;

      const LocationSettings locationSettings = LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
        timeLimit: Duration(seconds: 10),
      );

      print('🚀 Iniciando rastreamento...');

      _positionStreamSubscription = Geolocator.getPositionStream(
        locationSettings: locationSettings,
      ).listen(
        (Position position) {
          currentPosition.value = position;
          print('📍 ${position.latitude}, ${position.longitude}');

          if (onLocationUpdate != null) {
            try {
              onLocationUpdate!(position.latitude, position.longitude);
            } catch (e) {
              print('❌ Erro ao enviar localização: $e');
            }
          }
        },
        onError: (error) {
          print('❌ Erro no rastreamento: $error');
          stopTracking();
        },
        cancelOnError: true,
      );

      print('✅ Rastreamento iniciado');
    } catch (e) {
      print('❌ Erro ao iniciar rastreamento: $e');
      isTracking.value = false;
    }
  }

  Future<Position?> getCurrentPosition() async {
    bool hasPermission = await requestPermissions();
    if (!hasPermission) return null;

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.snackbar('GPS Desativado', 'Ative o GPS do seu dispositivo');
      return null;
    }

    try {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      return null;
    }
  }

  Future<void> stopTracking() async {
    try {
      if (_positionStreamSubscription != null) {
        await _positionStreamSubscription!.cancel();
        _positionStreamSubscription = null;
      }

      isTracking.value = false;
      currentPosition.value = null;
      onLocationUpdate = null;

      print('✅ Rastreamento parado');
    } catch (e) {
      print('❌ Erro ao parar rastreamento: $e');
      _positionStreamSubscription = null;
      isTracking.value = false;
      currentPosition.value = null;
      onLocationUpdate = null;
    }
  }

  @override
  Future<void> onClose() async {
    await stopTracking();
    super.onClose();
  }
}
