import 'package:google_maps_flutter/google_maps_flutter.dart';

class Delivery {
  final String id;
  final String establishmentName;
  final LatLng establishmentLocation;
  final LatLng customerLocation;
  final String customerAddress;
  final double value;
  final DeliveryStatus status;
  final String? deliveryPersonId;

  Delivery({
    required this.id,
    required this.establishmentName,
    required this.establishmentLocation,
    required this.customerLocation,
    required this.customerAddress,
    required this.value,
    this.status = DeliveryStatus.available,
    this.deliveryPersonId,
  });

  Delivery copyWith({
    DeliveryStatus? status,
    String? deliveryPersonId,
  }) {
    return Delivery(
      id: id,
      establishmentName: establishmentName,
      establishmentLocation: establishmentLocation,
      customerLocation: customerLocation,
      customerAddress: customerAddress,
      value: value,
      status: status ?? this.status,
      deliveryPersonId: deliveryPersonId ?? this.deliveryPersonId,
    );
  }

  factory Delivery.fromJson(Map<String, dynamic> json) {
    return Delivery(
      id: json['id'],
      establishmentName: json['establishmentName'],
      establishmentLocation: LatLng(
        json['establishmentLocation']['lat'],
        json['establishmentLocation']['lng'],
      ),
      customerLocation: LatLng(
        json['customerLocation']['lat'],
        json['customerLocation']['lng'],
      ),
      customerAddress: json['customerAddress'],
      value: json['value'].toDouble(),
      status: DeliveryStatus.values.firstWhere(
        (e) => e.toString() == 'DeliveryStatus.${json['status']}',
        orElse: () => DeliveryStatus.available,
      ),
      deliveryPersonId: json['deliveryPersonId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'establishmentName': establishmentName,
      'establishmentLocation': {
        'lat': establishmentLocation.latitude,
        'lng': establishmentLocation.longitude,
      },
      'customerLocation': {
        'lat': customerLocation.latitude,
        'lng': customerLocation.longitude,
      },
      'customerAddress': customerAddress,
      'value': value,
      'status': status.toString().split('.').last,
      'deliveryPersonId': deliveryPersonId,
    };
  }
}

enum DeliveryStatus {
  available,
  accepted,
  pickedUp,
  inTransit,
  delivered,
}

class LocationUpdate {
  final LatLng position;
  final double distanceRemaining;
  final DateTime timestamp;

  LocationUpdate({
    required this.position,
    required this.distanceRemaining,
    required this.timestamp,
  });
}