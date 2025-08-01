enum GraphAlgorithm {
  breadthFirstSearch,
  depthFirstSearch,
  dijkstra,
  bellmanFord,
  kruskal,
  prim,
  topologicalSort,
  stronglyConnectedComponents,
}

enum GraphNodeState {
  unvisited,
  visited,
  current,
  path,
  start,
  end,
}

class GraphNode {
  final int id;
  final double x;
  final double y;
  final String label;
  GraphNodeState state;

  GraphNode({
    required this.id,
    required this.x,
    required this.y,
    required this.label,
    this.state = GraphNodeState.unvisited,
  });

  GraphNode copyWith({
    int? id,
    double? x,
    double? y,
    String? label,
    GraphNodeState? state,
  }) {
    return GraphNode(
      id: id ?? this.id,
      x: x ?? this.x,
      y: y ?? this.y,
      label: label ?? this.label,
      state: state ?? this.state,
    );
  }
}

class GraphEdge {
  final int from;
  final int to;
  final int weight;
  final bool isHighlighted;
  final bool isPath;

  GraphEdge({
    required this.from,
    required this.to,
    this.weight = 1,
    this.isHighlighted = false,
    this.isPath = false,
  });

  GraphEdge copyWith({
    int? from,
    int? to,
    int? weight,
    bool? isHighlighted,
    bool? isPath,
  }) {
    return GraphEdge(
      from: from ?? this.from,
      to: to ?? this.to,
      weight: weight ?? this.weight,
      isHighlighted: isHighlighted ?? this.isHighlighted,
      isPath: isPath ?? this.isPath,
    );
  }
}

class GraphState {
  final List<GraphNode> nodes;
  final List<GraphEdge> edges;
  final GraphAlgorithm algorithm;
  final bool isRunning;
  final double speed;
  final String currentStep;
  final int? startNode;
  final int? endNode;
  final List<int> visitedNodes;
  final List<int> pathNodes;

  GraphState({
    required this.nodes,
    required this.edges,
    this.algorithm = GraphAlgorithm.breadthFirstSearch,
    this.isRunning = false,
    this.speed = 200.0,
    this.currentStep = '',
    this.startNode,
    this.endNode,
    this.visitedNodes = const [],
    this.pathNodes = const [],
  });

  GraphState copyWith({
    List<GraphNode>? nodes,
    List<GraphEdge>? edges,
    GraphAlgorithm? algorithm,
    bool? isRunning,
    double? speed,
    String? currentStep,
    int? startNode,
    int? endNode,
    List<int>? visitedNodes,
    List<int>? pathNodes,
  }) {
    return GraphState(
      nodes: nodes ?? this.nodes,
      edges: edges ?? this.edges,
      algorithm: algorithm ?? this.algorithm,
      isRunning: isRunning ?? this.isRunning,
      speed: speed ?? this.speed,
      currentStep: currentStep ?? this.currentStep,
      startNode: startNode ?? this.startNode,
      endNode: endNode ?? this.endNode,
      visitedNodes: visitedNodes ?? this.visitedNodes,
      pathNodes: pathNodes ?? this.pathNodes,
    );
  }
} 