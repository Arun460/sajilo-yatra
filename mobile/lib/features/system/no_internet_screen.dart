import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/primary_button.dart';

class NoInternetScreen extends StatelessWidget {
  const NoInternetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.wifi_off,
                size: 80,
                color: AppColors.outline.withOpacity(0.5),
              ),
              const SizedBox(height: 24),
              Text(
                'No Internet Connection',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Please check your internet connection and try again.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.onSurfaceLight,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              PrimaryButton(
                text: 'Retry',
                onPressed: () => context.pop(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}