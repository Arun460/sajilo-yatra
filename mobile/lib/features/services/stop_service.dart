import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/stop.dart';

class StopService {
  // Chrome
  static const String baseUrl = 'http://localhost:8000/api';

  // Android Emulator
  // static const String baseUrl = 'http://10.0.2.2:8000/api';

  static Future<List<Stop>> getAllStops() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/stops'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Stop.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print(e);
      return [];
    }
  }

  static Future<List<Stop>> searchStops(String query) async {
    if (query.isEmpty) return getAllStops();

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/stops/search?q=${Uri.encodeComponent(query)}'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Stop.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print(e);
      return [];
    }
  }

  static Future<List<Stop>> getNearbyStops(
    double lat,
    double lng, {
    double radius = 5.0,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/stops/nearby?lat=$lat&lng=$lng&radius=$radius'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Stop.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print(e);
      return [];
    }
  }
}