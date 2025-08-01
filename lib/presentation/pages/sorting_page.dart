import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:algorithm_visualizer/domain/models/sorting_models.dart';
import 'package:algorithm_visualizer/presentation/providers/sorting_provider.dart';
import 'package:algorithm_visualizer/presentation/widgets/array_visualizer.dart';
import 'package:algorithm_visualizer/presentation/widgets/control_panel.dart';

class SortingPage extends ConsumerWidget {
  const SortingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sortingState = ref.watch(sortingProvider);
    final sortingNotifier = ref.read(sortingProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sorting Algorithms'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showAlgorithmInfo(context, sortingState.algorithm),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isTablet = constraints.maxWidth > 600;
          final isLandscape = constraints.maxHeight < constraints.maxWidth;
          
          if (isTablet && !isLandscape) {
            return _buildTabletLayout(context, sortingState, sortingNotifier);
          } else {
            return _buildMobileLayout(context, sortingState, sortingNotifier);
          }
        },
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context, SortingState sortingState, SortingNotifier sortingNotifier) {
    return Column(
      children: [
        // Algorithm Selection
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select Algorithm:',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildAlgorithmChip(SortingAlgorithm.bubbleSort, 'Bubble', Icons.bubble_chart, sortingState, sortingNotifier),
                    _buildAlgorithmChip(SortingAlgorithm.selectionSort, 'Selection', Icons.select_all, sortingState, sortingNotifier),
                    _buildAlgorithmChip(SortingAlgorithm.insertionSort, 'Insertion', Icons.insert_chart, sortingState, sortingNotifier),
                    _buildAlgorithmChip(SortingAlgorithm.quickSort, 'Quick', Icons.speed, sortingState, sortingNotifier),
                    _buildAlgorithmChip(SortingAlgorithm.mergeSort, 'Merge', Icons.call_merge, sortingState, sortingNotifier),
                    _buildAlgorithmChip(SortingAlgorithm.heapSort, 'Heap', Icons.account_tree, sortingState, sortingNotifier),
                    _buildAlgorithmChip(SortingAlgorithm.shellSort, 'Shell', Icons.shell_script, sortingState, sortingNotifier),
                    _buildAlgorithmChip(SortingAlgorithm.countingSort, 'Counting', Icons.calculate, sortingState, sortingNotifier),
                    _buildAlgorithmChip(SortingAlgorithm.radixSort, 'Radix', Icons.radix, sortingState, sortingNotifier),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Current Step Display
        if (sortingState.currentStep.isNotEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              sortingState.currentStep,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        // Array Visualizer
        Expanded(
          flex: 3,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ArrayVisualizer(
              array: sortingState.array,
              comparing: sortingState.comparing,
              sorted: sortingState.sorted,
              pivot: sortingState.pivot,
              swapped: sortingState.swapped,
            ),
          ),
        ),
        // Control Panel
        Expanded(
          flex: 1,
          child: ControlPanel(
            isRunning: sortingState.isRunning,
            speed: sortingState.speed,
            arraySize: sortingState.array.length.toDouble(),
            onPlay: sortingNotifier.startSorting,
            onPause: sortingNotifier.pauseSorting,
            onReset: sortingNotifier.resetArray,
            onSpeedChanged: sortingNotifier.setSpeed,
            onArraySizeChanged: (size) => sortingNotifier.setArraySize(size.toInt()),
          ),
        ),
      ],
    );
  }

  Widget _buildTabletLayout(BuildContext context, SortingState sortingState, SortingNotifier sortingNotifier) {
    return Row(
      children: [
        // Left Panel - Algorithm Selection
        Expanded(
          flex: 1,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              border: Border(
                right: BorderSide(
                  color: Theme.of(context).dividerColor,
                  width: 1,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sorting Algorithms',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildAlgorithmCard(SortingAlgorithm.bubbleSort, 'Bubble Sort', 'O(n²)', Icons.bubble_chart, sortingState, sortingNotifier),
                        _buildAlgorithmCard(SortingAlgorithm.selectionSort, 'Selection Sort', 'O(n²)', Icons.select_all, sortingState, sortingNotifier),
                        _buildAlgorithmCard(SortingAlgorithm.insertionSort, 'Insertion Sort', 'O(n²)', Icons.insert_chart, sortingState, sortingNotifier),
                        _buildAlgorithmCard(SortingAlgorithm.quickSort, 'Quick Sort', 'O(n log n)', Icons.speed, sortingState, sortingNotifier),
                        _buildAlgorithmCard(SortingAlgorithm.mergeSort, 'Merge Sort', 'O(n log n)', Icons.call_merge, sortingState, sortingNotifier),
                        _buildAlgorithmCard(SortingAlgorithm.heapSort, 'Heap Sort', 'O(n log n)', Icons.account_tree, sortingState, sortingNotifier),
                        _buildAlgorithmCard(SortingAlgorithm.shellSort, 'Shell Sort', 'O(n log n)', Icons.shell_script, sortingState, sortingNotifier),
                        _buildAlgorithmCard(SortingAlgorithm.countingSort, 'Counting Sort', 'O(n+k)', Icons.calculate, sortingState, sortingNotifier),
                        _buildAlgorithmCard(SortingAlgorithm.radixSort, 'Radix Sort', 'O(nk)', Icons.radix, sortingState, sortingNotifier),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        // Right Panel - Visualization and Controls
        Expanded(
          flex: 2,
          child: Column(
            children: [
              // Current Step Display
              if (sortingState.currentStep.isNotEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    sortingState.currentStep,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              // Array Visualizer
              Expanded(
                flex: 3,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ArrayVisualizer(
                    array: sortingState.array,
                    comparing: sortingState.comparing,
                    sorted: sortingState.sorted,
                    pivot: sortingState.pivot,
                    swapped: sortingState.swapped,
                  ),
                ),
              ),
              // Control Panel
              Expanded(
                flex: 1,
                child: ControlPanel(
                  isRunning: sortingState.isRunning,
                  speed: sortingState.speed,
                  arraySize: sortingState.array.length.toDouble(),
                  onPlay: sortingNotifier.startSorting,
                  onPause: sortingNotifier.pauseSorting,
                  onReset: sortingNotifier.resetArray,
                  onSpeedChanged: sortingNotifier.setSpeed,
                  onArraySizeChanged: (size) => sortingNotifier.setArraySize(size.toInt()),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAlgorithmChip(SortingAlgorithm algorithm, String label, IconData icon, SortingState state, SortingNotifier notifier) {
    final isSelected = state.algorithm == algorithm;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        selected: isSelected,
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16),
            const SizedBox(width: 4),
            Text(label),
          ],
        ),
        onSelected: (selected) {
          if (selected) {
            notifier.setAlgorithm(algorithm);
          }
        },
        selectedColor: Theme.of(context).colorScheme.primaryContainer,
        checkmarkColor: Theme.of(context).colorScheme.onPrimaryContainer,
      ),
    );
  }

  Widget _buildAlgorithmCard(SortingAlgorithm algorithm, String title, String complexity, IconData icon, SortingState state, SortingNotifier notifier) {
    final isSelected = state.algorithm == algorithm;
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: isSelected ? Theme.of(context).colorScheme.primaryContainer : null,
      child: InkWell(
        onTap: () => notifier.setAlgorithm(algorithm),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Icon(
                icon,
                color: isSelected ? Theme.of(context).colorScheme.onPrimaryContainer : Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Theme.of(context).colorScheme.onPrimaryContainer : null,
                      ),
                    ),
                    Text(
                      'Complexity: $complexity',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isSelected ? Theme.of(context).colorScheme.onPrimaryContainer.withOpacity(0.8) : null,
                      ),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAlgorithmInfo(BuildContext context, SortingAlgorithm algorithm) {
    final info = _getAlgorithmInfo(algorithm);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(info['title']),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Time Complexity: ${info['timeComplexity']}'),
            const SizedBox(height: 8),
            Text('Space Complexity: ${info['spaceComplexity']}'),
            const SizedBox(height: 16),
            const Text('Description:'),
            const SizedBox(height: 4),
            Text(info['description']),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Map<String, String> _getAlgorithmInfo(SortingAlgorithm algorithm) {
    switch (algorithm) {
      case SortingAlgorithm.bubbleSort:
        return {
          'title': 'Bubble Sort',
          'timeComplexity': 'O(n²)',
          'spaceComplexity': 'O(1)',
          'description': 'A simple sorting algorithm that repeatedly steps through the list, compares adjacent elements and swaps them if they are in the wrong order.',
        };
      case SortingAlgorithm.selectionSort:
        return {
          'title': 'Selection Sort',
          'timeComplexity': 'O(n²)',
          'spaceComplexity': 'O(1)',
          'description': 'An in-place comparison sorting algorithm that divides the input list into two parts: a sorted sublist and an unsorted sublist.',
        };
      case SortingAlgorithm.insertionSort:
        return {
          'title': 'Insertion Sort',
          'timeComplexity': 'O(n²)',
          'spaceComplexity': 'O(1)',
          'description': 'A simple sorting algorithm that builds the final sorted array one item at a time.',
        };
      case SortingAlgorithm.quickSort:
        return {
          'title': 'Quick Sort',
          'timeComplexity': 'O(n log n)',
          'spaceComplexity': 'O(log n)',
          'description': 'A highly efficient, comparison-based sorting algorithm that uses a divide-and-conquer strategy.',
        };
      case SortingAlgorithm.mergeSort:
        return {
          'title': 'Merge Sort',
          'timeComplexity': 'O(n log n)',
          'spaceComplexity': 'O(n)',
          'description': 'A stable, divide-and-conquer sorting algorithm that produces a sorted array by merging two sorted subarrays.',
        };
      case SortingAlgorithm.heapSort:
        return {
          'title': 'Heap Sort',
          'timeComplexity': 'O(n log n)',
          'spaceComplexity': 'O(1)',
          'description': 'A comparison-based sorting algorithm that uses a binary heap data structure.',
        };
      case SortingAlgorithm.shellSort:
        return {
          'title': 'Shell Sort',
          'timeComplexity': 'O(n log n)',
          'spaceComplexity': 'O(1)',
          'description': 'An optimization of insertion sort that allows the exchange of items that are far apart.',
        };
      case SortingAlgorithm.countingSort:
        return {
          'title': 'Counting Sort',
          'timeComplexity': 'O(n+k)',
          'spaceComplexity': 'O(k)',
          'description': 'A non-comparison sorting algorithm that counts the number of objects having distinct key values.',
        };
      case SortingAlgorithm.radixSort:
        return {
          'title': 'Radix Sort',
          'timeComplexity': 'O(nk)',
          'spaceComplexity': 'O(n+k)',
          'description': 'A non-comparative integer sorting algorithm that sorts data with integer keys by grouping keys by the individual digits.',
        };
    }
  }
} 