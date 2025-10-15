/// Gradient Button Widget
///
/// A reusable elevated button with gradient background.
library;

import 'package:flutter/material.dart';

/// Gradient Button
///
/// An elevated button with customizable gradient colors.
class GradientButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final List<Color> gradientColors;
  final EdgeInsets padding;
  final double borderRadius;
  final bool isLoading;
  final Widget? loadingWidget;

  const GradientButton({
    super.key,
    required this.onPressed,
    required this.child,
    required this.gradientColors,
    this.padding = const EdgeInsets.symmetric(vertical: 20, horizontal: 32),
    this.borderRadius = 16,
    this.isLoading = false,
    this.loadingWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: gradientColors),
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: gradientColors.first.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: padding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        child: isLoading
            ? (loadingWidget ??
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ))
            : child,
      ),
    );
  }
}

/// Icon Gradient Button
///
/// Gradient button with icon and text.
class IconGradientButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData icon;
  final String label;
  final List<Color> gradientColors;
  final bool isLoading;
  final String? loadingText;

  const IconGradientButton({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.label,
    required this.gradientColors,
    this.isLoading = false,
    this.loadingText,
  });

  @override
  Widget build(BuildContext context) {
    return GradientButton(
      onPressed: onPressed,
      gradientColors: gradientColors,
      isLoading: isLoading,
      loadingWidget: loadingText != null
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  loadingText!,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            )
          : null,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 24),
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
