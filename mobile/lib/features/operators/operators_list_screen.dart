import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/api_service.dart';
import '../../../shared/widgets/elevated_card.dart';

class OperatorsListScreen extends StatefulWidget {
  const OperatorsListScreen({super.key});

  @override
  State<OperatorsListScreen> createState() => _OperatorsListScreenState();
}

class _OperatorsListScreenState extends State<OperatorsListScreen> {
  List<dynamic> _operators = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadOperators();
  }

  Future<void> _loadOperators() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Replace line 32 with:
      final data = _getSampleOperators();
      setState(() {
        _operators = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bus Operators'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadOperators,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? _buildErrorState()
              : _buildOperatorsList(),
    );
  }

  Widget _buildOperatorsList() {
    // Sample data if API returns empty
    final displayOperators = _operators.isEmpty ? _getSampleOperators() : _operators;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Text(
            '${displayOperators.length} operators',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: AppColors.outline,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            itemCount: displayOperators.length,
            itemBuilder: (context, index) {
              final operator = displayOperators[index];
              final name = operator['name'] ?? operator['operator_name'] ?? 'Unknown Operator';
              final routes = operator['routes_count'] ?? operator['routes_available'] ?? 0;
              final nepaliName = operator['nepali_name'] ?? '';

              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: GestureDetector(
                  onTap: () {
                    // Navigate to operator detail or route list
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Showing routes for $name'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  child: ElevatedCard(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.directions_bus,
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
                                name,
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              if (nepaliName.isNotEmpty)
                                Text(
                                  nepaliName,
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppColors.onSurfaceLight,
                                  ),
                                ),
                              Text(
                                '$routes routes available',
                                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                  color: AppColors.outline,
                                ),
                              ),
                            ],
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
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: AppColors.error.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'Failed to load operators',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            _error ?? 'Unknown error',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.onSurfaceLight,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _loadOperators,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  // Sample data for testing
  List<Map<String, dynamic>> _getSampleOperators() {
    return [
      {
        'name': 'Bhaktapur Bus',
        'nepali_name': 'बहकतपुर बस',
        'routes_count': 3,
      },
      {
        'name': 'Gokarneshwor',
        'nepali_name': 'गोकर्नेश्वर',
        'routes_count': 1,
      },
      {
        'name': 'Local Transport',
        'nepali_name': 'लोक साधन',
        'routes_count': 1,
      },
      {
        'name': 'Mahanagar',
        'nepali_name': 'महानगर',
        'routes_count': 1,
      },
      {
        'name': 'Micro',
        'nepali_name': 'मीक्रो',
        'routes_count': 1,
      },
    ];
  }
}