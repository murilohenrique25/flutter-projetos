import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GeocodingService {
  static const String _apiKey = 'CONFIGURE_NO_AMBIENTE';  // Mesma do Directions

  /// Converte lat/lng em endereço legível
  static Future<String?> getAddressFromLatLng(LatLng location) async {
    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/geocode/json?'
      'latlng=${location.latitude},${location.longitude}'
      '&key=$_apiKey'
      '&language=pt-BR'  // Português
      '&result_type=street_address'  // Prioriza ruas
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == 'OK' && data['results'].isNotEmpty) {
          return data['results'][0]['formatted_address'];
        }
      }
    } catch (e) {
      print('Erro geocoding: $e');
    }

    return null;
  }
}
