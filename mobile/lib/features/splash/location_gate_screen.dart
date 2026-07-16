import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:go_router/go_router.dart';

class LocationGateScreen extends StatefulWidget {
  const LocationGateScreen({super.key});

  @override
  State<LocationGateScreen> createState() => _LocationGateScreenState();
}

class _LocationGateScreenState extends State<LocationGateScreen> {
  bool _checking = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    try {
      final status = await Permission.location.request();
      if (!status.isGranted) {
        setState(() {
          _checking = false;
          _error = 'Location permission is required to use this app.';
        });
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _checking = false;
      });

      if (!mounted) return;
      context.go('/home', extra: {
        'lat': position.latitude,
        'lng': position.longitude,
      });
    } catch (e) {
      setState(() {
        _checking = false;
        _error = 'Failed to get location: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _checking
            ? const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Requesting location permission...'),
                ],
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.location_on, size: 64),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      _error ?? 'Location ready',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _init,
                    child: const Text('Try Again'),
                  ),
                ],
              ),
      ),
    );
  }
}
