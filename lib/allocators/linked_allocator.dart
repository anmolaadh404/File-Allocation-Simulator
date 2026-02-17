// lib/allocators/linked_allocator.dart

import '../models/block.dart';

class LinkedAllocator {
  /// Picks [size] free blocks (any location) and links them as a chain.
  /// Returns the list of chosen block ids, or null if not enough free blocks.
  static List<int>? findFreeBlocks(List<Block> disk, int size) {
    final free = disk.where((b) => b.isFree).map((b) => b.id).toList();
    if (free.length < size) return null;
    return free.take(size).toList();
  }

  /// Allocate and link the chosen blocks.
  /// Each block's [nextBlock] points to the next; last block has nextBlock = -1 (EOF).
  static List<int> allocate({
    required List<Block> disk,
    required List<int> chosen,
    required String fileId,
    required String fileName,
  }) {
    for (int i = 0; i < chosen.length; i++) {
      final int next = i < chosen.length - 1 ? chosen[i + 1] : -1;
      disk[chosen[i]]
        ..isFree = false
        ..fileId = fileId
        ..blockType = BlockType.data
        ..nextBlock = next
        ..tooltip =
            '$fileName  [linked]  node ${i + 1}/${chosen.length}'
            '  →  ${next == -1 ? "EOF" : next}';
    }
    return chosen;
  }
}
