import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:algorithm_visualizer/domain/models/searching_models.dart';
import 'package:algorithm_visualizer/presentation/providers/searching_provider.dart';
import 'package:algorithm_visualizer/presentation/widgets/search_visualizer.dart';
import 'package:algorithm_visualizer/presentation/widgets/control_panel.dart';

class SearchingPage extends ConsumerWidget {
  const SearchingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchState = ref.watch(searchingProvider);
    final searchingNotifier = ref.read(searchingProvider.notifier);
    final TextEditingController targetController = TextEditingController(
      text: searchState.target?.toString() ?? '',
    );

    // Update controller text if target changes from outside (e.g., reset)
    ref.listen<SearchingState>(searchingProvider, (previous, next) {
      if (previous?.target != next.target && next.target != null) {
        targetController.text = next.target.toString();
      } else if (next.target == null && targetController.text.isNotEmpty) {
        targetController.clear();
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Algorithms'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showAlgorithmInfo(context, searchState.algorithm),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isTablet = constraints.maxWidth > 600;
          final isLandscape = constraints.maxHeight < constraints.maxWidth;
          
          if (isTablet && !isLandscape) {
            return _buildTabletLayout(context, searchState, searchingNotifier, targetController);
          } else {
            return _buildMobileLayout(context, searchState, searchingNotifier, targetController);
          }
        },
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context, SearchingState searchState, SearchingNotifier searchingNotifier, TextEditingController targetController) {
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
                    _buildAlgorithmChip(SearchAlgorithm.linearSearch, 'Linear', Icons.linear_scale, searchState, searchingNotifier),
                    _buildAlgorithmChip(SearchAlgorithm.binarySearch, 'Binary', Icons.call_split, searchState, searchingNotifier),
                    _buildAlgorithmChip(SearchAlgorithm.jumpSearch, 'Jump', Icons.jump_to, searchState, searchingNotifier),
                    _buildAlgorithmChip(SearchAlgorithm.interpolationSearch, 'Interpolation', Icons.interpolation, searchState, searchingNotifier),
                    _buildAlgorithmChip(SearchAlgorithm.exponentialSearch, 'Exponential', Icons.exponential, searchState, searchingNotifier),
                    _buildAlgorithmChip(SearchAlgorithm.fibonacciSearch, 'Fibonacci', Icons.fibonacci, searchState, searchingNotifier),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Target Input
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Text(
                'Search for:',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextField(
                  controller: targetController,
                  decoration: InputDecoration(
                    hintText: 'Enter number to search',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  keyboardType: TextInputType.number,
                  onSubmitted: (value) {
                    final target = int.tryParse(value);
                    if (target != null) {
                      searchingNotifier.setTarget(target);
                    } else {
                      targetController.clear();
                      searchingNotifier.setTarget(null);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Current Step Display
        if (searchState.currentStep.isNotEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              searchState.currentStep,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        // Search Visualizer
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
            child: SearchVisualizer(
              array: searchState.array,
              target: searchState.target,
              current: searchState.current,
              found: searchState.found,
              eliminated: searchState.eliminated,
              visited: searchState.visited,
            ),
          ),
        ),
        // Control Buttons & Result Display
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: searchState.isRunning || searchState.target == null
                          ? null
                          : () => searchingNotifier.startSearch(),
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Start Search'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        searchingNotifier.resetSearch();
                        targetController.clear();
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Reset'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (searchState.found != null)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: searchState.found!
                          ? Colors.green.withOpacity(0.2)
                          : Colors.red.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      searchState.found!
                          ? 'Found at index ${searchState.current}'
                          : 'Target not found',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: searchState.found! ? Colors.green : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTabletLayout(BuildContext context, SearchingState searchState, SearchingNotifier searchingNotifier, TextEditingController targetController) {
    return Row(
      children: [
        // Left Panel - Algorithm Selection and Controls
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
                  'Search Algorithms',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                // Algorithm Selection
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildAlgorithmCard(SearchAlgorithm.linearSearch, 'Linear Search', 'O(n)', Icons.linear_scale, searchState, searchingNotifier),
                        _buildAlgorithmCard(SearchAlgorithm.binarySearch, 'Binary Search', 'O(log n)', Icons.call_split, searchState, searchingNotifier),
                        _buildAlgorithmCard(SearchAlgorithm.jumpSearch, 'Jump Search', 'O(√n)', Icons.jump_to, searchState, searchingNotifier),
                        _buildAlgorithmCard(SearchAlgorithm.interpolationSearch, 'Interpolation Search', 'O(log log n)', Icons.interpolation, searchState, searchingNotifier),
                        _buildAlgorithmCard(SearchAlgorithm.exponentialSearch, 'Exponential Search', 'O(log n)', Icons.exponential, searchState, searchingNotifier),
                        _buildAlgorithmCard(SearchAlgorithm.fibonacciSearch, 'Fibonacci Search', 'O(log n)', Icons.fibonacci, searchState, searchingNotifier),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Target Input
                Text(
                  'Search Target:',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: targetController,
                  decoration: InputDecoration(
                    hintText: 'Enter number to search',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  keyboardType: TextInputType.number,
                  onSubmitted: (value) {
                    final target = int.tryParse(value);
                    if (target != null) {
                      searchingNotifier.setTarget(target);
                    } else {
                      targetController.clear();
                      searchingNotifier.setTarget(null);
                    }
                  },
                ),
                const SizedBox(height: 16),
                // Control Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: searchState.isRunning || searchState.target == null
                            ? null
                            : () => searchingNotifier.startSearch(),
                        icon: const Icon(Icons.play_arrow),
                        label: const Text('Start'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          searchingNotifier.resetSearch();
                          targetController.clear();
                        },
                        icon: const Icon(Icons.refresh),
                        label: const Text('Reset'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ),
                  ],
                ),
                // Result Display
                if (searchState.found != null)
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(top: 16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: searchState.found!
                          ? Colors.green.withOpacity(0.2)
                          : Colors.red.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      searchState.found!
                          ? 'Found at index ${searchState.current}'
                          : 'Target not found',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: searchState.found! ? Colors.green : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ),
              ],
            ),
          ),
        ),
        // Right Panel - Visualization
        Expanded(
          flex: 2,
          child: Column(
            children: [
              // Current Step Display
              if (searchState.currentStep.isNotEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    searchState.currentStep,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              // Search Visualizer
              Expanded(
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
                  child: SearchVisualizer(
                    array: searchState.array,
                    target: searchState.target,
                    current: searchState.current,
                    found: searchState.found,
                    eliminated: searchState.eliminated,
                    visited: searchState.visited,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAlgorithmChip(SearchAlgorithm algorithm, String label, IconData icon, SearchingState state, SearchingNotifier notifier) {
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

  Widget _buildAlgorithmCard(SearchAlgorithm algorithm, String title, String complexity, IconData icon, SearchingState state, SearchingNotifier notifier) {
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

  void _showAlgorithmInfo(BuildContext context, SearchAlgorithm algorithm) {
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

  Map<String, String> _getAlgorithmInfo(SearchAlgorithm algorithm) {
    switch (algorithm) {
      case SearchAlgorithm.linearSearch:
        return {
          'title': 'Linear Search',
          'timeComplexity': 'O(n)',
          'spaceComplexity': 'O(1)',
          'description': 'A simple search algorithm that checks each element in the array sequentially until the target is found.',
        };
      case SearchAlgorithm.binarySearch:
        return {
          'title': 'Binary Search',
          'timeComplexity': 'O(log n)',
          'spaceComplexity': 'O(1)',
          'description': 'An efficient search algorithm that works on sorted arrays by repeatedly dividing the search interval in half.',
        };
      case SearchAlgorithm.jumpSearch:
        return {
          'title': 'Jump Search',
          'timeComplexity': 'O(√n)',
          'spaceComplexity': 'O(1)',
          'description': 'A search algorithm for sorted arrays that jumps ahead by fixed steps and then performs linear search.',
        };
      case SearchAlgorithm.interpolationSearch:
        return {
          'title': 'Interpolation Search',
          'timeComplexity': 'O(log log n)',
          'spaceComplexity': 'O(1)',
          'description': 'An improvement over binary search for uniformly distributed sorted arrays.',
        };
      case SearchAlgorithm.exponentialSearch:
        return {
          'title': 'Exponential Search',
          'timeComplexity': 'O(log n)',
          'spaceComplexity': 'O(1)',
          'description': 'A search algorithm that finds the range where element is present, then does binary search.',
        };
      case SearchAlgorithm.fibonacciSearch:
        return {
          'title': 'Fibonacci Search',
          'timeComplexity': 'O(log n)',
          'spaceComplexity': 'O(1)',
          'description': 'A search algorithm that uses Fibonacci numbers to divide the array into unequal parts.',
        };
    }
  }
} 