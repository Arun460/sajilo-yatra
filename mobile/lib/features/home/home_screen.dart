import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  final List<Map<String, dynamic>> _quickActions = const [
    {'icon': Icons.directions_bus, 'label': 'City Bus', 'color': AppColors.primary},
    {'icon': Icons.calendar_today, 'label': 'My Plan', 'color': Color(0xFFE67E22)},
    {'icon': Icons.emergency, 'label': 'Emergency', 'color': Color(0xFFE74C3C)},
  ];

  final List<Map<String, String>> _places = const [
    {'name': 'Patan', 'tag': 'UNESCO'},
    {'name': 'Swayambhu', 'tag': 'Monkey Temple'},
    {'name': 'Bhaktapur', 'tag': 'Ancient City'},
    {'name': 'Kirtipur', 'tag': 'Newar City'},
    {'name': 'Bouddha', 'tag': 'Stupa'},
    {'name': 'Pashupatinath', 'tag': 'Temple'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // =============================================
          // HEADER
          // =============================================
          SliverAppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            floating: true,
            expandedHeight: 110,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 20, bottom: 10),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Sajilo Yatra',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Your guide to Kathmandu Valley',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.onSurfaceLight,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              centerTitle: false,
            ),
          ),

          // =============================================
          // QUICK ACTIONS
          // =============================================
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 28.0),
            sliver: SliverToBoxAdapter(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: _quickActions.map((action) {
                  return _buildQuickAction(
                    context,
                    icon: action['icon'] as IconData,
                    label: action['label'] as String,
                    color: action['color'] as Color,
                  );
                }).toList(),
              ),
            ),
          ),

          // =============================================
          // FEATURED SECTION
          // =============================================
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'FEATURED',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.outline,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildFeaturedCard(context),
                ],
              ),
            ),
          ),

          // =============================================
          // EXPLORE SECTION
          // =============================================
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 32.0),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Explore',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.onSurface,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          context.push('/explore');
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(0, 0),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          'See All →',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    height: 160,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _places.length,
                      itemBuilder: (context, index) {
                        final place = _places[index];
                        return _buildPlaceCard(
                          context,
                          name: place['name']!,
                          tag: place['tag']!,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 15,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: 0,
          onTap: (index) {
            if (index == 1) {
              context.push('/explore');
            } else if (index == 2) {
              context.push('/saved');
            } else if (index == 3) {
              context.push('/profile');
            }
          },
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.onSurfaceLight,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 12,
          ),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.explore_outlined),
              activeIcon: Icon(Icons.explore),
              label: 'Explore',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bookmark_outline),
              activeIcon: Icon(Icons.bookmark),
              label: 'Saved',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  // =============================================
  // QUICK ACTION - Inside Box
  // =============================================
  Widget _buildQuickAction(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return GestureDetector(
      onTap: () {
        if (label == 'City Bus') {
          context.push('/city-bus');
        } else if (label == 'My Plan') {
          context.push('/myplan');
        } else if (label == 'Emergency') {
          context.push('/emergency');
        }
      },
      child: Container(
        width: 100,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: color,
                size: 28,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // =============================================
  // FEATURED CARD
  // =============================================
  Widget _buildFeaturedCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary,
            AppColors.primaryDark,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                '⭐',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(width: 8),
              Text(
                "Today's Pick",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Explore Kathmandu Valley',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Discover the best routes in the valley',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              context.push('/city-bus');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text(
              'Find Routes →',
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =============================================
  // PLACE CARD
  // =============================================
  Widget _buildPlaceCard(
    BuildContext context, {
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
        width: 150,
        margin: const EdgeInsets.only(right: 14),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 90,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(14),
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.image_outlined,
                  size: 40,
                  color: Colors.grey.shade400,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
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