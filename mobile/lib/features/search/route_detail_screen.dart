import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../../shared/widgets/elevated_card.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../core/theme/app_theme.dart';
// import '../../core/constants.dart';
import 'fare_breakdown_modal.dart';

class RouteDetailScreen extends StatelessWidget {
  final Map<String, dynamic> route;
  const RouteDetailScreen({super.key, required this.route});

  @override
  Widget build(BuildContext context) {
    final totalFare = route['total_fare_npr'] ?? 0;
    final legs = route['legs'] as List? ?? [];
    final fromStop = legs.isNotEmpty ? legs.first['from_stop'] : 'Origin';
    final toStop = legs.isNotEmpty ? legs.last['to_stop'] : 'Destination';
    final routePoints = _getRoutePoints(legs);
    final center = routePoints.isNotEmpty ? routePoints.first : const LatLng(27.7172, 85.3240);

    return Scaffold(
      body: Stack(
        children: [
          // =============================================
          // MAP
          // =============================================
          FlutterMap(
            options: MapOptions(
              initialCenter: center,
              initialZoom: 13.0,
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.all,
              ),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.sajiloyatra.app',
              ),
              if (routePoints.isNotEmpty)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: routePoints,
                      color: AppColors.primary,
                      strokeWidth: 4.0,
                    ),
                  ],
                ),
              MarkerLayer(
                markers: [
                  // Start marker
                  if (routePoints.isNotEmpty)
                    Marker(
                      point: routePoints.first,
                      width: 30,
                      height: 30,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(Icons.flag, color: Colors.white, size: 16),
                      ),
                    ),
                  // End marker
                  if (routePoints.length > 1)
                    Marker(
                      point: routePoints.last,
                      width: 30,
                      height: 30,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(Icons.flag, color: Colors.white, size: 16),
                      ),
                    ),
                ],
              ),
            ],
          ),
          
          // =============================================
          // BACK BUTTON
          // =============================================
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white.withOpacity(0.9),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      color: AppColors.onSurface,
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const Spacer(),
                  CircleAvatar(
                    backgroundColor: Colors.white.withOpacity(0.9),
                    child: IconButton(
                      icon: const Icon(Icons.share_outlined),
                      color: AppColors.onSurface,
                      onPressed: () {
                        // Share route
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // =============================================
          // BOTTOM CARD
          // =============================================
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: ElevatedCard(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Route Info
                  Row(
                    children: [
                      Icon(Icons.route, color: AppColors.primary, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '$fromStop → $toStop',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: AppSpacing.md),
                  
                  // Route Stats
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatItem(
                        context,
                        icon: Icons.directions_bus,
                        label: '${legs.length} Bus${legs.length > 1 ? 'es' : ''}',
                      ),
                      _buildStatItem(
                        context,
                        icon: Icons.timer,
                        label: '${route['duration_minutes'] ?? 25} min',
                      ),
                      _buildStatItem(
                        context,
                        icon: Icons.attach_money,
                        label: 'Rs. $totalFare',
                      ),
                      _buildStatItem(
                        context,
                        icon: Icons.transfer_within_a_station,
                        label: '${route['transfers'] ?? 0} Transfer${(route['transfers'] ?? 0) > 1 ? 's' : ''}',
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: AppSpacing.md),
                  
                  // Buttons
                  Row(
                    children: [
                      Expanded(
                        child: PrimaryButton(
                          text: 'Start Navigation',
                          onPressed: () {},
                        ),
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton(
                        onPressed: () => showModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.transparent,
                          isScrollControlled: true,
                          builder: (context) => FareBreakdownModal(route: route),
                        ),
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppRadius.medium),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          minimumSize: Size.zero,
                        ),
                        child: const Icon(Icons.receipt_long),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =============================================
  // HELPERS
  // =============================================
  Widget _buildStatItem(BuildContext context, {
    required IconData icon,
    required String label,
  }) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primary, size: 22),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  List<LatLng> _getRoutePoints(List legs) {
    if (legs.isEmpty) return [];
    
    final points = <LatLng>[];
    for (final leg in legs) {
      final lat = leg['lat'] as double?;
      final lng = leg['lng'] as double?;
      if (lat != null && lng != null) {
        points.add(LatLng(lat, lng));
      }
    }
    return points;
  }
}