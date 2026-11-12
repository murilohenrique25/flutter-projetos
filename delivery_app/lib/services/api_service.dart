import 'dart:async';
import 'dart:math';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/delivery_model.dart';
import 'geocoding_service.dart';

/// Serviço Mock para simular API de entregas
/// Em produção, substituir por chamadas HTTP reais ou WebSocket
class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  final StreamController<Delivery> _deliveryStreamController =
      StreamController<Delivery>.broadcast();

  Stream<Delivery> get deliveryStream => _deliveryStreamController.stream;

  final List<Delivery> _activeDeliveries = [];
  Timer? _mockTimer;

  /// Inicia o listener de novas entregas (mock)
  void startListening() {
    _mockTimer?.cancel();

    // Simula chegada de nova entrega a cada 20 segundos
    _mockTimer = Timer.periodic(const Duration(seconds: 20), (timer) {
      _simulateNewDelivery();
    });
  }

  /// Para o listener de entregas
  void stopListening() {
    _mockTimer?.cancel();
  }

  /// Simula uma nova entrega disponível
 void _simulateNewDelivery() async {
  final random = Random();


  final establishments = [
    {
      'name': 'Feira do Luar',
      'lat': -17.74000286122123,
      'lng': -48.62584862001351,
    },
    {
      'name': 'Reis Santa Efigenia',
      'lat': -17.74147308037188,
      'lng': -48.5985650943572,
    },
    {
      'name': 'Supermercado Sol - Lago Sul',
      'lat': -17.75027656746093,
      'lng': -48.585214695036846,
    },
  ];

  final est = establishments[random.nextInt(establishments.length)];

  // Gera localização do cliente
  final customerLat = -17.745195778548258 + (random.nextDouble() - 0.5) * 0.03;
  final customerLng = -48.628064596826135 + (random.nextDouble() - 0.5) * 0.03;

  final establishmentLocation = LatLng(est['lat'] as double, est['lng'] as double);
  final customerLocation = LatLng(customerLat, customerLng);

  // 🆕 BUSCA ENDEREÇO REAL via Reverse Geocoding
  String customerAddress;
  try {
    print('🔍 Buscando endereço real para: $customerLat, $customerLng');
    final realAddress = await GeocodingService.getAddressFromLatLng(customerLocation);

    if (realAddress != null) {
      customerAddress = realAddress;
      print('✅ Endereço real encontrado: $customerAddress');
    } else {
      // Fallback se API falhar
      customerAddress = 'Rua Aleatória, ${random.nextInt(500) + 1} - Bairro Teste';
      print('⚠️ Geocoding falhou, usando fake');
    }
  } catch (e) {
    customerAddress = 'Rua Aleatória, ${random.nextInt(500) + 1} - Bairro Teste';
    print('❌ Erro geocoding: $e - usando fake');
  }

  // Calcula distância e valor
  final distanceInMeters = _calculateDistance(establishmentLocation, customerLocation);
  final distanceInKm = distanceInMeters / 1000;
  final baseValue = 5.0;
  final pricePerKm = 4.50;
  final deliveryValue = baseValue + (distanceInKm * pricePerKm);

  // ✅ Delivery com ENDEREÇO REAL!
  final delivery = Delivery(
    id: DateTime.now().millisecondsSinceEpoch.toString(),
    establishmentName: est['name'] as String,
    establishmentLocation: establishmentLocation,
    customerLocation: customerLocation,
    customerAddress: customerAddress,  // ← REAL!
    value: deliveryValue,
    status: DeliveryStatus.available,
  );

  _activeDeliveries.add(delivery);
  _deliveryStreamController.add(delivery);
}

  /// Calcula distância entre dois pontos em metros
  double _calculateDistance(LatLng start, LatLng end) {
    const double earthRadius = 6371000; // metros

    final lat1 = start.latitude * (3.141592653589793 / 180.0);
    final lat2 = end.latitude * (3.141592653589793 / 180.0);
    final dLat = (end.latitude - start.latitude) * (3.141592653589793 / 180.0);
    final dLng =
        (end.longitude - start.longitude) * (3.141592653589793 / 180.0);

    final a =
        sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1) * cos(lat2) * sin(dLng / 2) * sin(dLng / 2);
    final c = 2 * asin(sqrt(a));

    return earthRadius * c;
  }

  /// Aceita uma entrega (simula concorrência)
  Future<bool> acceptDelivery(
    String deliveryId,
    String deliveryPersonId,
  ) async {
    // Simula latência de rede
    await Future.delayed(const Duration(milliseconds: 500));

    final index = _activeDeliveries.indexWhere((d) => d.id == deliveryId);

    if (index != -1) {
      final delivery = _activeDeliveries[index];

      // Verifica se ainda está disponível
      if (delivery.status == DeliveryStatus.available) {
        _activeDeliveries[index] = delivery.copyWith(
          status: DeliveryStatus.accepted,
          deliveryPersonId: deliveryPersonId,
        );
        return true;
      }
    }

    // Já foi aceita por outro entregador
    return false;
  }

  /// Atualiza o status de uma entrega
  Future<void> updateDeliveryStatus(
    String deliveryId,
    DeliveryStatus status,
  ) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final index = _activeDeliveries.indexWhere((d) => d.id == deliveryId);
    if (index != -1) {
      _activeDeliveries[index] = _activeDeliveries[index].copyWith(
        status: status,
      );
    }
  }

  /// Envia atualização de localização para o servidor
  Future<void> sendLocationUpdate(
    String deliveryId,
    LatLng location,
    double distanceRemaining,
  ) async {
    // Em produção, enviar para API
    await Future.delayed(const Duration(milliseconds: 100));

    // Mock: apenas simula o envio
    print(
      'Location update sent: $deliveryId at ${location.latitude},${location.longitude}',
    );
  }

  void dispose() {
    _mockTimer?.cancel();
    _deliveryStreamController.close();
  }
}
