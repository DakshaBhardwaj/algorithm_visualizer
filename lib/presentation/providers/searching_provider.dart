import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:algorithm_visualizer/domain/models/searching_models.dart';

final searchingProvider = StateNotifierProvider<SearchingNotifier, SearchingState>((ref) {
  return SearchingNotifier();
});

class SearchingNotifier extends StateNotifier<SearchingState> {
  SearchingNotifier() : super(SearchingState(array: _generateSortedArray(20)));

  // Generates a sorted array of integers
  static List<int> _generateSortedArray(int size) {
    final random = Random();
    List<int> arr = List.generate(size, (_) => random.nextInt(100) + 1);
    arr.sort(); // Ensure array is sorted for binary search
    return arr;
  }

  // Sets the current searching algorithm
  void setAlgorithm(SearchAlgorithm algorithm) {
    if (state.isRunning) return;
    state = state.copyWith(algorithm: algorithm);
    resetSearch(); // Reset array and state when algorithm changes
  }

  // Sets the target value to search for
  void setTarget(int? target) {
    if (state.isRunning) return;
    state = state.copyWith(target: target, found: null, current: null, eliminated: [], visited: []);
  }

  // Starts the searching process
  Future<void> startSearch() async {
    if (state.isRunning || state.target == null) return;

    state = state.copyWith(isRunning: true, found: null, current: null, eliminated: [], visited: []);

    List<int> currentArray = List.from(state.array);

    switch (state.algorithm) {
      case SearchAlgorithm.linearSearch:
        await _linearSearch(currentArray, state.target!);
        break;
      case SearchAlgorithm.binarySearch:
        await _binarySearch(currentArray, state.target!);
        break;
      case SearchAlgorithm.jumpSearch:
        await _jumpSearch(currentArray, state.target!);
        break;
      case SearchAlgorithm.interpolationSearch:
        await _interpolationSearch(currentArray, state.target!);
        break;
      case SearchAlgorithm.exponentialSearch:
        await _exponentialSearch(currentArray, state.target!);
        break;
      case SearchAlgorithm.fibonacciSearch:
        await _fibonacciSearch(currentArray, state.target!);
        break;
    }

    state = state.copyWith(isRunning: false);
  }

  // Resets the search state and generates a new sorted array
  void resetSearch() {
    state = SearchingState(
      array: _generateSortedArray(state.array.length),
      algorithm: state.algorithm,
      speed: state.speed,
      target: null, // Clear target on reset
    );
  }

  // Helper to introduce delay for visualization
  Future<void> _delay() async {
    await Future.delayed(Duration(milliseconds: state.speed.toInt()));
  }

  // --- Searching Algorithms Implementations ---

  Future<void> _linearSearch(List<int> arr, int target) async {
    state = state.copyWith(currentStep: 'Starting Linear Search...');
    
    for (int i = 0; i < arr.length; i++) {
      state = state.copyWith(current: i, eliminated: [], visited: List.from(state.visited)..add(i));
      state = state.copyWith(currentStep: 'Checking element at index $i');
      await _delay();

      if (arr[i] == target) {
        state = state.copyWith(found: true, current: i, currentStep: 'Target found at index $i!');
        return;
      } else {
        state = state.copyWith(eliminated: List.from(state.eliminated)..add(i));
      }
    }
    state = state.copyWith(found: false, current: null, currentStep: 'Target not found');
  }

  Future<void> _binarySearch(List<int> arr, int target) async {
    state = state.copyWith(currentStep: 'Starting Binary Search...');
    
    int low = 0;
    int high = arr.length - 1;
    List<int> currentEliminated = [];

    while (low <= high) {
      int mid = low + ((high - low) ~/ 2);

      state = state.copyWith(
        current: mid,
        eliminated: currentEliminated,
        visited: List.from(state.visited)..add(mid),
        currentStep: 'Checking middle element at index $mid',
      );
      await _delay();

      if (arr[mid] == target) {
        state = state.copyWith(found: true, current: mid, currentStep: 'Target found at index $mid!');
        return;
      } else if (arr[mid] < target) {
        // Eliminate left half including mid
        for (int i = low; i <= mid; i++) {
          if (!currentEliminated.contains(i)) {
            currentEliminated.add(i);
          }
        }
        low = mid + 1;
        state = state.copyWith(currentStep: 'Target is greater, searching right half');
      } else {
        // Eliminate right half including mid
        for (int i = mid; i <= high; i++) {
          if (!currentEliminated.contains(i)) {
            currentEliminated.add(i);
          }
        }
        high = mid - 1;
        state = state.copyWith(currentStep: 'Target is smaller, searching left half');
      }
    }
    state = state.copyWith(found: false, current: null, currentStep: 'Target not found');
  }

  Future<void> _jumpSearch(List<int> arr, int target) async {
    state = state.copyWith(currentStep: 'Starting Jump Search...');
    
    int n = arr.length;
    int step = sqrt(n).floor();
    int prev = 0;

    // Finding the block where element is present (if it is present)
    while (prev < n && arr[min(step, n) - 1] < target) {
      state = state.copyWith(
        current: min(step, n) - 1,
        visited: List.from(state.visited)..add(min(step, n) - 1),
        currentStep: 'Jumping to index ${min(step, n) - 1}',
      );
      await _delay();
      
      prev = step;
      step += sqrt(n).floor();
      if (prev >= n) {
        state = state.copyWith(found: false, current: null, currentStep: 'Target not found');
        return;
      }
    }

    // Doing a linear search for target in block beginning with prev
    while (prev < min(step, n)) {
      state = state.copyWith(
        current: prev,
        visited: List.from(state.visited)..add(prev),
        currentStep: 'Linear search in block starting from index $prev',
      );
      await _delay();

      if (arr[prev] == target) {
        state = state.copyWith(found: true, current: prev, currentStep: 'Target found at index $prev!');
        return;
      }
      prev++;
    }
    state = state.copyWith(found: false, current: null, currentStep: 'Target not found');
  }

  Future<void> _interpolationSearch(List<int> arr, int target) async {
    state = state.copyWith(currentStep: 'Starting Interpolation Search...');
    
    int low = 0;
    int high = arr.length - 1;

    while (low <= high && target >= arr[low] && target <= arr[high]) {
      if (low == high) {
        if (arr[low] == target) {
          state = state.copyWith(found: true, current: low, currentStep: 'Target found at index $low!');
          return;
        }
        state = state.copyWith(found: false, current: null, currentStep: 'Target not found');
        return;
      }

      // Probing the position with keeping uniform distribution in mind
      int pos = low + (((high - low) * (target - arr[low])) ~/ (arr[high] - arr[low]));

      state = state.copyWith(
        current: pos,
        visited: List.from(state.visited)..add(pos),
        currentStep: 'Probing position $pos using interpolation',
      );
      await _delay();

      if (arr[pos] == target) {
        state = state.copyWith(found: true, current: pos, currentStep: 'Target found at index $pos!');
        return;
      }

      if (arr[pos] < target) {
        low = pos + 1;
        state = state.copyWith(currentStep: 'Target is greater, searching right half');
      } else {
        high = pos - 1;
        state = state.copyWith(currentStep: 'Target is smaller, searching left half');
      }
    }
    state = state.copyWith(found: false, current: null, currentStep: 'Target not found');
  }

  Future<void> _exponentialSearch(List<int> arr, int target) async {
    state = state.copyWith(currentStep: 'Starting Exponential Search...');
    
    int n = arr.length;
    
    // If array is empty
    if (n == 0) {
      state = state.copyWith(found: false, current: null, currentStep: 'Array is empty');
      return;
    }

    // Find range for binary search by repeated doubling
    int i = 1;
    while (i < n && arr[i] <= target) {
      state = state.copyWith(
        current: i,
        visited: List.from(state.visited)..add(i),
        currentStep: 'Exponentially expanding search range to index $i',
      );
      await _delay();
      i = i * 2;
    }

    // Call binary search for the found range
    state = state.copyWith(currentStep: 'Binary search in range [${i ~/ 2}, ${min(i, n - 1)}]');
    await _binarySearchInRange(arr, target, i ~/ 2, min(i, n - 1));
  }

  Future<void> _binarySearchInRange(List<int> arr, int target, int low, int high) async {
    List<int> currentEliminated = [];

    while (low <= high) {
      int mid = low + ((high - low) ~/ 2);

      state = state.copyWith(
        current: mid,
        eliminated: currentEliminated,
        visited: List.from(state.visited)..add(mid),
        currentStep: 'Binary search: checking middle element at index $mid',
      );
      await _delay();

      if (arr[mid] == target) {
        state = state.copyWith(found: true, current: mid, currentStep: 'Target found at index $mid!');
        return;
      } else if (arr[mid] < target) {
        // Eliminate left half including mid
        for (int i = low; i <= mid; i++) {
          if (!currentEliminated.contains(i)) {
            currentEliminated.add(i);
          }
        }
        low = mid + 1;
      } else {
        // Eliminate right half including mid
        for (int i = mid; i <= high; i++) {
          if (!currentEliminated.contains(i)) {
            currentEliminated.add(i);
          }
        }
        high = mid - 1;
      }
    }
    state = state.copyWith(found: false, current: null, currentStep: 'Target not found');
  }

  Future<void> _fibonacciSearch(List<int> arr, int target) async {
    state = state.copyWith(currentStep: 'Starting Fibonacci Search...');
    
    int n = arr.length;
    
    // Initialize fibonacci numbers
    int fibMMm2 = 0; // (m-2)'th Fibonacci No.
    int fibMMm1 = 1; // (m-1)'th Fibonacci No.
    int fibM = fibMMm2 + fibMMm1; // m'th Fibonacci

    // fibM is going to store the smallest Fibonacci Number greater than or equal to n
    while (fibM < n) {
      fibMMm2 = fibMMm1;
      fibMMm1 = fibM;
      fibM = fibMMm2 + fibMMm1;
    }

    // Initialize the offset to -1
    int offset = -1;

    // While there are elements to be inspected
    while (fibM > 1) {
      // Check if fibMm2 is a valid location
      int i = min(offset + fibMMm2, n - 1);

      state = state.copyWith(
        current: i,
        visited: List.from(state.visited)..add(i),
        currentStep: 'Checking Fibonacci position $i',
      );
      await _delay();

      if (arr[i] < target) {
        fibM = fibMMm1;
        fibMMm1 = fibMMm2;
        fibMMm2 = fibM - fibMMm1;
        offset = i;
        state = state.copyWith(currentStep: 'Target is greater, moving right');
      } else if (arr[i] > target) {
        fibM = fibMMm2;
        fibMMm1 = fibMMm1 - fibMMm2;
        fibMMm2 = fibM - fibMMm1;
        state = state.copyWith(currentStep: 'Target is smaller, moving left');
      } else {
        state = state.copyWith(found: true, current: i, currentStep: 'Target found at index $i!');
        return;
      }
    }

    // Compare the last element
    if (fibMMm1 == 1 && arr[offset + 1] == target) {
      state = state.copyWith(found: true, current: offset + 1, currentStep: 'Target found at index ${offset + 1}!');
      return;
    }

    state = state.copyWith(found: false, current: null, currentStep: 'Target not found');
  }
} 