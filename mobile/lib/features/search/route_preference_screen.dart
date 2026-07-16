import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../shared/widgets/elevated_card.dart';
import '../../core/theme/app_theme.dart';
// import '../../core/constants.dart';
import '../../models/search_data.dart';

class RoutePreferenceScreen extends StatefulWidget {
  final SearchData searchData;
  
  const RoutePreferenceScreen({
    super.key, 
    required this.searchData,
  });

  @override
  State<RoutePreferenceScreen> createState() => _RoutePreferenceScreenState();
}

class _RoutePreferenceScreenState extends State<RoutePreferenceScreen> {
  String _selectedPref = 'fastest';
  DateTime? _selectedTime;

  final List<Map<String, dynamic>> _preferences = [
    {
      'value': 'fastest',
      'label': 'Fastest Route',
      'icon': Icons.speed,
      'description': 'Get to your destination in the shortest time',
    },
    {
      'value': 'least_walking',
      'label': 'Least Walking',
      'icon': Icons.directions_walk,
      'description': 'Minimize walking distance between stops',
    },
    {
      'value': 'cheapest',
      'label': 'Cheapest',
      'icon': Icons.attach_money,
      'description': 'Find the most affordable option',
    },
    {
      'value': 'fewest_transfers',
      'label': 'Fewest Transfers',
      'icon': Icons.transfer_within_a_station,
      'description': 'Minimize the number of bus changes',
    },
  ];

  @override
  void initState() {
    super.initState();
    _selectedTime = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Route Preferences',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // =============================================
            // ROUTE SUMMARY
            // =============================================
            _buildRouteSummary(context),
            
            const SizedBox(height: AppSpacing.lg),
            
            // =============================================
            // PREFERENCE OPTIONS
            // =============================================
            Text(
              'Select Preference',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            ..._preferences.map((pref) => _buildPrefOption(context, pref)),
            
            const SizedBox(height: AppSpacing.lg),
            
            // =============================================
            // DEPARTURE TIME
            // =============================================
            _buildTimeSelector(context),
            
            const SizedBox(height: AppSpacing.xl),
            
            // =============================================
            // APPLY BUTTON
            // =============================================
            PrimaryButton(
              text: 'Find Routes',
              onPressed: _onApplyPreferences,
            ),
          ],
        ),
      ),
    );
  }

  // =============================================
  // ROUTE SUMMARY
  // =============================================
  Widget _buildRouteSummary(BuildContext context) {
    return ElevatedCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.route,
              color: AppColors.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${widget.searchData.source} → ${widget.searchData.destination}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Find the best route for your journey',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.onSurfaceLight,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =============================================
  // PREFERENCE OPTION
  // =============================================
  Widget _buildPrefOption(BuildContext context, Map<String, dynamic> pref) {
    final isSelected = _selectedPref == pref['value'];
    
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: GestureDetector(
        onTap: () => setState(() => _selectedPref = pref['value']),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: isSelected 
                ? AppColors.primary.withOpacity(0.08)
                : AppColors.surfaceContainer,
            borderRadius: BorderRadius.circular(AppRadius.card),
            border: Border.all(
              color: isSelected ? AppColors.primary : Colors.transparent,
              width: 2,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isSelected 
                      ? AppColors.primary 
                      : AppColors.outline.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  pref['icon'],
                  color: isSelected ? Colors.white : AppColors.outline,
                  size: 20,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pref['label'],
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                        color: isSelected ? AppColors.primary : AppColors.onSurface,
                      ),
                    ),
                    Text(
                      pref['description'],
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isSelected ? AppColors.primary : AppColors.onSurfaceLight,
                      ),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                const Icon(
                  Icons.check_circle,
                  color: AppColors.primary,
                  size: 24,
                ),
            ],
          ),
        ),
      ),
    );
  }

  // =============================================
  // TIME SELECTOR - ✅ FIXED
  // =============================================
  Widget _buildTimeSelector(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Departure Time',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        GestureDetector(  // ✅ Wrapped with GestureDetector
          onTap: _selectTime,  // ✅ Moved onTap here
          child: ElevatedCard(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                const Icon(
                  Icons.access_time,
                  color: AppColors.primary,
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    _selectedTime != null
                        ? '${_formatDate(_selectedTime!)} at ${_formatTime(_selectedTime!)}'
                        : 'Select departure time',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: AppColors.outline,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // =============================================
  // ACTIONS
  // =============================================
  void _selectTime() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedTime ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    
    if (picked != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedTime ?? DateTime.now()),
      );
      
      if (time != null) {
        setState(() {
          _selectedTime = DateTime(
            picked.year,
            picked.month,
            picked.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  void _onApplyPreferences() {
    final searchData = widget.searchData.copyWith(
      departureTime: _selectedTime,
    );
    
    // Navigate to results with preference
    context.push('/results', extra: {
      'searchData': searchData,
      'preference': _selectedPref,
    });
  }

  // =============================================
  // HELPERS
  // =============================================
  String _formatDate(DateTime date) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 
                    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  String _formatTime(DateTime time) {
    final hour = time.hour > 12 ? time.hour - 12 : time.hour;
    final minute = time.minute.toString().padLeft(2, '0');
    final ampm = time.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $ampm';
  }
}