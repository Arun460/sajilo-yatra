import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/widgets/elevated_card.dart';
import '../../../shared/widgets/route_chip.dart';
import '../../core/api_service.dart';
import '../../core/theme/app_theme.dart';
// import '../../core/constants.dart';
import '../../models/search_data.dart';
import 'dart:io';

class RouteResultsScreen extends StatefulWidget {
  final SearchData searchData;
  final String? preference;

  const RouteResultsScreen({
    super.key,
    required this.searchData,
    this.preference,
  });

  @override
  State<RouteResultsScreen> createState() => _RouteResultsScreenState();
}

class _RouteResultsScreenState extends State<RouteResultsScreen> {
  late Future<Map<String, dynamic>> _routesFuture;

  @override
  void initState() {
    super.initState();
    _fetchRoutes();
  }

  void _fetchRoutes() {
    _routesFuture = ApiService.searchRoutes(
      originLat: widget.searchData.sourceLat != null 
          ? double.parse(widget.searchData.sourceLat!) 
          : 27.7058,
      originLng: widget.searchData.sourceLng != null 
          ? double.parse(widget.searchData.sourceLng!) 
          : 85.3148,
      destLat: widget.searchData.destLat != null 
          ? double.parse(widget.searchData.destLat!) 
          : 27.6931,
      destLng: widget.searchData.destLng != null 
          ? double.parse(widget.searchData.destLng!) 
          : 85.2811,
      preference: widget.preference ?? 'fastest',
    );
    _routesFuture.catchError((e) {
      if (mounted) {
        if (e is SocketException || 
            e.toString().contains('SocketException') || 
            e.toString().contains('ClientException')) {
          context.pushReplacement('/no-internet', extra: () {
            if (mounted) {
              context.pushReplacement('/results', extra: widget.searchData);
            }
          });
        } else {
          context.pushReplacement('/error-empty', extra: {
            'title': 'Error',
            'message': e.toString(),
            'actionLabel': 'Retry',
            'onAction': () {
              if (mounted) {
                context.pushReplacement('/results', extra: widget.searchData);
              }
            }
          });
        }
      }
      throw e;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          '${widget.searchData.source} → ${widget.searchData.destination}',
          style: Theme.of(context).textTheme.titleMedium,
          overflow: TextOverflow.ellipsis,
        ),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
          IconButton(
            onPressed: _fetchRoutes,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _routesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildSkeleton(context);
          } else if (snapshot.hasError) {
            return const SizedBox(); // Handled by catchError navigation
          } else if (snapshot.hasData) {
            final results = snapshot.data!['results'] as List? ?? [];
            if (results.isEmpty) {
              return _buildEmptyState(context);
            }
            return _buildResultsList(context, results);
          }
          return const SizedBox();
        },
      ),
    );
  }

  // =============================================
  // RESULTS LIST
  // =============================================
  Widget _buildResultsList(BuildContext context, List results) {
    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: results.length,
      itemBuilder: (context, index) {
        final route = results[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.md),
          child: _buildResultCard(context, route),
        );
      },
    );
  }

  Widget _buildResultCard(BuildContext context, Map<String, dynamic> route) {
    final label = route['label'] ?? 'Route';
    final time = route['total_time_min'] ?? 0;
    final fare = route['total_fare_npr'] ?? 0;
    final transferCount = route['transfer_count'] ?? 0;
    final walkingDist = (route['walking_distance_km'] as num? ?? 0).toStringAsFixed(1);
    
    final legs = route['legs'] as List? ?? [];
    final busLegs = legs.where((leg) => leg['mode'] == 'bus').toList();
    final routes = busLegs.map((l) => l['route_id'].toString()).toList();

    return GestureDetector(
      onTap: () => context.push('/bus-options', extra: route),
      child: ElevatedCard(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Route Name & Time
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    label,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                  child: Text(
                    '$time min',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: AppSpacing.sm),
            
            // Route Details
            Row(
              children: [
                _buildDetailChip(
                  context,
                  icon: Icons.transfer_within_a_station,
                  label: '$transferCount transfer${transferCount != 1 ? 's' : ''}',
                ),
                const SizedBox(width: 8),
                _buildDetailChip(
                  context,
                  icon: Icons.directions_walk,
                  label: '${walkingDist}km walk',
                ),
              ],
            ),
            
            const SizedBox(height: AppSpacing.md),
            
            // Bus Routes & Fare
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: routes.map((r) => RouteChip(label: r)).toList(),
                  ),
                ),
                Text(
                  'Rs. $fare',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailChip(BuildContext context, {
    required IconData icon,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.outline),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.onSurfaceMedium,
            ),
          ),
        ],
      ),
    );
  }

  // =============================================
  // SKELETON LOADING
  // =============================================
  Widget _buildSkeleton(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: 3,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.md),
          child: ElevatedCard(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 20,
                      width: 120,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    Container(
                      height: 20,
                      width: 60,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Container(
                      height: 16,
                      width: 80,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      height: 16,
                      width: 70,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 24,
                      width: 80,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    Container(
                      height: 20,
                      width: 60,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // =============================================
  // EMPTY STATE
  // =============================================
  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.route_outlined,
            size: 80,
            color: AppColors.outline.withOpacity(0.3),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'No Routes Found',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Try adjusting your search or preferences',
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
}