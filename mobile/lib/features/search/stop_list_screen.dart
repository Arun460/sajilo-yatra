import 'package:flutter/material.dart';

class StopListScreen extends StatelessWidget {
  const StopListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('City Vehicles'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: const Center(
        child: Text('Stop List - Coming Soon'),
      ),
    );
  }
}