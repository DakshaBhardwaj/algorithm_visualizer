import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:algorithm_visualizer/presentation/pages/sorting_page.dart';
import 'package:algorithm_visualizer/presentation/pages/searching_page.dart';
import 'package:algorithm_visualizer/presentation/pages/data_structures_page.dart';
import 'package:algorithm_visualizer/presentation/pages/graph_algorithms_page.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Algorithm Visualizer'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showAppInfo(context),
          ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isTablet = constraints.maxWidth > 600;
            final isLandscape = constraints.maxHeight < constraints.maxWidth;
            
            if (isTablet && !isLandscape) {
              return _buildTabletLayout(context);
            } else {
              return _buildMobileLayout(context);
            }
          },
        ),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Choose Algorithm Category',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _CategoryCard(
                  title: 'Sorting Algorithms',
                  subtitle: '9 Algorithms',
                  icon: Icons.sort,
                  color: Colors.blue,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SortingPage(),
                    ),
                  ),
                ),
                _CategoryCard(
                  title: 'Search Algorithms',
                  subtitle: '6 Algorithms',
                  icon: Icons.search,
                  color: Colors.green,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SearchingPage(),
                    ),
                  ),
                ),
                _CategoryCard(
                  title: 'Data Structures',
                  subtitle: '7 Structures',
                  icon: Icons.account_tree,
                  color: Colors.orange,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DataStructuresPage(),
                    ),
                  ),
                ),
                _CategoryCard(
                  title: 'Graph Algorithms',
                  subtitle: '8 Algorithms',
                  icon: Icons.hub,
                  color: Colors.purple,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const GraphAlgorithmsPage(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabletLayout(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Algorithm Visualizer',
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Interactive visualization of algorithms and data structures',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 24,
              mainAxisSpacing: 24,
              childAspectRatio: 1.5,
              children: [
                _CategoryCard(
                  title: 'Sorting Algorithms',
                  subtitle: 'Bubble, Selection, Insertion, Quick, Merge, Heap, Shell, Counting, Radix',
                  icon: Icons.sort,
                  color: Colors.blue,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SortingPage(),
                    ),
                  ),
                ),
                _CategoryCard(
                  title: 'Search Algorithms',
                  subtitle: 'Linear, Binary, Jump, Interpolation, Exponential, Fibonacci',
                  icon: Icons.search,
                  color: Colors.green,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SearchingPage(),
                    ),
                  ),
                ),
                _CategoryCard(
                  title: 'Data Structures',
                  subtitle: 'Stack, Queue, Linked List, Binary Tree, BST, Heap, Hash Table',
                  icon: Icons.account_tree,
                  color: Colors.orange,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DataStructuresPage(),
                    ),
                  ),
                ),
                _CategoryCard(
                  title: 'Graph Algorithms',
                  subtitle: 'BFS, DFS, Dijkstra, Bellman-Ford, Kruskal, Prim, Topological Sort, SCC',
                  icon: Icons.hub,
                  color: Colors.purple,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const GraphAlgorithmsPage(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAppInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Algorithm Visualizer'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Version: 2.0.0'),
            SizedBox(height: 8),
            Text('A comprehensive algorithm visualization app with:'),
            SizedBox(height: 8),
            Text('• 9 Sorting Algorithms'),
            Text('• 6 Search Algorithms'),
            Text('• 7 Data Structures'),
            Text('• 8 Graph Algorithms'),
            SizedBox(height: 16),
            Text('Features:'),
            SizedBox(height: 8),
            Text('• Interactive visualizations'),
            Text('• Step-by-step animations'),
            Text('• Responsive design'),
            Text('• Material 3 design'),
            Text('• Real-time controls'),
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
}

class _CategoryCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withOpacity(0.1),
                color.withOpacity(0.2),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 48,
                  color: color,
                ),
                const SizedBox(height: 16),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: color.withOpacity(0.8),
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 