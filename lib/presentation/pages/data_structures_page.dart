import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:algorithm_visualizer/domain/models/data_structures_models.dart';
import 'package:algorithm_visualizer/presentation/providers/data_structures_provider.dart';
import 'package:algorithm_visualizer/presentation/widgets/data_structure_visualizer.dart';

class DataStructuresPage extends ConsumerWidget {
  const DataStructuresPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataStructureState = ref.watch(dataStructuresProvider);
    final dataStructureNotifier = ref.read(dataStructuresProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Structures'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showDataStructureInfo(context, dataStructureState.type),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isTablet = constraints.maxWidth > 600;
          final isLandscape = constraints.maxHeight < constraints.maxWidth;
          
          if (isTablet && !isLandscape) {
            return _buildTabletLayout(context, dataStructureState, dataStructureNotifier);
          } else {
            return _buildMobileLayout(context, dataStructureState, dataStructureNotifier);
          }
        },
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context, DataStructureState state, DataStructuresNotifier notifier) {
    return Column(
      children: [
        // Data Structure Selection
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select Data Structure:',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildStructureChip(DataStructureType.stack, 'Stack', Icons.view_stack, state, notifier),
                    _buildStructureChip(DataStructureType.queue, 'Queue', Icons.queue, state, notifier),
                    _buildStructureChip(DataStructureType.linkedList, 'Linked List', Icons.link, state, notifier),
                    _buildStructureChip(DataStructureType.binaryTree, 'Binary Tree', Icons.account_tree, state, notifier),
                    _buildStructureChip(DataStructureType.binarySearchTree, 'BST', Icons.tree, state, notifier),
                    _buildStructureChip(DataStructureType.heap, 'Heap', Icons.heap, state, notifier),
                    _buildStructureChip(DataStructureType.hashTable, 'Hash Table', Icons.table_chart, state, notifier),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Current Step Display
        if (state.currentStep.isNotEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              state.currentStep,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        // Data Structure Visualizer
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
            child: DataStructureVisualizer(
              elements: state.elements,
              highlighted: state.highlighted,
              currentIndex: state.currentIndex,
              type: state.type,
            ),
          ),
        ),
        // Operations Panel
        Expanded(
          flex: 1,
          child: _buildOperationsPanel(context, state, notifier),
        ),
      ],
    );
  }

  Widget _buildTabletLayout(BuildContext context, DataStructureState state, DataStructuresNotifier notifier) {
    return Row(
      children: [
        // Left Panel - Data Structure Selection and Operations
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
                  'Data Structures',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                // Data Structure Selection
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildStructureCard(DataStructureType.stack, 'Stack', 'LIFO', Icons.view_stack, state, notifier),
                        _buildStructureCard(DataStructureType.queue, 'Queue', 'FIFO', Icons.queue, state, notifier),
                        _buildStructureCard(DataStructureType.linkedList, 'Linked List', 'Linear', Icons.link, state, notifier),
                        _buildStructureCard(DataStructureType.binaryTree, 'Binary Tree', 'Hierarchical', Icons.account_tree, state, notifier),
                        _buildStructureCard(DataStructureType.binarySearchTree, 'Binary Search Tree', 'Ordered', Icons.tree, state, notifier),
                        _buildStructureCard(DataStructureType.heap, 'Heap', 'Priority', Icons.heap, state, notifier),
                        _buildStructureCard(DataStructureType.hashTable, 'Hash Table', 'Key-Value', Icons.table_chart, state, notifier),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Operations Panel
                Expanded(
                  flex: 1,
                  child: _buildOperationsPanel(context, state, notifier),
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
              if (state.currentStep.isNotEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    state.currentStep,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              // Data Structure Visualizer
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
                  child: DataStructureVisualizer(
                    elements: state.elements,
                    highlighted: state.highlighted,
                    currentIndex: state.currentIndex,
                    type: state.type,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOperationsPanel(BuildContext context, DataStructureState state, DataStructuresNotifier notifier) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Operations',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildOperationButton(
                    context,
                    'Add Element',
                    Icons.add,
                    () => _showAddElementDialog(context, notifier, state.type),
                    state.isRunning,
                  ),
                  const SizedBox(height: 8),
                  _buildOperationButton(
                    context,
                    'Remove Element',
                    Icons.remove,
                    () => _removeElement(notifier, state.type),
                    state.isRunning || state.elements.isEmpty,
                  ),
                  const SizedBox(height: 8),
                  _buildOperationButton(
                    context,
                    'Search Element',
                    Icons.search,
                    () => _showSearchElementDialog(context, notifier, state.type),
                    state.isRunning,
                  ),
                  const SizedBox(height: 8),
                  _buildOperationButton(
                    context,
                    'Clear All',
                    Icons.clear_all,
                    () => notifier.reset(),
                    state.isRunning,
                  ),
                  const SizedBox(height: 8),
                  _buildOperationButton(
                    context,
                    'Traverse',
                    Icons.traverse,
                    () => _traverseStructure(notifier, state.type),
                    state.isRunning || state.elements.isEmpty,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStructureChip(DataStructureType type, String label, IconData icon, DataStructureState state, DataStructuresNotifier notifier) {
    final isSelected = state.type == type;
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
            notifier.setDataStructureType(type);
          }
        },
        selectedColor: Theme.of(context).colorScheme.primaryContainer,
        checkmarkColor: Theme.of(context).colorScheme.onPrimaryContainer,
      ),
    );
  }

  Widget _buildStructureCard(DataStructureType type, String title, String description, IconData icon, DataStructureState state, DataStructuresNotifier notifier) {
    final isSelected = state.type == type;
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: isSelected ? Theme.of(context).colorScheme.primaryContainer : null,
      child: InkWell(
        onTap: () => notifier.setDataStructureType(type),
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
                      description,
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

  Widget _buildOperationButton(BuildContext context, String label, IconData icon, VoidCallback onPressed, bool isDisabled) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: isDisabled ? null : onPressed,
        icon: Icon(icon),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  void _showAddElementDialog(BuildContext context, DataStructuresNotifier notifier, DataStructureType type) {
    final TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Element'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Enter value',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final value = int.tryParse(controller.text);
              if (value != null) {
                _addElement(notifier, type, value);
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _addElement(DataStructuresNotifier notifier, DataStructureType type, int value) {
    switch (type) {
      case DataStructureType.stack:
        notifier.push(value);
        break;
      case DataStructureType.queue:
        notifier.enqueue(value);
        break;
      case DataStructureType.linkedList:
        notifier.insertAtEnd(value);
        break;
      case DataStructureType.binaryTree:
        notifier.insertIntoTree(value);
        break;
      case DataStructureType.binarySearchTree:
        notifier.insertIntoTree(value);
        break;
      case DataStructureType.heap:
        notifier.insertIntoHeap(value);
        break;
      case DataStructureType.hashTable:
        // For hash table, we'll just add to the list for now
        notifier.insertAtEnd(value);
        break;
    }
  }

  void _removeElement(DataStructuresNotifier notifier, DataStructureType type) {
    switch (type) {
      case DataStructureType.stack:
        notifier.pop();
        break;
      case DataStructureType.queue:
        notifier.dequeue();
        break;
      case DataStructureType.linkedList:
        notifier.deleteFromBeginning();
        break;
      case DataStructureType.binaryTree:
        // For now, just remove the last element
        notifier.deleteFromBeginning();
        break;
      case DataStructureType.binarySearchTree:
        notifier.deleteFromBeginning();
        break;
      case DataStructureType.heap:
        notifier.extractMax();
        break;
      case DataStructureType.hashTable:
        notifier.deleteFromBeginning();
        break;
    }
  }

  void _showSearchElementDialog(BuildContext context, DataStructuresNotifier notifier, DataStructureType type) {
    final TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Search Element'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Enter value to search',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final value = int.tryParse(controller.text);
              if (value != null) {
                notifier.search(value);
                Navigator.pop(context);
              }
            },
            child: const Text('Search'),
          ),
        ],
      ),
    );
  }

  void _traverseStructure(DataStructuresNotifier notifier, DataStructureType type) {
    switch (type) {
      case DataStructureType.binaryTree:
      case DataStructureType.binarySearchTree:
        notifier.traverseInOrder();
        break;
      default:
        // For other structures, we'll just highlight elements sequentially
        notifier.search(notifier.state.elements.isNotEmpty ? notifier.state.elements.first : 0);
        break;
    }
  }

  void _showDataStructureInfo(BuildContext context, DataStructureType type) {
    final info = _getDataStructureInfo(type);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(info['title']),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Type: ${info['type']}'),
            const SizedBox(height: 8),
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

  Map<String, String> _getDataStructureInfo(DataStructureType type) {
    switch (type) {
      case DataStructureType.stack:
        return {
          'title': 'Stack',
          'type': 'LIFO (Last In, First Out)',
          'timeComplexity': 'O(1) for push/pop',
          'spaceComplexity': 'O(n)',
          'description': 'A linear data structure that follows the LIFO principle. Elements can only be added or removed from the top.',
        };
      case DataStructureType.queue:
        return {
          'title': 'Queue',
          'type': 'FIFO (First In, First Out)',
          'timeComplexity': 'O(1) for enqueue/dequeue',
          'spaceComplexity': 'O(n)',
          'description': 'A linear data structure that follows the FIFO principle. Elements are added at the rear and removed from the front.',
        };
      case DataStructureType.linkedList:
        return {
          'title': 'Linked List',
          'type': 'Linear',
          'timeComplexity': 'O(n) for search, O(1) for insert/delete at ends',
          'spaceComplexity': 'O(n)',
          'description': 'A linear data structure where elements are stored in nodes, and each node points to the next node.',
        };
      case DataStructureType.binaryTree:
        return {
          'title': 'Binary Tree',
          'type': 'Hierarchical',
          'timeComplexity': 'O(n) for traversal',
          'spaceComplexity': 'O(n)',
          'description': 'A tree data structure where each node has at most two children, referred to as left child and right child.',
        };
      case DataStructureType.binarySearchTree:
        return {
          'title': 'Binary Search Tree',
          'type': 'Ordered',
          'timeComplexity': 'O(log n) for search/insert/delete',
          'spaceComplexity': 'O(n)',
          'description': 'A binary tree where the left subtree contains nodes with values less than the parent, and right subtree contains greater values.',
        };
      case DataStructureType.heap:
        return {
          'title': 'Heap',
          'type': 'Priority Queue',
          'timeComplexity': 'O(log n) for insert/extract',
          'spaceComplexity': 'O(n)',
          'description': 'A specialized tree-based data structure that satisfies the heap property.',
        };
      case DataStructureType.hashTable:
        return {
          'title': 'Hash Table',
          'type': 'Key-Value',
          'timeComplexity': 'O(1) average case',
          'spaceComplexity': 'O(n)',
          'description': 'A data structure that implements an associative array abstract data type, mapping keys to values.',
        };
    }
  }
} 