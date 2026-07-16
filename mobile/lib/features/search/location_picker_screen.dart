import 'package:flutter/material.dart';
import '../../../shared/widgets/input_field.dart';
import '../../../shared/widgets/elevated_card.dart';
import '../../../core/theme/app_theme.dart';
// import '../../../core/constants.dart';
import '../../../models/stop.dart';
import '../services/stop_service.dart';
import '../../../core/location_service.dart';

class LocationPickerScreen extends StatefulWidget {
  final String? type;
  final Stop? sourceStop;

  const LocationPickerScreen({
    super.key,
    this.type,
    this.sourceStop,
  });

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  late final TextEditingController _searchController;
  String _searchQuery = '';
  bool _isLoading = false;
  bool _showAllResults = false;
  
  // ✅ Use real data from API
  List<Stop> _allStops = [];
  List<Stop> _filteredStops = [];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _loadStops();  // ✅ Load from API
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ✅ Load stops from API
  Future<void> _loadStops() async {
    setState(() => _isLoading = true);
    
    try {
      final stops = await StopService.getAllStops();
      setState(() {
        _allStops = stops;
        _filteredStops = stops;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      _showError('Failed to load stops: $e');
    }
  }

  // ✅ Search from API
  Future<void> _searchStops(String query) async {
    if (query.isEmpty) {
      setState(() {
        _filteredStops = _allStops;
        _showAllResults = false;
      });
      return;
    }

    setState(() => _isLoading = true);
    
    try {
      final results = await StopService.searchStops(query);
      setState(() {
        _filteredStops = results;
        _isLoading = false;
        _showAllResults = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      // Fallback to local filtering
      _localSearch(query);
    }
  }

  // ✅ Fallback: Local search
  void _localSearch(String query) {
    final q = query.toLowerCase().trim();
    setState(() {
      _filteredStops = _allStops.where((stop) {
        return stop.stopName.toLowerCase().contains(q) ||
            stop.areaName?.toLowerCase().contains(q) == true ||
            stop.district?.toLowerCase().contains(q) == true;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _getTitle(),
          style: Theme.of(context).textTheme.titleLarge,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          // ✅ Refresh button
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadStops,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          const SizedBox(height: AppSpacing.md),
          if (widget.type == 'source') _buildCurrentLocation(),
          Expanded(
            child: _isLoading && _allStops.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : _searchQuery.isEmpty
                    ? _buildRecentStops()
                    : _filteredStops.isEmpty
                        ? _buildEmptyState()
                        : _buildResultsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: InputField(
        hintText: 'Search stops...',
        prefixIcon: Icons.search,
        controller: _searchController,
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
          _searchStops(value);  // ✅ Search from API
        },
        suffixWidget: _searchQuery.isNotEmpty
            ? IconButton(
                onPressed: () {
                  setState(() {
                    _searchQuery = '';
                    _searchController.clear();
                    _filteredStops = _allStops;
                    _showAllResults = false;
                  });
                },
                icon: Icon(Icons.close, size: 18, color: AppColors.onSurfaceLight),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                splashRadius: 18,
              )
            : null,
      ),
    );
  }

  Widget _buildCurrentLocation() {
    final loc = LocationService().currentLocation.value;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: GestureDetector(
        onTap: () async {
          if (loc != null) {
            setState(() => _isLoading = true);
            
            // ✅ Get nearby stops from API
            final nearbyStops = await StopService.getNearbyStops(
              loc.latitude,
              loc.longitude,
            );
            
            setState(() => _isLoading = false);
            
            if (nearbyStops.isNotEmpty) {
              _showNearbyStops(nearbyStops);
            } else {
              final stop = Stop(
                id: 0,
                stopName: 'Current Location',
                latitude: loc.latitude,
                longitude: loc.longitude,
                areaName: 'Your Location',
              );
              Navigator.pop(context, stop);
            }
          } else {
            _showError('Unable to get current location');
          }
        },
        child: ElevatedCard(
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.my_location,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current Location',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      loc != null 
                          ? '${loc.latitude.toStringAsFixed(4)}, ${loc.longitude.toStringAsFixed(4)}'
                          : 'Enable location services',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: AppColors.outline),
            ],
          ),
        ),
      ),
    );
  }

  // ✅ Show nearby stops in a dialog
  void _showNearbyStops(List<Stop> stops) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        height: 400,
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nearby Stops',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.md),
            Expanded(
              child: ListView.builder(
                itemCount: stops.length,
                itemBuilder: (context, index) {
                  final stop = stops[index];
                  return ListTile(
                    leading: const Icon(Icons.directions_bus),
                    title: Text(stop.stopName),
                    subtitle: Text(stop.areaName ?? ''),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pop(context, stop);
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

  Widget _buildStopItem(Stop stop) {
    final isSelected = _isSelected(stop);
    
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: GestureDetector(
        onTap: () => _onStopSelected(stop),
        child: ElevatedCard(
          padding: EdgeInsets.zero,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.card),
              border: isSelected
                  ? Border.all(color: AppColors.primary, width: 2)
                  : null,
            ),
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isSelected ? Icons.check : Icons.location_on,
                  color: isSelected ? Colors.white : AppColors.primary,
                  size: 20,
                ),
              ),
              title: Text(
                stop.stopName,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected ? AppColors.primary : AppColors.onSurface,
                ),
              ),
              subtitle: Text(
                _getSubtitle(stop),
                style: Theme.of(context).textTheme.bodySmall,
              ),
              trailing: _buildDistrictChip(stop),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDistrictChip(Stop stop) {
    final district = stop.district ?? '';
    Color chipColor;
    switch (district.toLowerCase()) {
      case 'kathmandu':
        chipColor = Colors.blue.shade100;
        break;
      case 'lalitpur':
        chipColor = Colors.green.shade100;
        break;
      case 'bhaktapur':
        chipColor = Colors.orange.shade100;
        break;
      default:
        chipColor = Colors.grey.shade100;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: chipColor,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(
        district,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: chipColor.computeLuminance() > 0.5 ? AppColors.onSurface : Colors.white,
        ),
      ),
    );
  }

  Widget _buildResultsList() {
    final displayStops = _showAllResults ? _filteredStops : _filteredStops.take(6).toList();
    final hasMore = _filteredStops.length > 6;

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
          child: Text(
            '${_filteredStops.length} results found',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: AppColors.outline,
            ),
          ),
        ),
        ...displayStops.map((stop) => _buildStopItem(stop)),
        if (hasMore && !_showAllResults)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
            child: TextButton(
              onPressed: () {
                setState(() => _showAllResults = true);
              },
              child: Text('See all ${_filteredStops.length} results'),
            ),
          ),
      ],
    );
  }

  Widget _buildRecentStops() {
    final recentStops = _allStops.take(5).toList();
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent Stops',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: AppColors.outline,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          if (recentStops.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: Text('No recent stops'),
              ),
            )
          else
            ...recentStops.map((stop) => _buildStopItem(stop)),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: AppColors.outline.withOpacity(0.3),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'No stops found',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.onSurfaceLight,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Try a different search term',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.onSurfaceLight,
            ),
          ),
        ],
      ),
    );
  }

  String _getTitle() {
    if (widget.type == 'source') return 'Select Source';
    if (widget.type == 'destination') return 'Select Destination';
    return 'Select Stop';
  }

  String _getSubtitle(Stop stop) {
    final area = stop.areaName ?? '';
    final district = stop.district ?? '';
    if (area.isNotEmpty && district.isNotEmpty) {
      return '$area, $district';
    }
    return area.isNotEmpty ? area : district;
  }

  bool _isSelected(Stop stop) {
    return false;
  }

  void _onStopSelected(Stop stop) {
    if (widget.type == 'destination' && widget.sourceStop != null) {
      if (stop.id == widget.sourceStop!.id) {
        _showError('Source and destination cannot be the same');
        return;
      }
    }
    Navigator.pop(context, stop);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.medium),
        ),
      ),
    );
  }
}