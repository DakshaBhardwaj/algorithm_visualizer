import 'package:flutter/material.dart';
import 'package:algorithm_visualizer/domain/models/data_structures_models.dart';

class DataStructureVisualizer extends StatelessWidget {
  final List<int> elements;
  final List<int> highlighted;
  final int? currentIndex;

  const DataStructureVisualizer({
    super.key,
    required this.elements,
    this.highlighted = const [],
    this.currentIndex,
    required this.type,
  });

  final DataStructureType type;
  @override
  Widget build(BuildContext context) {
    if (elements.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _getStructureIcon(type),
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              '${_getStructureName(type)} is empty',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Add some elements to get started',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    switch (type) {
      case DataStructureType.stack:
        return _buildStackVisualization(context);
      case DataStructureType.queue:
        return _buildQueueVisualization(context);
      case DataStructureType.linkedList:
        return _buildLinkedListVisualization(context);
      case DataStructureType.binaryTree:
      case DataStructureType.binarySearchTree:
        return _buildTreeVisualization(context);
      case DataStructureType.heap:
        return _buildHeapVisualization(context);
      case DataStructureType.hashTable:
        return _buildHashTableVisualization(context);
    }
  }

  Widget _buildStackVisualization(BuildContext context) {
    return Column(
      children: [
        Text(
          'Stack (LIFO)',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: Container(
            width: 120,
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).colorScheme.outline),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                const SizedBox(height: 8),
                Text(
                  'TOP',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    reverse: true,
                    itemCount: elements.length,
                    itemBuilder: (context, index) {
                      final element = elements[index];
                      final isHighlighted = highlighted.contains(index);
                      final isCurrent = currentIndex == index;
                      
                      return _buildElementContainer(context, element, isCurrent, isHighlighted);
                        );,
                        child: Text(
                          element.toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isCurrent || isHighlighted
                                ? Colors.white
                                : Theme.of(context).colorScheme.onPrimaryContainer,
                          ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'BOTTOM',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQueueVisualization(BuildContext context) {
    return Column(
      children: [
        Text(
          'Queue (FIFO)',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).colorScheme.outline),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Text(
                        'FRONT',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Text(
                        'REAR',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: elements.length,
                    itemBuilder: (context, index) {
                      final element = elements[index];
                      final isHighlighted = highlighted.contains(index);
                      final isCurrent = currentIndex == index;
                      
                      return _buildElementContainer(context, element, isCurrent, isHighlighted);
                        ),
                        child: Text(
                          element.toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isCurrent || isHighlighted
                                ? Colors.white
                                : Theme.of(context).colorScheme.onPrimaryContainer,
                          ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLinkedListVisualization(BuildContext context) {
    return Column(
      children: [
        Text(
          'Linked List',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: elements.length,
            itemBuilder: (context, index) {
              final element = elements[index];
              final isHighlighted = highlighted.contains(index);
              final isCurrent = currentIndex == index;
              
              return Row(
                children: [
                  _buildElementContainer(context, element, isCurrent, isHighlighted),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: isCurrent
                            ? Colors.blue.shade700
                            : isHighlighted
                                ? Colors.orange.shade700
                                : Theme.of(context).colorScheme.outline,
                      ),
                    ),
                    child: Text(
                      element.toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isCurrent || isHighlighted
                            ? Colors.white
                            : Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                  if (index < elements.length - 1)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Icon(
                        Icons.arrow_forward,
                        color: Theme.of(context).colorScheme.outline,
                        size: 16,
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTreeVisualization(BuildContext context) {
    return Column(
      children: [
        Text(
          type == DataStructureType.binarySearchTree ? 'Binary Search Tree' : 'Binary Tree',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: Center(
            child: _buildTreeNodes(context, elements, 0),
          ),
        ),
      ],
    );
  }

  Widget _buildTreeNodes(BuildContext context, List<int> elements, int index) {
    if (index >= elements.length) return const SizedBox.shrink();
    
    final element = elements[index];
    final isHighlighted = highlighted.contains(index);
    final isCurrent = currentIndex == index;
    
    final leftChildIndex = 2 * index + 1;
    final rightChildIndex = 2 * index + 2;
    
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          decoration: BoxDecoration(
            color: isCurrent
                ? Colors.blue
                : isHighlighted
                    ? Colors.orange
                    : Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isCurrent
                  ? Colors.blue.shade700
                  : isHighlighted
                      ? Colors.orange.shade700
                      : Theme.of(context).colorScheme.outline,
            ),
          ),
          child: Text(
            element.toString(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isCurrent || isHighlighted
                  ? Colors.white
                  : Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
        ),
        if (leftChildIndex < elements.length || rightChildIndex < elements.length)
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (leftChildIndex < elements.length) ...[
                  _buildTreeNodes(context, elements, leftChildIndex),
                  const SizedBox(width: 32),
                ],
                if (rightChildIndex < elements.length)
                  _buildTreeNodes(context, elements, rightChildIndex),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildHeapVisualization(BuildContext context) {
    return Column(
      children: [
        Text(
          'Heap',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).colorScheme.outline),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                const SizedBox(height: 8),
                Text(
                  'MAX HEAP',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: elements.length,
                    itemBuilder: (context, index) {
                      final element = elements[index];
                      final isHighlighted = highlighted.contains(index);
                      final isCurrent = currentIndex == index;
                      
                      return _buildElementContainer(context, element, isCurrent, isHighlighted);
                        ),
                        child: Row(
                          children: [
                            Text(
                              '${index + 1}:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isCurrent || isHighlighted
                                    ? Colors.white
                                    : Theme.of(context).colorScheme.onPrimaryContainer,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              element.toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isCurrent || isHighlighted
                                    ? Colors.white
                                    : Theme.of(context).colorScheme.onPrimaryContainer,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHashTableVisualization(BuildContext context) {
    return Column(
      children: [
        Text(
          'Hash Table',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 1.5,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: elements.length,
            itemBuilder: (context, index) {
              final element = elements[index];
              final isHighlighted = highlighted.contains(index);
              final isCurrent = currentIndex == index;
              
              return  Container(
                decoration: _getElementDecoration(context, isCurrent, isHighlighted),
                  border: Border.all(
                    color: isCurrent
                        ? Colors.blue.shade700
                        : isHighlighted
                            ? Colors.orange.shade700
                            : Theme.of(context).colorScheme.outline,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$index',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isCurrent || isHighlighted
                            ? Colors.white
                            : Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                    Text(
                      element.toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isCurrent || isHighlighted
                            ? Colors.white
                            : Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  IconData _getStructureIcon(DataStructureType type) {
    switch (type) {
      case DataStructureType.stack:
        return Icons.view_stack;
      case DataStructureType.queue:
        return Icons.queue;
      case DataStructureType.linkedList:
        return Icons.link;
      case DataStructureType.binaryTree:
        return Icons.account_tree;
      case DataStructureType.binarySearchTree:
        return Icons.tree;
      case DataStructureType.heap:
        return Icons.heap;
      case DataStructureType.hashTable:
        return Icons.table_chart;
    }
  }

  String _getStructureName(DataStructureType type) {
    switch (type) {
      case DataStructureType.stack:
        return 'Stack';
      case DataStructureType.queue:
        return 'Queue';
      case DataStructureType.linkedList:
        return 'Linked List';
      case DataStructureType.binaryTree:
        return 'Binary Tree';
      case DataStructureType.binarySearchTree:
        return 'Binary Search Tree';
      case DataStructureType.heap:
        return 'Heap';
      case DataStructureType.hashTable:
        return 'Hash Table';
    }
  }

  Widget _buildElementContainer(BuildContext context, int element, bool isCurrent, bool isHighlighted) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: _getElementDecoration(context, isCurrent, isHighlighted, outlineColor: outlineColor),
      child: Text(
        element.toString(),
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: isCurrent || isHighlighted
              ? Colors.white
              : Theme.of(context).colorScheme.onPrimaryContainer,
        ),
      ),
    );
  }

   BoxDecoration _getElementDecoration(BuildContext context, bool isCurrent, bool isHighlighted) {
    return BoxDecoration(
      color: isCurrent ? Colors.blue : isHighlighted ? Colors.orange : Theme.of(context).colorScheme.primaryContainer,
      borderRadius: BorderRadius.circular(4),
      border: Border.all(color: isCurrent ? Colors.blue.shade700 : isHighlighted ? Colors.orange.shade700 : Theme.of(context).colorScheme.outline),
    );
  }
} 