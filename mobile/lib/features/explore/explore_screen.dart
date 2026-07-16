import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final TextEditingController _searchController = TextEditingController();
  
  List<Map<String, String>> _suggestions = [];

  void _updateSuggestions(String query) {
    // TODO: Fetch from database when connected
    setState(() {
      _suggestions = [];
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  final List<Map<String, String>> _allPlaces = const [
    {'name': 'Patan', 'tag': 'UNESCO', 'emoji': '🛕'},
    {'name': 'Swayambhu', 'tag': 'Monkey Temple', 'emoji': '⛩️'},
    {'name': 'Bhaktapur', 'tag': 'Ancient City', 'emoji': '🏛️'},
    {'name': 'Kirtipur', 'tag': 'Newar City', 'emoji': '🏔️'},
    {'name': 'Bouddha', 'tag': 'Stupa', 'emoji': '⛰️'},
    {'name': 'Pashupatinath', 'tag': 'Temple', 'emoji': '🕉️'},
    {'name': 'Garden of Dreams', 'tag': 'Garden', 'emoji': '🌺'},
    {'name': 'Nagarkot', 'tag': 'Viewpoint', 'emoji': '🌅'},
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
          'Explore Kathmandu',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
      ),
      body: Column(
        children: [
          // =============================================
          // SEARCH BAR - Search icon on right
          // =============================================
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.outline.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          decoration: const InputDecoration(
                            hintText: 'Search places...',
                            border: InputBorder.none,
                            hintStyle: TextStyle(
                              color: AppColors.onSurfaceLight,
                              fontSize: 14,
                            ),
                          ),
                          onChanged: (value) {
                            _updateSuggestions(value);
                          },
                        ),
                      ),
                      if (_searchController.text.isNotEmpty)
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _searchController.clear();
                              _suggestions = [];
                            });
                          },
                          icon: Icon(
                            Icons.close,
                            size: 18,
                            color: AppColors.outline,
                          ),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          splashRadius: 18,
                        ),
                      const Icon(
                        Icons.search,
                        color: AppColors.primary,
                        size: 22,
                      ),
                    ],
                  ),
                ),
                // Suggestions List
                if (_suggestions.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _suggestions.length,
                      itemBuilder: (context, index) {
                        final suggestion = _suggestions[index];
                        return ListTile(
                          leading: const Icon(
                            Icons.location_on,
                            color: AppColors.primary,
                            size: 18,
                          ),
                          title: Text(
                            suggestion['name']!,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          subtitle: Text(
                            suggestion['nepali']!,
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.onSurfaceLight,
                            ),
                          ),
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              'Place',
                              style: TextStyle(
                                fontSize: 10,
                                color: AppColors.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              _searchController.text = suggestion['name']!;
                              _suggestions = [];
                            });
                          },
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),

          // =============================================
          // ALL PLACES GRID
          // =============================================
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.1,
                ),
                itemCount: _allPlaces.length,
                itemBuilder: (context, index) {
                  final place = _allPlaces[index];
                  return _buildPlaceCard(
                    context,
                    emoji: place['emoji']!,
                    name: place['name']!,
                    tag: place['tag']!,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceCard(
    BuildContext context, {
    required String emoji,
    required String name,
    required String tag,
  }) {
    return GestureDetector(
      onTap: () {
        final placeData = _getPlaceData(name);
        context.push('/place-detail', extra: {
          'name': name,
          'location': '$tag, Kathmandu',
          'description': placeData['description'],
          'lat': placeData['lat'],
          'lng': placeData['lng'],
          'nearestStop': placeData['nearestStop'],
        });
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
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
            Text(
              emoji,
              style: const TextStyle(fontSize: 32),
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
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                tag,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primary,
                ),
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.arrow_forward,
                    size: 10,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 2),
                  Text(
                    'View',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =============================================
  // PLACE DATA
  // =============================================
  Map<String, dynamic> _getPlaceData(String name) {
    switch (name) {
      case 'Patan':
        return {
          'description': 'A UNESCO World Heritage Site. Patan Durbar Square is known for its rich culture, temples, and Newar architecture.',
          'lat': 27.6745,
          'lng': 85.3237,
          'nearestStop': 'Patan',
        };
      case 'Swayambhu':
        return {
          'description': 'An ancient religious architecture atop a hill in Kathmandu Valley. Also known as the Monkey Temple, it is one of the oldest and most revered Buddhist sites in Nepal.',
          'lat': 27.7148,
          'lng': 85.2904,
          'nearestStop': 'Swayambhu',
        };
      case 'Bhaktapur':
        return {
          'description': 'A UNESCO World Heritage Site, known for its rich culture, temples, and woodcarving. The city is a living museum of medieval Newar architecture.',
          'lat': 27.6722,
          'lng': 85.4278,
          'nearestStop': 'Bhaktapur',
        };
      case 'Kirtipur':
        return {
          'description': 'An ancient city with stunning views of the Kathmandu Valley. Known for its traditional Newar culture, temples, and friendly locals.',
          'lat': 27.6666,
          'lng': 85.2770,
          'nearestStop': 'Kirtipur',
        };
      case 'Bouddha':
        return {
          'description': 'One of the largest stupas in Nepal and a UNESCO World Heritage Site. It is a major pilgrimage site for Buddhists and a symbol of peace.',
          'lat': 27.7213,
          'lng': 85.3617,
          'nearestStop': 'Bouddha',
        };
      case 'Pashupatinath':
        return {
          'description': 'The most sacred Hindu temple in Nepal, dedicated to Lord Shiva. Located on the banks of the Bagmati River, it attracts thousands of pilgrims daily.',
          'lat': 27.7100,
          'lng': 85.3480,
          'nearestStop': 'Gaushala',
        };
      case 'Garden of Dreams':
        return {
          'description': 'A beautiful neo-classical garden in Kathmandu. Built in the 1920s, it\'s a peaceful escape from the busy city streets.',
          'lat': 27.7160,
          'lng': 85.3180,
          'nearestStop': 'Thamel',
        };
      case 'Nagarkot':
        return {
          'description': 'A popular hill station near Kathmandu, offering panoramic views of the Himalayas. Best known for sunrise and sunset views.',
          'lat': 27.7300,
          'lng': 85.5200,
          'nearestStop': 'Bhaktapur',
        };
      default:
        return {
          'description': 'A beautiful place to visit in Kathmandu Valley.',
          'lat': 27.7172,
          'lng': 85.3240,
          'nearestStop': 'Kathmandu',
        };
    }
  }
}