import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class InputField extends StatefulWidget {
  final String? hintText;
  final String? labelText;
  final String? value;
  final TextEditingController? controller;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final bool readOnly;
  final bool obscureText;
  final VoidCallback? onTap;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final TextInputType? keyboardType;
  final String? errorText;
  final String? helperText;
  final int? maxLines;
  final int? minLines;
  final bool expands;
  final Widget? suffixWidget;
  final bool showCursor;

  const InputField({
    super.key,
    this.hintText,
    this.labelText,
    this.value,
    this.controller,
    this.prefixIcon,
    this.suffixIcon,
    this.readOnly = false,
    this.obscureText = false,
    this.onTap,
    this.onChanged,
    this.onSubmitted,
    this.keyboardType,
    this.errorText,
    this.helperText,
    this.maxLines = 1,
    this.minLines,
    this.expands = false,
    this.suffixWidget,
    this.showCursor = true,
  });

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  bool _isFocused = false;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    if (widget.value != null && widget.controller == null) {
      _controller.text = widget.value!;
    }
  }

  @override
  void didUpdateWidget(InputField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != null && widget.value != oldWidget.value && widget.controller == null) {
      _controller.text = widget.value!;
    }
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.labelText != null) ...[
          Text(
            widget.labelText!,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: AppColors.onSurfaceMedium,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
        ],
        Focus(
          onFocusChange: (hasFocus) => setState(() => _isFocused = hasFocus),
          child: Container(
            decoration: BoxDecoration(
              color: widget.readOnly
                  ? AppColors.surfaceContainer
                  : AppColors.inputBackground,
              borderRadius: BorderRadius.circular(AppRadius.medium),
              border: Border.all(
                color: _getBorderColor(),
                width: _getBorderWidth(),
              ),
              boxShadow: _getBoxShadow(),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    readOnly: widget.readOnly,
                    onTap: widget.onTap,
                    onChanged: widget.onChanged,
                    onSubmitted: widget.onSubmitted,
                    obscureText: widget.obscureText,
                    keyboardType: widget.keyboardType,
                    maxLines: widget.maxLines,
                    minLines: widget.minLines,
                    expands: widget.expands,
                    showCursor: widget.showCursor,
                    style: TextStyle(
                      color: widget.readOnly 
                          ? AppColors.onSurfaceMedium 
                          : AppColors.onSurface,
                      fontSize: 16,
                    ),
                    decoration: InputDecoration(
                      hintText: widget.hintText,
                      hintStyle: TextStyle(
                        color: AppColors.onSurfaceLight,
                        fontSize: 16,
                      ),
                      prefixIcon: widget.prefixIcon != null
                          ? Icon(
                              widget.prefixIcon,
                              color: _getIconColor(),
                              size: 22,
                            )
                          : null,
                      suffixIcon: widget.suffixWidget != null
                          ? widget.suffixWidget
                          : widget.suffixIcon != null
                              ? Icon(
                                  widget.suffixIcon,
                                  color: _getIconColor(),
                                  size: 22,
                                )
                              : null,
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: widget.expands ? 16 : 14,
                      ),
                      errorText: widget.errorText,
                      errorStyle: TextStyle(
                        color: AppColors.error,
                        fontSize: 12,
                      ),
                      helperText: widget.helperText,
                      helperStyle: TextStyle(
                        color: AppColors.onSurfaceLight,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                // Clear button (if not read-only and has text)
                if (!widget.readOnly && _controller.text.isNotEmpty)
                  IconButton(
                    onPressed: () {
                      _controller.clear();
                      widget.onChanged?.call('');
                    },
                    icon: Icon(
                      Icons.close,
                      size: 18,
                      color: AppColors.onSurfaceLight,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    splashRadius: 18,
                  ),
                const SizedBox(width: 8),
              ],
            ),
          ),
        ),
        if (widget.errorText != null) ...[
          const SizedBox(height: 4),
          Text(
            widget.errorText!,
            style: TextStyle(
              color: AppColors.error,
              fontSize: 12,
            ),
          ),
        ],
      ],
    );
  }

  // =============================================
  // HELPER METHODS
  // =============================================
  Color _getBorderColor() {
    if (widget.errorText != null) return AppColors.error;
    if (_isFocused) return AppColors.primary;
    return AppColors.outline.withOpacity(0.3);
  }

  double _getBorderWidth() {
    if (widget.errorText != null) return 2;
    if (_isFocused) return 2;
    return 1;
  }

  List<BoxShadow>? _getBoxShadow() {
    if (_isFocused) {
      return [
        BoxShadow(
          color: AppColors.primary.withOpacity(0.15),
          blurRadius: 8,
          spreadRadius: 1,
          offset: const Offset(0, 2),
        ),
      ];
    }
    return null;
  }

  Color _getIconColor() {
    if (widget.errorText != null) return AppColors.error;
    if (_isFocused) return AppColors.primary;
    return AppColors.outline;
  }
}