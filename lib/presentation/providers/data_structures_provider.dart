import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:algorithm_visualizer/domain/models/data_structures_models.dart';

final dataStructuresProvider = StateNotifierProvider<DataStructuresNotifier, DataStructureState>((ref) {
  return DataStructuresNotifier();
});

class DataStructuresNotifier extends StateNotifier<DataStructureState> {
  DataStructuresNotifier() : super(DataStructureState(
    type: DataStructureType.stack,
    elements: [],
  ));

  // Internal flag to control operations
  bool _isPaused = false;

  // Sets the current data structure type
  void setDataStructureType(DataStructureType type) {
    if (state.isRunning) return;
    state = state.copyWith(type: type, elements: [], highlighted: [], currentIndex: null);
  }

  // Sets the visualization speed
  void setSpeed(double speed) {
    state = state.copyWith(speed: speed);
  }

  // Resets the data structure
  void reset() {
    _isPaused = false;
    state = state.copyWith(
      elements: [],
      highlighted: [],
      currentIndex: null,
      currentOperation: OperationType.none,
      currentStep: '',
      metadata: {},
    );
  }

  // Helper to introduce delay for visualization
  Future<void> _delay() async {
    if (_isPaused) {
      while (_isPaused) {
        await Future.delayed(const Duration(milliseconds: 100));
      }
    }
    await Future.delayed(Duration(milliseconds: state.speed.toInt()));
  }

  // --- Stack Operations ---
  Future<void> push(int value) async {
    if (state.type != DataStructureType.stack) return;
    
    state = state.copyWith(isRunning: true, currentOperation: OperationType.push);
    state = state.copyWith(currentStep: 'Pushing $value onto stack');
    await _delay();

    List<int> newElements = List.from(state.elements);
    newElements.add(value);
    
    state = state.copyWith(
      elements: newElements,
      currentIndex: newElements.length - 1,
      highlighted: [newElements.length - 1],
    );
    await _delay();

    state = state.copyWith(
      isRunning: false,
      currentOperation: OperationType.none,
      currentStep: 'Pushed $value onto stack',
      highlighted: [],
      currentIndex: null,
    );
  }

  Future<void> pop() async {
    if (state.type != DataStructureType.stack || state.elements.isEmpty) return;
    
    state = state.copyWith(isRunning: true, currentOperation: OperationType.pop);
    state = state.copyWith(currentStep: 'Popping from stack');
    await _delay();

    List<int> newElements = List.from(state.elements);
    int poppedValue = newElements.removeLast();
    
    state = state.copyWith(
      elements: newElements,
      highlighted: [newElements.length],
      currentIndex: newElements.length,
    );
    await _delay();

    state = state.copyWith(
      isRunning: false,
      currentOperation: OperationType.none,
      currentStep: 'Popped $poppedValue from stack',
      highlighted: [],
      currentIndex: null,
    );
  }

  // --- Queue Operations ---
  Future<void> enqueue(int value) async {
    if (state.type != DataStructureType.queue) return;
    
    state = state.copyWith(isRunning: true, currentOperation: OperationType.enqueue);
    state = state.copyWith(currentStep: 'Enqueuing $value');
    await _delay();

    List<int> newElements = List.from(state.elements);
    newElements.add(value);
    
    state = state.copyWith(
      elements: newElements,
      currentIndex: newElements.length - 1,
      highlighted: [newElements.length - 1],
    );
    await _delay();

    state = state.copyWith(
      isRunning: false,
      currentOperation: OperationType.none,
      currentStep: 'Enqueued $value',
      highlighted: [],
      currentIndex: null,
    );
  }

  Future<void> dequeue() async {
    if (state.type != DataStructureType.queue || state.elements.isEmpty) return;
    
    state = state.copyWith(isRunning: true, currentOperation: OperationType.dequeue);
    state = state.copyWith(currentStep: 'Dequeuing from front');
    await _delay();

    List<int> newElements = List.from(state.elements);
    int dequeuedValue = newElements.removeAt(0);
    
    state = state.copyWith(
      elements: newElements,
      highlighted: [0],
      currentIndex: 0,
    );
    await _delay();

    state = state.copyWith(
      isRunning: false,
      currentOperation: OperationType.none,
      currentStep: 'Dequeued $dequeuedValue',
      highlighted: [],
      currentIndex: null,
    );
  }

  // --- Linked List Operations ---
  Future<void> insertAtBeginning(int value) async {
    if (state.type != DataStructureType.linkedList) return;
    
    state = state.copyWith(isRunning: true, currentOperation: OperationType.insert);
    state = state.copyWith(currentStep: 'Inserting $value at beginning');
    await _delay();

    List<int> newElements = [value, ...state.elements];
    
    state = state.copyWith(
      elements: newElements,
      currentIndex: 0,
      highlighted: [0],
    );
    await _delay();

    state = state.copyWith(
      isRunning: false,
      currentOperation: OperationType.none,
      currentStep: 'Inserted $value at beginning',
      highlighted: [],
      currentIndex: null,
    );
  }

  Future<void> insertAtEnd(int value) async {
    if (state.type != DataStructureType.linkedList) return;
    
    state = state.copyWith(isRunning: true, currentOperation: OperationType.insert);
    state = state.copyWith(currentStep: 'Inserting $value at end');
    await _delay();

    List<int> newElements = List.from(state.elements);
    newElements.add(value);
    
    state = state.copyWith(
      elements: newElements,
      currentIndex: newElements.length - 1,
      highlighted: [newElements.length - 1],
    );
    await _delay();

    state = state.copyWith(
      isRunning: false,
      currentOperation: OperationType.none,
      currentStep: 'Inserted $value at end',
      highlighted: [],
      currentIndex: null,
    );
  }

  Future<void> deleteFromBeginning() async {
    if (state.type != DataStructureType.linkedList || state.elements.isEmpty) return;
    
    state = state.copyWith(isRunning: true, currentOperation: OperationType.delete);
    state = state.copyWith(currentStep: 'Deleting from beginning');
    await _delay();

    List<int> newElements = List.from(state.elements);
    int deletedValue = newElements.removeAt(0);
    
    state = state.copyWith(
      elements: newElements,
      highlighted: [0],
      currentIndex: 0,
    );
    await _delay();

    state = state.copyWith(
      isRunning: false,
      currentOperation: OperationType.none,
      currentStep: 'Deleted $deletedValue from beginning',
      highlighted: [],
      currentIndex: null,
    );
  }

  Future<void> search(int value) async {
    if (state.type != DataStructureType.linkedList) return;
    
    state = state.copyWith(isRunning: true, currentOperation: OperationType.search);
    state = state.copyWith(currentStep: 'Searching for $value');
    await _delay();

    for (int i = 0; i < state.elements.length; i++) {
      if (_isPaused) return;
      
      state = state.copyWith(
        currentIndex: i,
        highlighted: [i],
        currentStep: 'Checking element at position $i',
      );
      await _delay();

      if (state.elements[i] == value) {
        state = state.copyWith(
          currentStep: 'Found $value at position $i!',
          highlighted: [i],
        );
        await _delay();
        break;
      }
    }

    state = state.copyWith(
      isRunning: false,
      currentOperation: OperationType.none,
      highlighted: [],
      currentIndex: null,
    );
  }

  // --- Binary Tree Operations ---
  Future<void> insertIntoTree(int value) async {
    if (state.type != DataStructureType.binaryTree) return;
    
    state = state.copyWith(isRunning: true, currentOperation: OperationType.insert);
    state = state.copyWith(currentStep: 'Inserting $value into tree');
    await _delay();

    List<int> newElements = List.from(state.elements);
    newElements.add(value);
    
    // Simple tree representation - in a real implementation, you'd have a proper tree structure
    state = state.copyWith(
      elements: newElements,
      currentIndex: newElements.length - 1,
      highlighted: [newElements.length - 1],
    );
    await _delay();

    state = state.copyWith(
      isRunning: false,
      currentOperation: OperationType.none,
      currentStep: 'Inserted $value into tree',
      highlighted: [],
      currentIndex: null,
    );
  }

  Future<void> traverseInOrder() async {
    if (state.type != DataStructureType.binaryTree) return;
    
    state = state.copyWith(isRunning: true, currentOperation: OperationType.traverse);
    state = state.copyWith(currentStep: 'In-order traversal');
    await _delay();

    List<int> sortedElements = List.from(state.elements)..sort();
    List<int> visited = [];

    for (int i = 0; i < sortedElements.length; i++) {
      if (_isPaused) return;
      
      visited.add(i);
      state = state.copyWith(
        currentIndex: i,
        highlighted: visited,
        currentStep: 'Visiting element ${sortedElements[i]}',
      );
      await _delay();
    }

    state = state.copyWith(
      isRunning: false,
      currentOperation: OperationType.none,
      currentStep: 'In-order traversal completed',
      highlighted: [],
      currentIndex: null,
    );
  }

  // --- Heap Operations ---
  Future<void> insertIntoHeap(int value) async {
    if (state.type != DataStructureType.heap) return;
    
    state = state.copyWith(isRunning: true, currentOperation: OperationType.insert);
    state = state.copyWith(currentStep: 'Inserting $value into heap');
    await _delay();

    List<int> newElements = List.from(state.elements);
    newElements.add(value);
    
    // Heapify up
    int currentIndex = newElements.length - 1;
    while (currentIndex > 0) {
      int parentIndex = (currentIndex - 1) ~/ 2;
      
      state = state.copyWith(
        elements: newElements,
        currentIndex: currentIndex,
        highlighted: [currentIndex, parentIndex],
        currentStep: 'Heapifying up: comparing with parent',
      );
      await _delay();

      if (newElements[currentIndex] > newElements[parentIndex]) {
        // Swap
        int temp = newElements[currentIndex];
        newElements[currentIndex] = newElements[parentIndex];
        newElements[parentIndex] = temp;
        
        state = state.copyWith(
          elements: newElements,
          highlighted: [currentIndex, parentIndex],
        );
        await _delay();
        
        currentIndex = parentIndex;
      } else {
        break;
      }
    }

    state = state.copyWith(
      isRunning: false,
      currentOperation: OperationType.none,
      currentStep: 'Inserted $value into heap',
      highlighted: [],
      currentIndex: null,
    );
  }

  Future<void> extractMax() async {
    if (state.type != DataStructureType.heap || state.elements.isEmpty) return;
    
    state = state.copyWith(isRunning: true, currentOperation: OperationType.delete);
    state = state.copyWith(currentStep: 'Extracting maximum from heap');
    await _delay();

    List<int> newElements = List.from(state.elements);
    int maxValue = newElements[0];
    
    // Replace root with last element
    newElements[0] = newElements.removeLast();
    
    state = state.copyWith(
      elements: newElements,
      currentIndex: 0,
      highlighted: [0],
    );
    await _delay();

    // Heapify down
    int currentIndex = 0;
    while (currentIndex < newElements.length) {
      int leftChild = 2 * currentIndex + 1;
      int rightChild = 2 * currentIndex + 2;
      int largest = currentIndex;

      if (leftChild < newElements.length && newElements[leftChild] > newElements[largest]) {
        largest = leftChild;
      }
      if (rightChild < newElements.length && newElements[rightChild] > newElements[largest]) {
        largest = rightChild;
      }

      if (largest != currentIndex) {
        state = state.copyWith(
          elements: newElements,
          currentIndex: currentIndex,
          highlighted: [currentIndex, largest],
          currentStep: 'Heapifying down: swapping with larger child',
        );
        await _delay();

        // Swap
        int temp = newElements[currentIndex];
        newElements[currentIndex] = newElements[largest];
        newElements[largest] = temp;
        
        state = state.copyWith(elements: newElements);
        await _delay();
        
        currentIndex = largest;
      } else {
        break;
      }
    }

    state = state.copyWith(
      isRunning: false,
      currentOperation: OperationType.none,
      currentStep: 'Extracted maximum: $maxValue',
      highlighted: [],
      currentIndex: null,
    );
  }

  // Pause operations
  void pause() {
    _isPaused = true;
    state = state.copyWith(isRunning: false);
  }

  void resume() {
    _isPaused = false;
    state = state.copyWith(isRunning: true);
  }
} 