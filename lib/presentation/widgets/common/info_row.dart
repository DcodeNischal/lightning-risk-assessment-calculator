/// Info Row Widget
///
/// A reusable widget for displaying parameter name-value pairs.
library;

import 'package:flutter/material.dart';

/// Data Display Row
///
/// Displays a parameter with its symbol and value in a formatted row.
class InfoRow extends StatelessWidget {
  final String label;
  final String symbol;
  final String value;
  final bool isHeader;
  final bool isDivider;
  final TextStyle? labelStyle;
  final TextStyle? valueStyle;

  const InfoRow({
    super.key,
    required this.label,
    this.symbol = '',
    required this.value,
    this.isHeader = false,
    this.isDivider = false,
    this.labelStyle,
    this.valueStyle,
  });

  @override
  Widget build(BuildContext context) {
    if (isDivider) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 8),
          const Divider(thickness: 1),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
          const SizedBox(height: 4),
        ],
      );
    }

    if (isHeader) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          label,
          style: labelStyle ??
              Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label
          Expanded(
            flex: 3,
            child: Text(
              label,
              style: labelStyle ??
                  Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[700],
                      ),
            ),
          ),
          // Symbol
          if (symbol.isNotEmpty) ...[
            SizedBox(
              width: 60,
              child: Text(
                symbol,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[600],
                    ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
          // Value
          Expanded(
            flex: 2,
            child: Text(
              value,
              style: valueStyle ??
                  Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[900],
                      ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}

/// Compact Info Row for Dense Layouts
class CompactInfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final FontWeight? valueFontWeight;

  const CompactInfoRow({
    super.key,
    required this.label,
    required this.value,
    this.valueColor,
    this.valueFontWeight,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: valueFontWeight ?? FontWeight.w500,
                  color: valueColor ?? Colors.grey[900],
                ),
          ),
        ],
      ),
    );
  }
}

/// Risk Metric Display Row
///
/// Specialized row for displaying risk values with comparison to threshold.
class RiskMetricRow extends StatelessWidget {
  final String label;
  final double value;
  final double threshold;
  final String? unit;

  const RiskMetricRow({
    super.key,
    required this.label,
    required this.value,
    required this.threshold,
    this.unit,
  });

  @override
  Widget build(BuildContext context) {
    final exceedsThreshold = value > threshold;
    final displayValue = value.toStringAsExponential(2);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: exceedsThreshold
            ? Colors.red.withOpacity(0.05)
            : Colors.green.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: exceedsThreshold
              ? Colors.red.withOpacity(0.2)
              : Colors.green.withOpacity(0.2),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  displayValue,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: exceedsThreshold
                            ? Colors.red[700]
                            : Colors.green[700],
                      ),
                ),
                if (unit != null)
                  Text(
                    unit!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
              ],
            ),
          ),
          Icon(
            exceedsThreshold ? Icons.warning : Icons.check_circle,
            color: exceedsThreshold ? Colors.red : Colors.green,
            size: 20,
          ),
        ],
      ),
    );
  }
}
