import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../core/theme/app_theme.dart';

class PlaceDetailScreen extends StatefulWidget {
  final String name;
  final String location;
  final String description;
  final double lat;
  final double lng;
  final String imageUrl;
  final String nearestStop;

  const PlaceDetailScreen({
    super.key,
    required this.name,
    required this.location,
    required this.description,
    required this.lat,
    required this.lng,
    this.imageUrl = '',
    required this.nearestStop,
  });

  @override
  State<PlaceDetailScreen> createState() => _PlaceDetailScreenState();
}

class _PlaceDetailScreenState extends State<PlaceDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // =============================================
          // COLLAPSIBLE HEADER WITH IMAGE
          // =============================================
          Expanded(
            child: CustomScrollView(
              slivers: [
                // Image - Full width, collapsible
                SliverAppBar(
                  expandedHeight: 280,
                  floating: true,
                  pinned: true,
                  backgroundColor: Colors.white,
                  elevation: 0,
                  leading: IconButton(
                    onPressed: () => context.pop(),
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        image: widget.imageUrl.isNotEmpty
                            ? DecorationImage(
                                image: NetworkImage(widget.imageUrl),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: widget.imageUrl.isEmpty
                          ? Center(
                              child: Icon(
                                Icons.image_outlined,
                                size: 80,
                                color: Colors.grey.shade500,
                              ),
                            )
                          : null,
                    ),
                  ),
                ),

                // =============================================
                // CONTENT BELOW IMAGE
                // =============================================
                SliverPadding(
                  padding: const EdgeInsets.all(16.0),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Text(
                          '# ${widget.name}',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        // Location
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: Colors.grey,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              widget.location,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // About Section
                        const Text(
                          'About',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          widget.description,
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.onSurfaceLight,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // =============================================
                        // MAP
                        // =============================================
                        const Text(
                          'Location',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          height: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: AppColors.outline.withOpacity(0.1),
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: FlutterMap(
                              options: MapOptions(
                                initialCenter: LatLng(widget.lat, widget.lng),
                                initialZoom: 15,
                                interactionOptions: const InteractionOptions(
                                  flags: InteractiveFlag.all,
                                ),
                              ),
                              children: [
                                TileLayer(
                                  urlTemplate:
                                      'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                                  userAgentPackageName: 'com.sajiloyatra.app',
                                ),
                                MarkerLayer(
                                  markers: [
                                    Marker(
                                      point: LatLng(widget.lat, widget.lng),
                                      width: 40,
                                      height: 40,
                                      child: const Icon(
                                        Icons.location_pin,
                                        color: Colors.red,
                                        size: 40,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // =============================================
          // FIXED BOTTOM BUTTONS
          // =============================================
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Navigate to City Bus with source and destination
                      context.push('/city-bus', extra: {
                        'source': 'Current Location',
                        'destination': widget.nearestStop,
                        'autoSearch': true,
                      });
                    },
                    icon: const Icon(Icons.directions_bus, size: 18),
                    label: const Text('Via Local Bus'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // Add to favorites
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Added to Favorites!'),
                          backgroundColor: AppColors.primary,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    icon: const Icon(Icons.star_border, size: 18),
                    label: const Text('Add to Favorites'),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.primary),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}