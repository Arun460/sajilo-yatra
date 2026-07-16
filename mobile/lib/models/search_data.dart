class SearchData {
  final String source;
  final String destination;
  final DateTime? departureTime;
  final String? sourceId;
  final String? destinationId;
  final String? sourceLat;
  final String? sourceLng;
  final String? destLat;
  final String? destLng;

  SearchData({
    required this.source,
    required this.destination,
    this.departureTime,
    this.sourceId,
    this.destinationId,
    this.sourceLat,
    this.sourceLng,
    this.destLat,
    this.destLng,
  });

  factory SearchData.empty() => SearchData(
    source: '',
    destination: '',
  );

  factory SearchData.fromMap(Map<String, dynamic> map) {
    return SearchData(
      source: map['source'] ?? '',
      destination: map['destination'] ?? '',
      departureTime: map['departureTime'] != null
          ? DateTime.tryParse(map['departureTime'])
          : null,
      sourceId: map['sourceId'],
      destinationId: map['destinationId'],
      sourceLat: map['sourceLat'],
      sourceLng: map['sourceLng'],
      destLat: map['destLat'],
      destLng: map['destLng'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'source': source,
      'destination': destination,
      'departureTime': departureTime?.toIso8601String(),
      'sourceId': sourceId,
      'destinationId': destinationId,
      'sourceLat': sourceLat,
      'sourceLng': sourceLng,
      'destLat': destLat,
      'destLng': destLng,
    };
  }

  SearchData copyWith({
    String? source,
    String? destination,
    DateTime? departureTime,
    String? sourceId,
    String? destinationId,
    String? sourceLat,
    String? sourceLng,
    String? destLat,
    String? destLng,
  }) {
    return SearchData(
      source: source ?? this.source,
      destination: destination ?? this.destination,
      departureTime: departureTime ?? this.departureTime,
      sourceId: sourceId ?? this.sourceId,
      destinationId: destinationId ?? this.destinationId,
      sourceLat: sourceLat ?? this.sourceLat,
      sourceLng: sourceLng ?? this.sourceLng,
      destLat: destLat ?? this.destLat,
      destLng: destLng ?? this.destLng,
    );
  }
}