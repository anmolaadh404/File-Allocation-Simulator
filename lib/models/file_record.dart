// lib/models/file_record.dart

import 'package:flutter/material.dart';

enum AllocationMethod { contiguous, linked, indexed }

extension AllocationMethodExt on AllocationMethod {
  String get label {
    switch (this) {
      case AllocationMethod.contiguous: return 'Contiguous';
      case AllocationMethod.linked:     return 'Linked List';
      case AllocationMethod.indexed:    return 'Indexed';
    }
  }

  String get description {
    switch (this) {
      case AllocationMethod.contiguous:
        return 'Blocks are allocated in adjacent sequence. '
               'Fast O(1) direct access but suffers from external fragmentation.';
      case AllocationMethod.linked:
        return 'Blocks are scattered; each block stores a pointer to the next. '
               'No external fragmentation but O(n) sequential access.';
      case AllocationMethod.indexed:
        return 'An index block holds pointers to all data blocks (Unix inode style). '
               'Supports direct access and handles fragmentation well.';
    }
  }

  Color get accentColor {
    switch (this) {
      case AllocationMethod.contiguous: return const Color(0xFF00E5FF);
      case AllocationMethod.linked:     return const Color(0xFFF59E0B);
      case AllocationMethod.indexed:    return const Color(0xFF7C3AED);
    }
  }
}

class FileRecord {
  final String id;
  final String name;
  final int size;
  final AllocationMethod method;
  final Color color;

  /// Contiguous: first block index
  final int startBlock;

  /// Indexed: the index block id
  final int indexBlock;

  /// All block ids belonging to this file (including index block)
  final List<int> blocks;

  const FileRecord({
    required this.id,
    required this.name,
    required this.size,
    required this.method,
    required this.color,
    this.startBlock = -1,
    this.indexBlock = -1,
    required this.blocks,
  });

  String get accessInfo {
    switch (method) {
      case AllocationMethod.contiguous:
        return 'Start: $startBlock  End: ${startBlock + size - 1}';
      case AllocationMethod.linked:
        return 'Head: ${blocks.first}  Tail: ${blocks.last}';
      case AllocationMethod.indexed:
        return 'Index Block: $indexBlock';
    }
  }
}
