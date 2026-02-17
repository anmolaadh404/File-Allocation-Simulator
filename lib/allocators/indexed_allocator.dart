// lib/allocators/indexed_allocator.dart

import '../models/block.dart';

class IndexedAllocatorResult {
  final int indexBlock;
  final List<int> dataBlocks;
  const IndexedAllocatorResult(this.indexBlock, this.dataBlocks);
}

class IndexedAllocator {
  /// Needs [size] + 1 free blocks (1 extra for the index block).
  /// Returns null if not enough space.
  static IndexedAllocatorResult? findBlocks(List<Block> disk, int size) {
    final free = disk.where((b) => b.isFree).map((b) => b.id).toList();
    if (free.length < size + 1) return null;
    return IndexedAllocatorResult(free[0], free.sublist(1, size + 1));
  }

  /// Allocate: mark one block as the index node, rest as data.
  static List<int> allocate({
    required List<Block> disk,
    required IndexedAllocatorResult result,
    required String fileId,
    required String fileName,
  }) {
    final idx = result.indexBlock;
    final data = result.dataBlocks;

    // Mark index block
    disk[idx]
      ..isFree = false
      ..fileId = fileId
      ..blockType = BlockType.indexNode
      ..tooltip = '$fileName  [INDEX BLOCK]  →  [${data.join(", ")}]';

    // Mark data blocks
    for (int i = 0; i < data.length; i++) {
      disk[data[i]]
        ..isFree = false
        ..fileId = fileId
        ..blockType = BlockType.data
        ..tooltip = '$fileName  [data]  block ${i + 1}/${data.length}'
            '  (indexed by block $idx)';
    }

    return [idx, ...data];
  }
}
