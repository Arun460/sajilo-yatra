import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/primary_button.dart';

class ErrorEmptyScreen extends StatelessWidget {
  final String title;
  final String message;
  final String actionLabel;
  final VoidCallback? onAction;

  const ErrorEmptyScreen({
    super.key,
    this.title = 'Error',
    this.message = 'Something went wrong',
    this.actionLabel = 'Retry',
    this.onAction,
  });

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
                Icons.error_outline,
                size: 80,
                color: AppColors.error.withOpacity(0.5),
              ),
              const SizedBox(height: 24),
              Text(
                title,
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                message,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.onSurfaceLight,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              PrimaryButton(
                text: actionLabel,
                onPressed: onAction ?? () => context.pop(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}