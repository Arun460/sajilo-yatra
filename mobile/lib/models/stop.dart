class Stop {
  final int id;
  final String stopName;
  final double latitude;
  final double longitude;
  final String? areaName;
  final String? district;
  final String? nepaliName;  // ← Add this

  Stop({
    required this.id,
    required this.stopName,
    required this.latitude,
    required this.longitude,
    this.areaName,
    this.district,
    this.nepaliName,
  });

  factory Stop.fromJson(Map<String, dynamic> json) {
    return Stop(
      id: json['id'] ?? 0,
      stopName: json['stop_name'] ?? json['name'] ?? '',
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
      areaName: json['area_name'],
      district: json['district'],
      nepaliName: json['nepali_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'stop_name': stopName,
      'latitude': latitude,
      'longitude': longitude,
      'area_name': areaName,
      'district': district,
      'nepali_name': nepaliName,
    };
  }
}