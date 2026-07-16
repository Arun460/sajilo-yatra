import 'stop.dart';

class BusRoute {
  final int id;
  final String routeId;
  final String routeNumber;
  final String direction;
  final String? originStop;
  final String? destinationStop;
  final String? operatorName;
  final String? routeType;
  final List<RouteStop>? stops;

  BusRoute({
    required this.id,
    required this.routeId,
    required this.routeNumber,
    required this.direction,
    this.originStop,
    this.destinationStop,
    this.operatorName,
    this.routeType,
    this.stops,
  });

  factory BusRoute.fromJson(Map<String, dynamic> json) {
    return BusRoute(
      id: json['id'] ?? 0,
      routeId: json['route_id'] ?? '',
      routeNumber: json['route_number'] ?? '',
      direction: json['direction'] ?? '',
      originStop: json['origin_stop'],
      destinationStop: json['destination_stop'],
      operatorName: json['operator_name'],
      routeType: json['route_type'],
      stops: json['stops'] != null
          ? (json['stops'] as List).map((s) => RouteStop.fromJson(s)).toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'route_id': routeId,
      'route_number': routeNumber,
      'direction': direction,
      'origin_stop': originStop,
      'destination_stop': destinationStop,
      'operator_name': operatorName,
      'route_type': routeType,
    };
  }
}

class RouteStop {
  final int id;
  final int routeId;
  final int stopId;
  final int stopSequence;
  final String? originalStopName;
  final bool isMajorStop;
  final Stop? stop;

  RouteStop({
    required this.id,
    required this.routeId,
    required this.stopId,
    required this.stopSequence,
    this.originalStopName,
    this.isMajorStop = false,
    this.stop,
  });

  factory RouteStop.fromJson(Map<String, dynamic> json) {
    return RouteStop(
      id: json['id'] ?? 0,
      routeId: json['route_id'] ?? 0,
      stopId: json['stop_id'] ?? 0,
      stopSequence: json['stop_sequence'] ?? 0,
      originalStopName: json['original_stop_name'],
      isMajorStop: json['is_major_stop'] == 1 || json['is_major_stop'] == true,
      stop: json['stop'] != null ? Stop.fromJson(json['stop']) : null,
    );
  }
}