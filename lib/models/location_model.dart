class LocationData {
  final double latitude;
  final double longitude;
  final String address;
  final String timestamp;

  LocationData({
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'timestamp': timestamp,
    };
  }

  factory LocationData.fromMap(Map<String, dynamic> map) {
    return LocationData(
      latitude: map['latitude']?.toDouble() ?? 0.0,
      longitude: map['longitude']?.toDouble() ?? 0.0,
      address: map['address'] ?? '',
      timestamp: map['timestamp'] ?? '',
    );
  }

  @override
  String toString() {
    return 'LocationData(latitude: $latitude, longitude: $longitude, address: $address, timestamp: $timestamp)';
  }
}

class LocationPrediction {
  final String placeId;
  final String description;

  LocationPrediction({required this.placeId, required this.description});

  factory LocationPrediction.fromMap(Map<String, dynamic> map) {
    return LocationPrediction(
      placeId: map['place_id'] ?? '',
      description: map['description'] ?? '',
    );
  }

  @override
  String toString() {
    return 'LocationPrediction(placeId: $placeId, description: $description)';
  }
}
