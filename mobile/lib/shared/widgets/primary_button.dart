import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class PrimaryButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isOutlined;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
  });

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    if (widget.isOutlined) {
      return _buildOutlinedButton();
    }
    return _buildFilledButton();
  }

  Widget _buildFilledButton() {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        if (!widget.isLoading) widget.onPressed();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            // ✅ FIXED: Now uses AppColors.primary instead of electricTeal
            color: widget.isLoading 
                ? AppColors.primary.withOpacity(0.7) 
                : AppColors.primary,
            borderRadius: BorderRadius.circular(AppRadius.pill),
            boxShadow: [
              BoxShadow(
                // ✅ FIXED: Now uses AppColors.primary instead of electricTeal
                color: AppColors.primary.withOpacity(0.4),
                blurRadius: 15,
                spreadRadius: 2,
              ),
            ],
          ),
          child: widget.isLoading
              ? const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : Text(
                  widget.text,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildOutlinedButton() {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        if (!widget.isLoading) widget.onPressed();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(AppRadius.pill),
            border: Border.all(color: AppColors.primary, width: 2),
          ),
          child: widget.isLoading
              ? const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.primary,
                  ),
                )
              : Text(
                  widget.text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
        ),
      ),
    );
  }
}