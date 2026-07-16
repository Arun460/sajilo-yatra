import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/widgets/elevated_card.dart';
import '../../../core/theme/app_theme.dart';

class BusOptionsScreen extends StatelessWidget {
  final Map<String, dynamic> route;
  final List<Map<String, dynamic>>? busOptions;

  const BusOptionsScreen({
    super.key,
    required this.route,
    this.busOptions,
  });

  @override
  Widget build(BuildContext context) {
    final buses = busOptions ?? _generateSampleBuses();
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Available Buses',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: buses.isEmpty
          ? _buildEmptyState(context)
          : _buildBusList(context, buses),
    );
  }

  Widget _buildBusList(BuildContext context, List<Map<String, dynamic>> buses) {
    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: buses.length,
      itemBuilder: (context, index) {
        final bus = buses[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.md),
          child: GestureDetector(
            onTap: () => _onBusTap(context, bus),
            child: ElevatedCard(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                children: [
                  // Bus Icon
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _getBusIcon(bus['type']),
                      color: AppColors.primary,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  
                  // Bus Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Bus Name/Number
                        Text(
                          _getBusName(bus),
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        
                        // Route Info
                        Text(
                          _getRouteInfo(bus),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  
                  // Arrow
                  Icon(
                    Icons.chevron_right,
                    color: AppColors.outline,
                    size: 24,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.directions_bus_outlined,
            size: 80,
            color: AppColors.outline.withOpacity(0.4),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'No buses available',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Try adjusting your search or timing',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.onSurfaceLight,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          ElevatedButton(
            onPressed: () => context.pop(),
            child: const Text('Go Back'),
          ),
        ],
      ),
    );
  }

  void _onBusTap(BuildContext context, Map<String, dynamic> bus) {
    context.push(
      '/route-detail',
      extra: {
        'route': route,
        'bus': bus,
      },
    );
  }

  // =============================================
  // HELPER METHODS
  // =============================================
  String _getBusName(Map<String, dynamic> bus) {
    return bus['operator_name'] ?? 'Sajilo Yatra';
  }

  String _getRouteInfo(Map<String, dynamic> bus) {
    final routeNumber = bus['route_number'] ?? route['route_number'] ?? 'R1';
    final origin = bus['origin'] ?? route['origin_stop'] ?? 'Source';
    final destination = bus['destination'] ?? route['destination_stop'] ?? 'Destination';
    return '$routeNumber • $origin → $destination';
  }

  IconData _getBusIcon(String? type) {
    switch (type?.toLowerCase()) {
      case 'tempo':
      case 'micro':
        return Icons.electric_rickshaw;
      case 'bus':
      default:
        return Icons.directions_bus;
    }
  }

  List<Map<String, dynamic>> _generateSampleBuses() {
    return [
      {
        'operator_name': 'Sajha Yatayat',
        'route_number': route['route_number'] ?? 'R1',
        'type': 'bus',
      },
      {
        'operator_name': 'Tempo',
        'route_number': route['route_number'] ?? 'R1',
        'type': 'tempo',
      },
      {
        'operator_name': 'Nepal Yatayat',
        'route_number': route['route_number'] ?? 'R1',
        'type': 'bus',
      },
    ];
  }
}