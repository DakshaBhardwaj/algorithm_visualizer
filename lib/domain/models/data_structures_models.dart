enum DataStructureType {
  stack,
  queue,
  linkedList,
  binaryTree,
  binarySearchTree,
  heap,
  hashTable,
}

enum OperationType {
  push,
  pop,
  enqueue,
  dequeue,
  insert,
  delete,
  search,
  traverse,
  none,
}

class DataStructureState {
  final DataStructureType type;
  final List<int> elements;
  final List<int> highlighted; // Highlighted elements
  final int? currentIndex; // Current element being processed
  final bool isRunning;
  final double speed;
  final OperationType currentOperation;
  final String currentStep;
  final Map<String, dynamic> metadata; // Additional data structure specific info

  DataStructureState({
    required this.type,
    required this.elements,
    this.highlighted = const [],
    this.currentIndex,
    this.isRunning = false,
    this.speed = 200.0,
    this.currentOperation = OperationType.none,
    this.currentStep = '',
    this.metadata = const {},
  });

  DataStructureState copyWith({
    DataStructureType? type,
    List<int>? elements,
    List<int>? highlighted,
    int? currentIndex,
    bool? isRunning,
    double? speed,
    OperationType? currentOperation,
    String? currentStep,
    Map<String, dynamic>? metadata,
  }) {
    return DataStructureState(
      type: type ?? this.type,
      elements: elements ?? this.elements,
      highlighted: highlighted ?? this.highlighted,
      currentIndex: currentIndex,
      isRunning: isRunning ?? this.isRunning,
      speed: speed ?? this.speed,
      currentOperation: currentOperation ?? this.currentOperation,
      currentStep: currentStep ?? this.currentStep,
      metadata: metadata ?? this.metadata,
    );
  }
} 