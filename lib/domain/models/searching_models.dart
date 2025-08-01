enum SearchAlgorithm {
  linearSearch,
  binarySearch,
  jumpSearch,
  interpolationSearch,
  exponentialSearch,
  fibonacciSearch,
}

class SearchingState {
  final List<int> array;
  final int? target;
  final int? current; // Current index being examined
  final bool? found; // True if target found, false if not found, null if search in progress
  final List<int> eliminated; // Indices that have been eliminated from search space
  final List<int> visited; // Indices that have been visited
  final bool isRunning;
  final SearchAlgorithm algorithm;
  final double speed; // Speed for visualization
  final String currentStep; // Description of current search step

  SearchingState({
    required this.array,
    this.target,
    this.current,
    this.found,
    this.eliminated = const [],
    this.visited = const [],
    this.isRunning = false,
    this.algorithm = SearchAlgorithm.linearSearch,
    this.speed = 200.0, // Default speed
    this.currentStep = '',
  });

  SearchingState copyWith({
    List<int>? array,
    int? target,
    int? current,
    bool? found,
    List<int>? eliminated,
    List<int>? visited,
    bool? isRunning,
    SearchAlgorithm? algorithm,
    double? speed,
    String? currentStep,
  }) {
    return SearchingState(
      array: array ?? this.array,
      target: target, // Nullable field
      current: current, // Nullable field
      found: found, // Nullable field
      eliminated: eliminated ?? this.eliminated,
      visited: visited ?? this.visited,
      isRunning: isRunning ?? this.isRunning,
      algorithm: algorithm ?? this.algorithm,
      speed: speed ?? this.speed,
      currentStep: currentStep ?? this.currentStep,
    );
  }
} 