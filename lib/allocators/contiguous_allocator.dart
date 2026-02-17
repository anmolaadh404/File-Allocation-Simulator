// lib/allocators/contiguous_allocator.dart

import '../models/block.dart';

class ContiguousAllocator {
  /// First-fit strategy: find the first run of [size] free blocks
  /// starting from [startHint]. Falls back to 0 if not found from hint.
  ///
  /// Returns the starting block index, or -1 if not enough contiguous space.
  static int findStart(List<Block> disk, int size, int startHint) {
    // Try from startHint first
    final result = _scan(disk, size, startHint);
    if (result != -1) return result;

    // Fallback: scan from beginning
    if (startHint > 0) return _scan(disk, size, 0);
    return -1;
  }

  static int _scan(List<Block> disk, int size, int from) {
    for (int i = from; i <= disk.length - size; i++) {
      bool fits = true;
      for (int j = i; j < i + size; j++) {
        if (!disk[j].isFree) {
          fits = false;
          break;
        }
      }
      if (fits) return i;
    }
    return -1;
  }

  /// Allocate [size] blocks starting at [start].
  /// Mutates the disk list in place.
  static List<int> allocate({
    required List<Block> disk,
    required int start,
    required int size,
    required String fileId,
    required String fileName,
  }) {
    final allocated = <int>[];
    for (int i = start; i < start + size; i++) {
      disk[i]
        ..isFree = false
        ..fileId = fileId
        ..blockType = BlockType.data
        ..tooltip =
            '$fileName  [data]  block ${i - start + 1}/$size';
      allocated.add(i);
    }
    return allocated;
  }
}
