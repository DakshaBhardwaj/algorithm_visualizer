import 'package:flutter/material.dart';

class ArrayVisualizer extends StatelessWidget {
  final List<int> array;
  final List<int> comparing;
  final List<int> sorted;
  final int? pivot;
  final List<int> swapped;

  const ArrayVisualizer({
    super.key,
    required this.array,
    this.comparing = const [],
    this.sorted = const [],
    this.pivot,
    this.swapped = const [],
  });

  @override
  Widget build(BuildContext context) {
    if (array.isEmpty) {
      return const Center(
        child: Text(
          'Array is empty. Adjust size.',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    final int maxValue = array.reduce((a, b) => a > b ? a : b);
    const double barWidthFactor = 0.8; // Percentage of available space for the bar itself

    return LayoutBuilder(
      builder: (context, constraints) {
        final double availableWidth = constraints.maxWidth;
        const double barSpacing = 2.0; // Fixed spacing between bars
        final double totalSpacing = barSpacing * (array.length - 1);
        final double actualBarWidth = (availableWidth - totalSpacing) / array.length;

        return Column(
          children: [
            // Legend
            Container(
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Theme.of(context).colorScheme.outline),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildLegendItem(context, 'Comparing', Colors.orange),
                  _buildLegendItem(context, 'Sorted', Colors.green),
                  _buildLegendItem(context, 'Pivot', Colors.red),
                  _buildLegendItem(context, 'Swapped', Colors.purple),
                  _buildLegendItem(context, 'Default', Theme.of(context).colorScheme.primary),
                ],
              ),
            ),
            // Array Visualization
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: array.asMap().entries.map((entry) {
                  final int index = entry.key;
                  final int value = entry.value;

                  Color barColor = Theme.of(context).colorScheme.primary; // Default color
                  
                  // Priority order for coloring
                  if (swapped.contains(index)) {
                    barColor = Colors.purple; // Just swapped
                  } else if (pivot == index) {
                    barColor = Colors.red; // Pivot element
                  } else if (sorted.contains(index)) {
                    barColor = Colors.green; // Sorted elements
                  } else if (comparing.contains(index)) {
                    barColor = Colors.orange; // Elements being compared
                  }

                  final double normalizedHeight = (value / maxValue);
                  final double barHeight = normalizedHeight * constraints.maxHeight * 0.8; // 80% of max height

                  return Flexible(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: barSpacing / 2),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // Value label
                          Text(
                            value.toString(),
                            style: TextStyle(
                              fontSize: actualBarWidth < 20 ? 8 : 10,
                              color: barColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          // Bar
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 150), // Smooth transition
                            curve: Curves.easeInOut,
                            height: barHeight.clamp(5.0, constraints.maxHeight * 0.8), // Min height to be visible
                            width: actualBarWidth * barWidthFactor,
                            decoration: BoxDecoration(
                              color: barColor,
                              borderRadius: BorderRadius.circular(4),
                              boxShadow: [
                                BoxShadow(
                                  color: barColor.withOpacity(0.4),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                          ),
                          // Index label
                          Text(
                            index.toString(),
                            style: TextStyle(
                              fontSize: actualBarWidth < 20 ? 8 : 10,
                              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLegendItem(BuildContext context, String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
} 