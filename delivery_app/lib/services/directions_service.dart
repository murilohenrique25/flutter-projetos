import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

/// Serviço para obter rotas usando Google Directions API
class DirectionsService {
  // IMPORTANTE: Substitua pela sua chave da API do Google Maps
  // A mesma chave usada no AndroidManifest.xml
  static const String _apiKey = 'CONFIGURE_NO_AMBIENTE';

  /// Obtém a rota entre dois pontos usando Google Directions API
  Future<List<LatLng>> getRoute(LatLng origin, LatLng destination) async {
    try {
      final String url =
          'https://maps.googleapis.com/maps/api/directions/json?'
          'origin=${origin.latitude},${origin.longitude}'
          '&destination=${destination.latitude},${destination.longitude}'
          '&mode=driving'
          '&key=$_apiKey';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == 'OK') {
          // Extrai os pontos da rota
          final polylinePoints = data['routes'][0]['overview_polyline']['points'];

          // Decodifica a polyline
          final PolylinePoints polylinePointsDecoder = PolylinePoints();
          final List<PointLatLng> result =
              polylinePointsDecoder.decodePolyline(polylinePoints);

          // Converte para LatLng
          final routePoints = result
              .map((point) => LatLng(point.latitude, point.longitude))
              .toList();

          print('✅ Rota calculada com ${routePoints.length} pontos');
          return routePoints;
        } else {
          print('⚠️ Directions API error: ${data['status']}');
          if (data['status'] == 'REQUEST_DENIED') {
            print('🔑 Verifique se a chave da API está correta e se a Directions API está ativada!');
          }
          // Se falhar, retorna rota em linha reta
          return [origin, destination];
        }
      } else {
        print('❌ HTTP error: ${response.statusCode}');
        return [origin, destination];
      }
    } catch (e) {
      print('❌ Error getting route: $e');
      // Em caso de erro, retorna rota em linha reta
      return [origin, destination];
    }
  }

  /// Obtém a distância e duração da rota
  Future<Map<String, dynamic>> getRouteInfo(
    LatLng origin,
    LatLng destination,
  ) async {
    try {
      final String url =
          'https://maps.googleapis.com/maps/api/directions/json?'
          'origin=${origin.latitude},${origin.longitude}'
          '&destination=${destination.latitude},${destination.longitude}'
          '&mode=driving'
          '&key=$_apiKey';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == 'OK') {
          final leg = data['routes'][0]['legs'][0];

          return {
            'distance': leg['distance']['value'], // em metros
            'duration': leg['duration']['value'], // em segundos
            'distanceText': leg['distance']['text'],
            'durationText': leg['duration']['text'],
          };
        }
      }
    } catch (e) {
      print('Error getting route info: $e');
    }

    return {
      'distance': 0,
      'duration': 0,
      'distanceText': 'N/A',
      'durationText': 'N/A',
    };
  }
}