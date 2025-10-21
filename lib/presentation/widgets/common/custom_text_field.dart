/// Custom Text Field Widgets
///
/// Reusable text field components for forms.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Custom Number Input Field
///
/// A text field specifically designed for number input with validation.
class NumberTextField extends StatelessWidget {
  final String label;
  final IconData? icon;
  final String formKey;
  final double? initialValue;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  final String? helperText;
  final String? suffixText;

  const NumberTextField({
    super.key,
    required this.label,
    this.icon,
    required this.formKey,
    this.initialValue,
    this.validator,
    this.onSaved,
    this.helperText,
    this.suffixText,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue?.toString() ?? '',
      decoration: InputDecoration(
        labelText: label,
        helperText: helperText,
        suffixText: suffixText,
        prefixIcon: icon != null ? Icon(icon) : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
      ],
      validator: validator,
      onSaved: onSaved,
    );
  }
}

/// Custom Dropdown Field
///
/// A dropdown field with consistent styling.
class CustomDropdownField extends StatelessWidget {
  final String label;
  final IconData? icon;
  final String formKey;
  final List<String> items;
  final String? initialValue;
  final String? Function(String?)? validator;
  final void Function(String?)? onChanged;
  final void Function(String?)? onSaved;
  final String? helperText;

  const CustomDropdownField({
    super.key,
    required this.label,
    this.icon,
    required this.formKey,
    required this.items,
    this.initialValue,
    this.validator,
    this.onChanged,
    this.onSaved,
    this.helperText,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: initialValue,
      decoration: InputDecoration(
        labelText: label,
        helperText: helperText,
        prefixIcon: icon != null ? Icon(icon) : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      items: items.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: const TextStyle(fontSize: 14),
            overflow: TextOverflow.ellipsis,
          ),
        );
      }).toList(),
      onChanged: onChanged,
      onSaved: onSaved,
      validator: validator,
      isExpanded: true,
      icon: const Icon(Icons.arrow_drop_down),
    );
  }
}

/// Responsive Row/Column for Form Fields
///
/// Automatically switches between row and column based on screen width.
class ResponsiveFieldLayout extends StatelessWidget {
  final List<Widget> children;
  final double breakpoint;
  final double spacing;

  const ResponsiveFieldLayout({
    super.key,
    required this.children,
    this.breakpoint = 600,
    this.spacing = 16,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < breakpoint) {
          // Mobile: Stack vertically
          return Column(
            children: _addSpacing(children, vertical: true),
          );
        } else {
          // Desktop: Side by side
          return Row(
            children: _addSpacing(
              children.map((child) => Expanded(child: child)).toList(),
              vertical: false,
            ),
          );
        }
      },
    );
  }

  List<Widget> _addSpacing(List<Widget> widgets, {required bool vertical}) {
    final result = <Widget>[];
    for (var i = 0; i < widgets.length; i++) {
      result.add(widgets[i]);
      if (i < widgets.length - 1) {
        result.add(
            vertical ? SizedBox(height: spacing) : SizedBox(width: spacing));
      }
    }
    return result;
  }
}
