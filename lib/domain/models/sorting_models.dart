enum SortingAlgorithm {
  bubbleSort,
  selectionSort,
  insertionSort,
  quickSort,
  mergeSort,
  heapSort,
  shellSort,
  countingSort,
  radixSort,
}

class SortingState {
  final List<int> array;
  final List<int> comparing; // Indices of elements currently being compared
  final List<int> sorted;    // Indices of elements that are in their final sorted position
  final int? pivot;         // Index of the pivot element (if applicable, e.g., for Quick Sort)
  final List<int> swapped;  // Indices of elements that were just swapped
  final bool isRunning;
  final double speed;       // Delay between steps in milliseconds
  final SortingAlgorithm algorithm;
  final String currentStep; // Description of current algorithm step

  SortingState({
    required this.array,
    this.comparing = const [],
    this.sorted = const [],
    this.pivot,
    this.swapped = const [],
    this.isRunning = false,
    this.speed = 200.0, // Default speed
    this.algorithm = SortingAlgorithm.bubbleSort,
    this.currentStep = '',
  });

  SortingState copyWith({
    List<int>? array,
    List<int>? comparing,
    List<int>? sorted,
    int? pivot,
    List<int>? swapped,
    bool? isRunning,
    double? speed,
    SortingAlgorithm? algorithm,
    String? currentStep,
  }) {
    return SortingState(
      array: array ?? this.array,
      comparing: comparing ?? this.comparing,
      sorted: sorted ?? this.sorted,
      pivot: pivot,
      swapped: swapped ?? this.swapped,
      isRunning: isRunning ?? this.isRunning,
      speed: speed ?? this.speed,
      algorithm: algorithm ?? this.algorithm,
      currentStep: currentStep ?? this.currentStep,
    );
  }
} 