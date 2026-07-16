import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';

class SavedScreen extends StatefulWidget {
  const SavedScreen({super.key});

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  static List<Map<String, dynamic>> savedPlans = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final extra = GoRouterState.of(context).extra as Map<String, dynamic>?;
    if (extra != null && extra['newPlan'] != null) {
      final newPlan = extra['newPlan'] as Map<String, dynamic>;
      final exists = savedPlans.any((p) => p['id'] == newPlan['id']);
      if (!exists) {
        setState(() {
          savedPlans.insert(0, newPlan);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Saved',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
      ),
      body: savedPlans.isEmpty
          ? _buildEmptyState(context)
          : _buildSavedList(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/myplan');
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildSavedList(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: savedPlans.length,
      itemBuilder: (context, index) {
        final plan = savedPlans[index];
        return _buildPlanCard(
          context: context,
          plan: plan,
          onRemove: () {
            setState(() {
              savedPlans.removeAt(index);
            });
          },
        );
      },
    );
  }

  Widget _buildPlanCard({
    required BuildContext context,
    required Map<String, dynamic> plan,
    required VoidCallback onRemove,
  }) {
    final hasRoute = plan['source'] != null && plan['destination'] != null;
    final places = plan['places'] != null ? (plan['places'] as List) : [];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.outline.withOpacity(0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              const Text('📌', style: TextStyle(fontSize: 18)),
              const SizedBox(width: 8),
              Text(
                plan['day'] ?? 'No date',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: onRemove,
                icon: Icon(Icons.delete_outline, size: 18, color: Colors.red),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Route (if exists) - Only source and destination, no time/fare
          if (hasRoute)
            Row(
              children: [
                Icon(Icons.location_on, size: 14, color: AppColors.primary),
                const SizedBox(width: 4),
                Text(
                  plan['source'] ?? '',
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(Icons.arrow_forward, size: 12, color: AppColors.outline),
                const SizedBox(width: 8),
                Icon(Icons.flag, size: 14, color: AppColors.secondary),
                const SizedBox(width: 4),
                Text(
                  plan['destination'] ?? '',
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ],
            ),

          // Places - Each place in a separate row
          if (places.isNotEmpty) ...[
            const SizedBox(height: 8),
            const Text(
              'Places:',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.onSurfaceLight,
              ),
            ),
            const SizedBox(height: 4),
            ...places.map((place) => Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Row(
                children: [
                  const Icon(Icons.star, size: 12, color: Colors.amber),
                  const SizedBox(width: 6),
                  Text(
                    place.toString(),
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.onSurface,
                    ),
                  ),
                ],
              ),
            )),
          ],

          const SizedBox(height: 12),

          // View Route Button
          if (hasRoute)
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      context.push('/route-detail', extra: {
                        'source': plan['source'],
                        'destination': plan['destination'],
                      });
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      side: const BorderSide(color: AppColors.primary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.directions_bus,
                          size: 14,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'View Route',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

          // View Places Button
          if (places.isNotEmpty)
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      _showAllPlacesDialog(context, places);
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      side: const BorderSide(color: AppColors.primary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.explore,
                          size: 14,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'View Places (${places.length})',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  void _showAllPlacesDialog(BuildContext context, List<dynamic> places) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        height: 400,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  '⭐',
                  style: TextStyle(fontSize: 24),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Saved Places',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Places you saved in this plan',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.onSurfaceLight,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: places.length,
                itemBuilder: (context, index) {
                  final place = places[index].toString();
                  return ListTile(
                    leading: const Icon(
                      Icons.location_on,
                      color: AppColors.primary,
                      size: 20,
                    ),
                    title: Text(
                      place,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.chevron_right,
                      color: AppColors.outline,
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      context.push('/place-detail', extra: {
                        'name': place,
                        'location': 'Kathmandu',
                        'description': 'A beautiful place to visit.',
                        'lat': 27.7172,
                        'lng': 85.3240,
                        'nearestStop': place,
                      });
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.bookmark_border,
            size: 80,
            color: AppColors.outline.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          const Text(
            'No Saved Plans',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Plan a route or save popular places',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.onSurfaceLight,
            ),
          ),
        ],
      ),
    );
  }
}