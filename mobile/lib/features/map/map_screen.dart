import 'package:flutter/material.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map View'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: const Center(
        child: Text('Map View - Coming Soon'),
      ),
    );
  }
}