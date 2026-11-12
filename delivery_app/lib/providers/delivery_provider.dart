import 'dart:async';

import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/delivery_model.dart';

import '../services/location_service.dart';

import '../services/directions_service.dart';

import '../services/api_service.dart';

/// Provider para gerenciar o estado das entregas
class DeliveryProvider extends ChangeNotifier {
  final LocationService _locationService = LocationService();

  final DirectionsService _directionsService = DirectionsService();

  final ApiService _apiService = ApiService();

  Delivery? _currentDelivery;

  LatLng? _currentLocation;

  double _distanceRemaining = 0.0;

  bool _isTracking = false;

  List<LatLng> _routePoints = [];

  bool _isLoadingRoute = false;

  StreamSubscription? _deliverySubscription;

  StreamSubscription? _locationSubscription;

  // ID único do entregador (em produção, vir do login)
  final String _deliveryPersonId = 'ENTREGADOR_001';

  // Getters
  Delivery? get currentDelivery => _currentDelivery;

  LatLng? get currentLocation => _currentLocation;

  double get distanceRemaining => _distanceRemaining;

  bool get isTracking => _isTracking;

  List<LatLng> get routePoints => _routePoints;

  String get deliveryPersonId => _deliveryPersonId;

  bool get isLoadingRoute => _isLoadingRoute;

  DeliveryProvider() {
    _initialize();
  }

  /// Inicializa o provider
  void _initialize() {
    print('DeliveryProvider initialized');
  }

  /// Inicia o listener de novas entregas do ApiService
  void startListeningForDeliveries(Function(Delivery) onNewDelivery) {
    _deliverySubscription = _apiService.deliveryStream.listen((delivery) {
      // Só mostra se não tiver entrega ativa
      if (_currentDelivery == null) {
        onNewDelivery(delivery);
      }
    });

    // Inicia o timer de entregas mock
    _apiService.startListening();
  }

  /// Aceita uma entrega
  Future<bool> acceptDelivery(Delivery delivery) async {
    final accepted = await _apiService.acceptDelivery(
      delivery.id,
      _deliveryPersonId,
    );

    if (accepted) {
      _currentDelivery = delivery.copyWith(
        status: DeliveryStatus.accepted,
        deliveryPersonId: _deliveryPersonId,
      );

      notifyListeners();
      return true;
    }

    return false;
  }

  /// Confirma que retirou o pedido do estabelecimento
  Future<void> confirmPickup() async {
    if (_currentDelivery == null) return;

    await _apiService.updateDeliveryStatus(
      _currentDelivery!.id,
      DeliveryStatus.pickedUp,
    );

    _currentDelivery = _currentDelivery!.copyWith(
      status: DeliveryStatus.pickedUp,
    );

    // Inicia o rastreamento
    await startDeliveryTracking();

    notifyListeners();
  }

  /// Inicia o rastreamento da entrega
  Future<void> startDeliveryTracking() async {
    if (_currentDelivery == null) return;

    _isTracking = true;

    _locationService.startTracking();

    // Escuta atualizações de localização
    _locationSubscription = _locationService.locationStream.listen((location) {
      _currentLocation = location;

      _updateDistance();

      _calculateRoute(); // Recalcula a rota quando a localização muda

      _sendLocationToServer();

      notifyListeners();
    });

    // Obtém localização inicial
    final initialLocation = await _locationService.getCurrentLocation();

    if (initialLocation != null) {
      _currentLocation = initialLocation;

      await _calculateRoute(); // Aguarda carregar a rota

      _updateDistance();

      notifyListeners();
    }
  }

  /// Calcula a rota até o cliente usando Google Directions API
  Future<void> _calculateRoute() async {
    if (_currentDelivery == null || _currentLocation == null) return;

    _isLoadingRoute = true;

    notifyListeners();

    try {
      // Obtém a rota pelas ruas usando Directions API
      final route = await _directionsService.getRoute(
        _currentLocation!,
        _currentDelivery!.customerLocation,
      );

      _routePoints = route;

      print('Rota calculada com ${route.length} pontos');
    } catch (e) {
      print('Erro ao calcular rota: $e');

      // Fallback: rota em linha reta
      _routePoints = [_currentLocation!, _currentDelivery!.customerLocation];
    } finally {
      _isLoadingRoute = false;

      notifyListeners();
    }
  }

  /// Atualiza a distância restante
  void _updateDistance() {
    if (_currentDelivery == null || _currentLocation == null) return;

    _distanceRemaining = _locationService.calculateDistance(
      _currentLocation!,
      _currentDelivery!.customerLocation,
    );

    // Se chegou ao destino (menos de 50 metros)
    if (_distanceRemaining < 50) {
      completeDelivery();
    }
  }

  /// Envia localização para o servidor
  void _sendLocationToServer() {
    if (_currentDelivery == null || _currentLocation == null) return;

    _apiService.sendLocationUpdate(
      _currentDelivery!.id,
      _currentLocation!,
      _distanceRemaining,
    );
  }

  /// Completa a entrega
  Future<void> completeDelivery() async {
    if (_currentDelivery == null) return;

    await _apiService.updateDeliveryStatus(
      _currentDelivery!.id,
      DeliveryStatus.delivered,
    );

    // Para o rastreamento
    _locationService.stopTracking();

    _locationSubscription?.cancel();

    // Reseta o estado
    _currentDelivery = null;

    _currentLocation = null;

    _distanceRemaining = 0.0;

    _isTracking = false;

    _routePoints = [];

    notifyListeners();
  }

  /// Cancela uma entrega
  Future<void> cancelDelivery() async {
    if (_currentDelivery == null) return;

    _locationService.stopTracking();

    _locationSubscription?.cancel();

    _currentDelivery = null;

    _currentLocation = null;

    _distanceRemaining = 0.0;

    _isTracking = false;

    _routePoints = [];

    notifyListeners();
  }

  @override
  void dispose() {
    _deliverySubscription?.cancel();

    _locationSubscription?.cancel();

    _locationService.dispose();

    _apiService.dispose();

    super.dispose();
  }
}
