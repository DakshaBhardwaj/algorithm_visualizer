import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GraphAlgorithmsPage extends ConsumerWidget {
  const GraphAlgorithmsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Graph Algorithms'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.hub,
              size: 64,
              color: Colors.purple[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Graph Algorithms',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.purple[700],
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Coming Soon!',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.symmetric(horizontal: 32),
              decoration: BoxDecoration(
                color: Colors.purple.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.purple.withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  Text(
                    'Planned Algorithms:',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.purple[700],
                        ),
                  ),
                  const SizedBox(height: 12),
                  _buildAlgorithmItem('Breadth-First Search (BFS)', 'O(V + E)'),
                  _buildAlgorithmItem('Depth-First Search (DFS)', 'O(V + E)'),
                  _buildAlgorithmItem('Dijkstra\'s Algorithm', 'O(V²)'),
                  _buildAlgorithmItem('Bellman-Ford Algorithm', 'O(VE)'),
                  _buildAlgorithmItem('Kruskal\'s Algorithm', 'O(E log E)'),
                  _buildAlgorithmItem('Prim\'s Algorithm', 'O(V²)'),
                  _buildAlgorithmItem('Topological Sort', 'O(V + E)'),
                  _buildAlgorithmItem('Strongly Connected Components', 'O(V + E)'),
                ],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Go Back'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                backgroundColor: Colors.purple,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlgorithmItem(String name, String complexity) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              name,
              style: const TextStyle(fontSize: 14),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.purple.withOpacity(0.2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              complexity,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.purple[700],
              ),
            ),
          ),
        ],
      ),
    );
  }
} 