import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:algorithm_visualizer/domain/models/sorting_models.dart';

final sortingProvider = StateNotifierProvider<SortingNotifier, SortingState>((ref) {
  return SortingNotifier();
});

class SortingNotifier extends StateNotifier<SortingState> {
  SortingNotifier() : super(SortingState(array: _generateRandomArray(20)));

  // Internal flag to control the sorting loop
  bool _isPaused = false;

  // Generates a random array of integers
  static List<int> _generateRandomArray(int size) {
    final random = Random();
    return List.generate(size, (_) => random.nextInt(100) + 1); // Values from 1 to 100
  }

  // Sets the current sorting algorithm
  void setAlgorithm(SortingAlgorithm algorithm) {
    if (state.isRunning) return; // Prevent changing algorithm while running
    state = state.copyWith(algorithm: algorithm);
    resetArray(); // Reset array when algorithm changes
  }

  // Sets the visualization speed
  void setSpeed(double speed) {
    state = state.copyWith(speed: speed);
  }

  // Sets the array size and regenerates the array
  void setArraySize(int size) {
    if (state.isRunning) return; // Prevent changing size while running
    state = state.copyWith(array: _generateRandomArray(size));
    resetArray(); // Reset array when size changes
  }

  // Resets the array to a new random one and clears visualization states
  void resetArray() {
    _isPaused = false;
    state = SortingState(array: _generateRandomArray(state.array.length), speed: state.speed, algorithm: state.algorithm);
  }

  // Starts the sorting process
  Future<void> startSorting() async {
    if (state.isRunning) return; // Already running
    _isPaused = false;
    state = state.copyWith(isRunning: true);

    List<int> currentArray = List.from(state.array); // Work on a copy

    switch (state.algorithm) {
      case SortingAlgorithm.bubbleSort:
        await _bubbleSort(currentArray);
        break;
      case SortingAlgorithm.selectionSort:
        await _selectionSort(currentArray);
        break;
      case SortingAlgorithm.insertionSort:
        await _insertionSort(currentArray);
        break;
      case SortingAlgorithm.quickSort:
        await _quickSort(currentArray);
        break;
      case SortingAlgorithm.mergeSort:
        await _mergeSort(currentArray);
        break;
      case SortingAlgorithm.heapSort:
        await _heapSort(currentArray);
        break;
      case SortingAlgorithm.shellSort:
        await _shellSort(currentArray);
        break;
      case SortingAlgorithm.countingSort:
        await _countingSort(currentArray);
        break;
      case SortingAlgorithm.radixSort:
        await _radixSort(currentArray);
        break;
    }

    if (!_isPaused) {
      // Mark all as sorted if not paused by user
      state = state.copyWith(
        isRunning: false,
        comparing: [],
        pivot: null,
        swapped: [],
        sorted: List.generate(currentArray.length, (index) => index),
        currentStep: 'Sorting completed!',
      );
    } else {
      state = state.copyWith(isRunning: false); // If paused, just stop running
    }
  }

  // Pauses the sorting process
  void pauseSorting() {
    _isPaused = true;
    state = state.copyWith(isRunning: false);
  }

  // Helper to introduce delay for visualization
  Future<void> _delay() async {
    if (_isPaused) {
      // Keep delaying until unpaused or reset
      while (_isPaused) {
        await Future.delayed(const Duration(milliseconds: 100));
      }
    }
    await Future.delayed(Duration(milliseconds: state.speed.toInt()));
  }

  // --- Sorting Algorithms Implementations ---

  Future<void> _bubbleSort(List<int> arr) async {
    int n = arr.length;
    state = state.copyWith(currentStep: 'Starting Bubble Sort...');
    
    for (int i = 0; i < n - 1; i++) {
      if (_isPaused) return;
      state = state.copyWith(currentStep: 'Pass ${i + 1}: Comparing adjacent elements');
      
      for (int j = 0; j < n - i - 1; j++) {
        if (_isPaused) return;

        state = state.copyWith(array: List.from(arr), comparing: [j, j + 1], swapped: []);
        await _delay();

        if (arr[j] > arr[j + 1]) {
          int temp = arr[j];
          arr[j] = arr[j + 1];
          arr[j + 1] = temp;
          state = state.copyWith(array: List.from(arr), comparing: [j, j + 1], swapped: [j, j + 1]);
          await _delay();
        }
      }
      // Mark the largest element as sorted
      state = state.copyWith(
        array: List.from(arr),
        comparing: [],
        swapped: [],
        sorted: List.from(state.sorted)..add(n - 1 - i),
      );
      await _delay();
    }
    // Mark the first element as sorted
    if (!_isPaused) {
      state = state.copyWith(
        sorted: List.from(state.sorted)..add(0),
      );
    }
  }

  Future<void> _selectionSort(List<int> arr) async {
    int n = arr.length;
    state = state.copyWith(currentStep: 'Starting Selection Sort...');
    
    for (int i = 0; i < n - 1; i++) {
      if (_isPaused) return;
      int minIdx = i;
      state = state.copyWith(currentStep: 'Pass ${i + 1}: Finding minimum element');

      // Highlight current element as potential minimum
      state = state.copyWith(array: List.from(arr), comparing: [i], pivot: i, swapped: []);
      await _delay();

      for (int j = i + 1; j < n; j++) {
        if (_isPaused) return;
        state = state.copyWith(array: List.from(arr), comparing: [minIdx, j], pivot: i, swapped: []);
        await _delay();

        if (arr[j] < arr[minIdx]) {
          minIdx = j;
          state = state.copyWith(array: List.from(arr), comparing: [minIdx, j], pivot: i, swapped: []);
          await _delay();
        }
      }

      // Swap the found minimum element with the first element
      if (minIdx != i) {
        int temp = arr[minIdx];
        arr[minIdx] = arr[i];
        arr[i] = temp;
        state = state.copyWith(array: List.from(arr), comparing: [], pivot: null, swapped: [i, minIdx]);
        await _delay();
      }
      // Mark current element as sorted
      state = state.copyWith(
        array: List.from(arr),
        comparing: [],
        pivot: null,
        swapped: [],
        sorted: List.from(state.sorted)..add(i),
      );
      await _delay();
    }
    // Mark the last element as sorted
    if (!_isPaused) {
      state = state.copyWith(
        sorted: List.from(state.sorted)..add(n - 1),
      );
    }
  }

  Future<void> _insertionSort(List<int> arr) async {
    int n = arr.length;
    state = state.copyWith(currentStep: 'Starting Insertion Sort...');
    
    for (int i = 1; i < n; i++) {
      if (_isPaused) return;
      int key = arr[i];
      int j = i - 1;
      state = state.copyWith(currentStep: 'Inserting element at position $i');

      // Highlight element to be inserted
      state = state.copyWith(array: List.from(arr), comparing: [i], pivot: i, swapped: []);
      await _delay();

      /* Move elements of arr[0..i-1], that are
         greater than key, to one position ahead
         of their current position */
      while (j >= 0 && arr[j] > key) {
        if (_isPaused) return;
        arr[j + 1] = arr[j];
        state = state.copyWith(array: List.from(arr), comparing: [j, j + 1], pivot: i, swapped: []);
        await _delay();
        j = j - 1;
      }
      arr[j + 1] = key;
      state = state.copyWith(array: List.from(arr), comparing: [], pivot: null, swapped: []);
      await _delay();
      // After each pass, elements up to i are considered sorted
      state = state.copyWith(
        array: List.from(arr),
        comparing: [],
        pivot: null,
        swapped: [],
        sorted: List.generate(i + 1, (index) => index),
      );
      await _delay();
    }
  }

  Future<void> _quickSort(List<int> arr) async {
    state = state.copyWith(currentStep: 'Starting Quick Sort...');
    await _quickSortHelper(arr, 0, arr.length - 1);
  }

  Future<void> _quickSortHelper(List<int> arr, int low, int high) async {
    if (low < high) {
      if (_isPaused) return;
      int pi = await _partition(arr, low, high);
      
      // Mark pivot as sorted
      state = state.copyWith(
        sorted: List.from(state.sorted)..add(pi),
      );
      await _delay();
      
      await _quickSortHelper(arr, low, pi - 1);
      await _quickSortHelper(arr, pi + 1, high);
    }
  }

  Future<int> _partition(List<int> arr, int low, int high) async {
    int pivot = arr[high];
    int i = low - 1;
    
    state = state.copyWith(currentStep: 'Partitioning around pivot ${arr[high]}');
    state = state.copyWith(array: List.from(arr), comparing: [], pivot: high, swapped: []);
    await _delay();

    for (int j = low; j < high; j++) {
      if (_isPaused) return -1;
      
      state = state.copyWith(array: List.from(arr), comparing: [j, high], pivot: high, swapped: []);
      await _delay();

      if (arr[j] < pivot) {
        i++;
        if (i != j) {
          int temp = arr[i];
          arr[i] = arr[j];
          arr[j] = temp;
          state = state.copyWith(array: List.from(arr), comparing: [i, j], pivot: high, swapped: [i, j]);
          await _delay();
        }
      }
    }
    
    int temp = arr[i + 1];
    arr[i + 1] = arr[high];
    arr[high] = temp;
    state = state.copyWith(array: List.from(arr), comparing: [i + 1, high], pivot: null, swapped: [i + 1, high]);
    await _delay();
    
    return i + 1;
  }

  Future<void> _mergeSort(List<int> arr) async {
    state = state.copyWith(currentStep: 'Starting Merge Sort...');
    await _mergeSortHelper(arr, 0, arr.length - 1);
  }

  Future<void> _mergeSortHelper(List<int> arr, int left, int right) async {
    if (left < right) {
      if (_isPaused) return;
      int mid = left + (right - left) ~/ 2;
      
      state = state.copyWith(currentStep: 'Dividing array from index $left to $right');
      state = state.copyWith(array: List.from(arr), comparing: [left, right], pivot: mid, swapped: []);
      await _delay();
      
      await _mergeSortHelper(arr, left, mid);
      await _mergeSortHelper(arr, mid + 1, right);
      await _merge(arr, left, mid, right);
    }
  }

  Future<void> _merge(List<int> arr, int left, int mid, int right) async {
    state = state.copyWith(currentStep: 'Merging sorted subarrays');
    
    List<int> leftArr = arr.sublist(left, mid + 1);
    List<int> rightArr = arr.sublist(mid + 1, right + 1);
    
    int i = 0, j = 0, k = left;
    
    while (i < leftArr.length && j < rightArr.length) {
      if (_isPaused) return;
      
      state = state.copyWith(array: List.from(arr), comparing: [left + i, mid + 1 + j], pivot: null, swapped: []);
      await _delay();
      
      if (leftArr[i] <= rightArr[j]) {
        arr[k] = leftArr[i];
        i++;
      } else {
        arr[k] = rightArr[j];
        j++;
      }
      k++;
      state = state.copyWith(array: List.from(arr), comparing: [], pivot: null, swapped: [k - 1]);
      await _delay();
    }
    
    while (i < leftArr.length) {
      if (_isPaused) return;
      arr[k] = leftArr[i];
      i++;
      k++;
      state = state.copyWith(array: List.from(arr), comparing: [], pivot: null, swapped: [k - 1]);
      await _delay();
    }
    
    while (j < rightArr.length) {
      if (_isPaused) return;
      arr[k] = rightArr[j];
      j++;
      k++;
      state = state.copyWith(array: List.from(arr), comparing: [], pivot: null, swapped: [k - 1]);
      await _delay();
    }
  }

  Future<void> _heapSort(List<int> arr) async {
    state = state.copyWith(currentStep: 'Starting Heap Sort...');
    int n = arr.length;
    
    // Build heap (rearrange array)
    for (int i = n ~/ 2 - 1; i >= 0; i--) {
      if (_isPaused) return;
      await _heapify(arr, n, i);
    }
    
    // One by one extract an element from heap
    for (int i = n - 1; i > 0; i--) {
      if (_isPaused) return;
      state = state.copyWith(currentStep: 'Extracting maximum element');
      
      // Move current root to end
      int temp = arr[0];
      arr[0] = arr[i];
      arr[i] = temp;
      state = state.copyWith(array: List.from(arr), comparing: [0, i], pivot: null, swapped: [0, i]);
      await _delay();
      
      // Mark as sorted
      state = state.copyWith(
        sorted: List.from(state.sorted)..add(i),
      );
      
      // Call max heapify on the reduced heap
      await _heapify(arr, i, 0);
    }
    
    // Mark first element as sorted
    if (!_isPaused) {
      state = state.copyWith(
        sorted: List.from(state.sorted)..add(0),
      );
    }
  }

  Future<void> _heapify(List<int> arr, int n, int i) async {
    int largest = i;
    int left = 2 * i + 1;
    int right = 2 * i + 2;
    
    state = state.copyWith(currentStep: 'Heapifying at index $i');
    
    // If left child is larger than root
    if (left < n && arr[left] > arr[largest]) {
      largest = left;
    }
    
    // If right child is larger than largest so far
    if (right < n && arr[right] > arr[largest]) {
      largest = right;
    }
    
    state = state.copyWith(array: List.from(arr), comparing: [i, largest], pivot: null, swapped: []);
    await _delay();
    
    // If largest is not root
    if (largest != i) {
      int temp = arr[i];
      arr[i] = arr[largest];
      arr[largest] = temp;
      state = state.copyWith(array: List.from(arr), comparing: [i, largest], pivot: null, swapped: [i, largest]);
      await _delay();
      
      // Recursively heapify the affected sub-tree
      await _heapify(arr, n, largest);
    }
  }

  Future<void> _shellSort(List<int> arr) async {
    state = state.copyWith(currentStep: 'Starting Shell Sort...');
    int n = arr.length;
    
    // Start with a big gap, then reduce the gap
    for (int gap = n ~/ 2; gap > 0; gap ~/= 2) {
      if (_isPaused) return;
      state = state.copyWith(currentStep: 'Gap: $gap - Comparing elements with gap');
      
      // Do a gapped insertion sort for this gap size
      for (int i = gap; i < n; i++) {
        if (_isPaused) return;
        
        int temp = arr[i];
        int j;
        
        state = state.copyWith(array: List.from(arr), comparing: [i], pivot: null, swapped: []);
        await _delay();
        
        for (j = i; j >= gap && arr[j - gap] > temp; j -= gap) {
          if (_isPaused) return;
          arr[j] = arr[j - gap];
          state = state.copyWith(array: List.from(arr), comparing: [j, j - gap], pivot: null, swapped: []);
          await _delay();
        }
        arr[j] = temp;
        state = state.copyWith(array: List.from(arr), comparing: [], pivot: null, swapped: [j]);
        await _delay();
      }
    }
  }

  Future<void> _countingSort(List<int> arr) async {
    state = state.copyWith(currentStep: 'Starting Counting Sort...');
    
    int max = arr.reduce((a, b) => a > b ? a : b);
    List<int> count = List.filled(max + 1, 0);
    List<int> output = List.filled(arr.length, 0);
    
    // Count occurrences
    for (int i = 0; i < arr.length; i++) {
      if (_isPaused) return;
      count[arr[i]]++;
      state = state.copyWith(array: List.from(arr), comparing: [i], pivot: null, swapped: [], currentStep: 'Counting occurrences');
      await _delay();
    }
    
    // Change count[i] so that count[i] now contains actual position
    for (int i = 1; i <= max; i++) {
      if (_isPaused) return;
      count[i] += count[i - 1];
    }
    
    // Build the output array
    for (int i = arr.length - 1; i >= 0; i--) {
      if (_isPaused) return;
      output[count[arr[i]] - 1] = arr[i];
      count[arr[i]]--;
      state = state.copyWith(array: List.from(output), comparing: [i], pivot: null, swapped: [], currentStep: 'Building output array');
      await _delay();
    }
    
    // Copy the output array to arr
    for (int i = 0; i < arr.length; i++) {
      if (_isPaused) return;
      arr[i] = output[i];
      state = state.copyWith(array: List.from(arr), comparing: [i], pivot: null, swapped: [], currentStep: 'Copying to original array');
      await _delay();
    }
  }

  Future<void> _radixSort(List<int> arr) async {
    state = state.copyWith(currentStep: 'Starting Radix Sort...');
    
    int max = arr.reduce((a, b) => a > b ? a : b);
    
    // Do counting sort for every digit
    for (int exp = 1; max ~/ exp > 0; exp *= 10) {
      if (_isPaused) return;
      state = state.copyWith(currentStep: 'Sorting by digit at position ${exp == 1 ? "ones" : exp == 10 ? "tens" : "hundreds"}');
      await _countingSortForRadix(arr, exp);
    }
  }

  Future<void> _countingSortForRadix(List<int> arr, int exp) async {
    int n = arr.length;
    List<int> output = List.filled(n, 0);
    List<int> count = List.filled(10, 0);
    
    // Store count of occurrences in count[]
    for (int i = 0; i < n; i++) {
      if (_isPaused) return;
      count[(arr[i] ~/ exp) % 10]++;
      state = state.copyWith(array: List.from(arr), comparing: [i], pivot: null, swapped: [], currentStep: 'Counting digit occurrences');
      await _delay();
    }
    
    // Change count[i] so that count[i] now contains actual position
    for (int i = 1; i < 10; i++) {
      if (_isPaused) return;
      count[i] += count[i - 1];
    }
    
    // Build the output array
    for (int i = n - 1; i >= 0; i--) {
      if (_isPaused) return;
      int digit = (arr[i] ~/ exp) % 10;
      output[count[digit] - 1] = arr[i];
      count[digit]--;
      state = state.copyWith(array: List.from(output), comparing: [i], pivot: null, swapped: [], currentStep: 'Building output array');
      await _delay();
    }
    
    // Copy the output array to arr
    for (int i = 0; i < n; i++) {
      if (_isPaused) return;
      arr[i] = output[i];
      state = state.copyWith(array: List.from(arr), comparing: [i], pivot: null, swapped: [], currentStep: 'Copying to original array');
      await _delay();
    }
  }
} 