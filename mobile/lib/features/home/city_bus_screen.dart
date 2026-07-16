import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mhj_maps/mhj_maps.dart';
import '../../core/theme/app_theme.dart';
import '../../models/stop.dart';

class CityBusScreen extends StatefulWidget {
  const CityBusScreen({super.key});

  @override
  State<CityBusScreen> createState() => _CityBusScreenState();
}

class _CityBusScreenState extends State<CityBusScreen> {
  Stop? _sourceStop;
  Stop? _destinationStop;
  bool _isAutoSearchTriggered = false;

  final TextEditingController _sourceController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();

  List<Map<String, String>> _sourceSuggestions = [];
  List<Map<String, String>> _destinationSuggestions = [];

  bool _showSourceSuggestions = false;
  bool _showDestinationSuggestions = false;

  void _updateSourceSuggestions(String query) {
    // TODO: Fetch from database when connected
    setState(() {
      _sourceSuggestions = [];
      _showSourceSuggestions = query.isNotEmpty;
    });
  }

  void _updateDestinationSuggestions(String query) {
    // TODO: Fetch from database when connected
    setState(() {
      _destinationSuggestions = [];
      _showDestinationSuggestions = query.isNotEmpty;
    });
  }

  @override
  void dispose() {
    _sourceController.dispose();
    _destinationController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    if (_isAutoSearchTriggered) return;
    
    final extra = GoRouterState.of(context).extra as Map<String, dynamic>?;
    if (extra != null && extra['autoSearch'] == true) {
      _isAutoSearchTriggered = true;
      
      final sourceName = extra['source'] as String?;
      final destinationName = extra['destination'] as String?;

      if (sourceName != null) {
        _sourceStop = Stop(
          id: 0,
          stopName: sourceName,
          latitude: 27.7172,
          longitude: 85.3240,
        );
        _sourceController.text = sourceName;
      }

      if (destinationName != null) {
        _destinationStop = Stop(
          id: 0,
          stopName: destinationName,
          latitude: 27.7100,
          longitude: 85.3480,
        );
        _destinationController.text = destinationName;
      }

      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          _showNoRouteDialog(context);
        }
      });
    }
  }

  void _showNoRouteDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              color: Colors.orange,
              size: 28,
            ),
            const SizedBox(width: 10),
            const Text(
              'No Route Available',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        content: Text(
          'No route found from ${_sourceStop?.stopName ?? 'N/A'} to ${_destinationStop?.stopName ?? 'N/A'}. Please try a different route.',
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              Navigator.of(context).pop();
            },
            child: const Text(
              'Got it',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // =============================================
          // HEADER WITH BACK BUTTON
          // =============================================
          Container(
            padding: const EdgeInsets.fromLTRB(16.0, 48.0, 16.0, 16.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primary,
                  AppColors.primaryDark,
                ],
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row with Back Button (No Notification Icon)
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => context.pop(),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                    ),
                    const Spacer(),
                    const Text(
                      'City Bus',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
                const SizedBox(height: 20),

                // Subtitle
                const Text(
                  'Find your perfect route 🚌',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 16),

                // =============================================
                // SOURCE INPUT WITH SUGGESTIONS
                // =============================================
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.location_on,
                              color: AppColors.primary,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: _sourceController,
                              decoration: const InputDecoration(
                                hintText: 'Search any place or bus stop',
                                border: InputBorder.none,
                                hintStyle: TextStyle(
                                  color: AppColors.onSurfaceLight,
                                  fontSize: 14,
                                ),
                              ),
                              onChanged: (value) {
                                _updateSourceSuggestions(value);
                              },
                              onTap: () {
                                setState(() {
                                  if (_sourceController.text.isNotEmpty) {
                                    _showSourceSuggestions = true;
                                  }
                                });
                              },
                            ),
                          ),
                          if (_sourceController.text.isNotEmpty)
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  _sourceController.clear();
                                  _sourceStop = null;
                                  _sourceSuggestions = [];
                                  _showSourceSuggestions = false;
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
                        ],
                      ),
                    ),
                    if (_showSourceSuggestions)
                      Container(
                        height: 120,
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
                        child: _sourceSuggestions.isEmpty
                            ? const Center(
                                child: Text(
                                  'No stops found',
                                  style: TextStyle(
                                    color: AppColors.onSurfaceLight,
                                    fontSize: 13,
                                  ),
                                ),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: _sourceSuggestions.length,
                                itemBuilder: (context, index) {
                                  final suggestion = _sourceSuggestions[index];
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
                                        'Bus Stop',
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    onTap: () {
                                      setState(() {
                                        _sourceController.text = suggestion['name']!;
                                        _sourceStop = Stop(
                                          id: 0,
                                          stopName: suggestion['name']!,
                                          latitude: 27.7172,
                                          longitude: 85.3240,
                                        );
                                        _sourceSuggestions = [];
                                        _showSourceSuggestions = false;
                                      });
                                    },
                                  );
                                },
                              ),
                      ),
                  ],
                ),
                const SizedBox(height: 10),

                // =============================================
                // DESTINATION INPUT WITH SUGGESTIONS
                // =============================================
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.secondary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.flag,
                              color: AppColors.secondary,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: _destinationController,
                              decoration: const InputDecoration(
                                hintText: 'Search destination',
                                border: InputBorder.none,
                                hintStyle: TextStyle(
                                  color: AppColors.onSurfaceLight,
                                  fontSize: 14,
                                ),
                              ),
                              onChanged: (value) {
                                _updateDestinationSuggestions(value);
                              },
                              onTap: () {
                                setState(() {
                                  if (_destinationController.text.isNotEmpty) {
                                    _showDestinationSuggestions = true;
                                  }
                                });
                              },
                            ),
                          ),
                          if (_destinationController.text.isNotEmpty)
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  _destinationController.clear();
                                  _destinationStop = null;
                                  _destinationSuggestions = [];
                                  _showDestinationSuggestions = false;
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
                        ],
                      ),
                    ),
                    if (_showDestinationSuggestions)
                      Container(
                        height: 120,
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
                        child: _destinationSuggestions.isEmpty
                            ? const Center(
                                child: Text(
                                  'No stops found',
                                  style: TextStyle(
                                    color: AppColors.onSurfaceLight,
                                    fontSize: 13,
                                  ),
                                ),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: _destinationSuggestions.length,
                                itemBuilder: (context, index) {
                                  final suggestion = _destinationSuggestions[index];
                                  return ListTile(
                                    leading: const Icon(
                                      Icons.location_on,
                                      color: AppColors.secondary,
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
                                        color: AppColors.secondary.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        'Bus Stop',
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: AppColors.secondary,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    onTap: () {
                                      setState(() {
                                        _destinationController.text = suggestion['name']!;
                                        _destinationStop = Stop(
                                          id: 0,
                                          stopName: suggestion['name']!,
                                          latitude: 27.7100,
                                          longitude: 85.3480,
                                        );
                                        _destinationSuggestions = [];
                                        _showDestinationSuggestions = false;
                                      });
                                    },
                                  );
                                },
                              ),
                      ),
                  ],
                ),
                const SizedBox(height: 16),

                // =============================================
                // BUTTONS ROW
                // =============================================
                Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: OutlinedButton(
                        onPressed: () => context.push('/operators'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: const BorderSide(color: Colors.white, width: 1.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          backgroundColor: Colors.white.withOpacity(0.15),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.directions_bus,
                              size: 18,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Operators (9)',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 4,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_sourceStop != null && _destinationStop != null) {
                            _showNoRouteDialog(context);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please select source and destination'),
                                backgroundColor: AppColors.error,
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          backgroundColor: Colors.white,
                          foregroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 4,
                        ),
                        child: const Text(
                          'Find Route',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),

          // =============================================
          // MAP
          // =============================================
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: MhjMapsMap(
                  center: const MhjMapsLatLng(lat: 27.7172, lng: 85.3240),
                  zoom: 13,
                  theme: MhjMapsMapThemes.cleanLight,
                  showZoomControls: true,
                  onMapCreated: (controller) {
                    // Optional: save controller for later use
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}