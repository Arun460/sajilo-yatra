import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';

class MyPlanScreen extends StatefulWidget {
  const MyPlanScreen({super.key});

  @override
  State<MyPlanScreen> createState() => _MyPlanScreenState();
}

class _MyPlanScreenState extends State<MyPlanScreen> {
  String? _source;
  String? _destination;
  DateTime _selectedDate = DateTime.now();
  List<String> _selectedPlaces = [];

  final List<Map<String, String>> _popularPlaces = const [
    {'name': 'Patan', 'tag': 'UNESCO', 'emoji': '🛕'},
    {'name': 'Swayambhu', 'tag': 'Monkey Temple', 'emoji': '⛩️'},
    {'name': 'Bhaktapur', 'tag': 'Ancient City', 'emoji': '🏛️'},
    {'name': 'Kirtipur', 'tag': 'Newar City', 'emoji': '🏔️'},
    {'name': 'Bouddha', 'tag': 'Stupa', 'emoji': '⛰️'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: const Text(
          'My Plan',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Plan your journey in Kathmandu',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),

            // Calendar
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.outline.withOpacity(0.15),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today, color: AppColors.primary, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.onSurface,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => _selectDate(context),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Change Date',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Source
            GestureDetector(
              onTap: () {
                _showPlacePicker(context, 'source');
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.location_on, color: AppColors.primary, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _source ?? 'Select source...',
                        style: TextStyle(
                          color: _source != null
                              ? AppColors.onSurface
                              : AppColors.onSurfaceLight,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Destination
            GestureDetector(
              onTap: () {
                _showPlacePicker(context, 'destination');
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.flag, color: AppColors.secondary, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _destination ?? 'Select destination...',
                        style: TextStyle(
                          color: _destination != null
                              ? AppColors.onSurface
                              : AppColors.onSurfaceLight,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Popular Places
            const Text(
              'POPULAR PLACES',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.outline,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.1,
              ),
              itemCount: _popularPlaces.length,
              itemBuilder: (context, index) {
                final place = _popularPlaces[index];
                final isSelected = _selectedPlaces.contains(place['name']);
                return _buildPlaceCard(
                  context: context,
                  emoji: place['emoji']!,
                  name: place['name']!,
                  tag: place['tag']!,
                  isSelected: isSelected,
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        _selectedPlaces.remove(place['name']);
                      } else {
                        _selectedPlaces.add(place['name']!);
                      }
                    });
                  },
                );
              },
            ),
            const SizedBox(height: 24),

            // Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  bool hasSourceAndDestination = _source != null && _destination != null;
                  bool hasPopularPlaces = _selectedPlaces.isNotEmpty;

                  if (hasSourceAndDestination || hasPopularPlaces) {
                    // ✅ Create plan data
                    final newPlan = {
                      'id': DateTime.now().millisecondsSinceEpoch,
                      'day': '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                      'source': _source,
                      'destination': _destination,
                      'time': '9:00 AM',
                      'duration': '45 min',
                      'fare': 'Rs. 35',
                      'places': List.from(_selectedPlaces),
                    };

                    // ✅ Navigate to Saved screen with the new plan data
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Plan saved successfully! ✅'),
                        backgroundColor: AppColors.primary,
                        duration: Duration(seconds: 2),
                      ),
                    );

                    // ✅ Pass the new plan to SavedScreen via extra
                    context.push('/saved', extra: {'newPlan': newPlan});
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please select a route or popular places to save'),
                        backgroundColor: AppColors.error,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'SAVE PLAN',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceCard({
    required BuildContext context,
    required String emoji,
    required String name,
    required String tag,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.outline.withOpacity(0.15),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              emoji,
              style: const TextStyle(fontSize: 28),
            ),
            const SizedBox(height: 8),
            Text(
              name,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              tag,
              style: TextStyle(
                fontSize: 10,
                color: AppColors.onSurfaceLight,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                isSelected ? 'Selected ✓' : 'Select',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : AppColors.onSurfaceLight,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPlacePicker(BuildContext context, String type) {
    final List<String> places = [
      'Gongabu',
      'Kalanki',
      'Bouddha',
      'Patan',
      'Swayambhu',
      'Bhaktapur',
      'Kirtipur',
      'Maitighar',
    ];

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
                Text(
                  type == 'source' ? 'Select Source' : 'Select Destination',
                  style: const TextStyle(
                    fontSize: 18,
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
            const SizedBox(height: 12),
            TextField(
              decoration: InputDecoration(
                hintText: 'Search places...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: AppColors.surfaceContainer,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: places.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Icon(
                      type == 'source' ? Icons.location_on : Icons.flag,
                      color: AppColors.primary,
                    ),
                    title: Text(places[index]),
                    onTap: () {
                      setState(() {
                        if (type == 'source') {
                          _source = places[index];
                        } else {
                          _destination = places[index];
                        }
                      });
                      Navigator.pop(context);
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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }
}