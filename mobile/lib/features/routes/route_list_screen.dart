import 'package:flutter/material.dart';

class RouteListScreen extends StatelessWidget {
  final String operatorName;
  final String? operatorCode;

  const RouteListScreen({
    super.key,
    required this.operatorName,
    this.operatorCode,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$operatorName Routes'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Text('Routes for $operatorName - Coming Soon'),
      ),
    );
  }
}