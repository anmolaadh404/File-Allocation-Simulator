// lib/models/disk_provider.dart

import 'package:flutter/material.dart';
import 'block.dart';
import 'file_record.dart';
import '../allocators/contiguous_allocator.dart';
import '../allocators/linked_allocator.dart';
import '../allocators/indexed_allocator.dart';

// Palette of distinct file colors
const List<Color> _kFileColors = [
  Color(0xFF00E5FF),
  Color(0xFF10B981),
  Color(0xFFF59E0B),
  Color(0xFFF43F5E),
  Color(0xFF8B5CF6),
  Color(0xFF06B6D4),
  Color(0xFF84CC16),
  Color(0xFFFB923C),
  Color(0xFFE879F9),
  Color(0xFF34D399),
];

class DiskProvider extends ChangeNotifier {
  // ── Disk state ──────────────────────────────────────────────
  List<Block> disk = [];
  int totalBlocks = 32;

  // ── Files ───────────────────────────────────────────────────
  final Map<String, FileRecord> files = {};
  String? selectedFileId;

  // ── UI state ────────────────────────────────────────────────
  AllocationMethod currentMethod = AllocationMethod.contiguous;
  String lastMessage = '';
  bool lastWasError = false;

  int _fileCounter = 0;
  int _colorIdx = 0;

  // ── Computed ────────────────────────────────────────────────
  int get usedBlocks  => disk.where((b) => !b.isFree).length;
  int get freeBlocks  => totalBlocks - usedBlocks;
  double get utilization => totalBlocks == 0 ? 0 : usedBlocks / totalBlocks;

  FileRecord? get selectedFile =>
      selectedFileId != null ? files[selectedFileId] : null;

  // ── Init ────────────────────────────────────────────────────
  DiskProvider() {
    _initDisk();
  }

  void _initDisk() {
    disk = List.generate(totalBlocks, (i) => Block(id: i));
  }

  void resetDisk(int newSize) {
    totalBlocks = newSize.clamp(8, 64);
    files.clear();
    selectedFileId = null;
    _fileCounter = 0;
    _colorIdx = 0;
    _initDisk();
    _notify('Disk reset to $totalBlocks blocks');
  }

  // ── Allocation entry point ───────────────────────────────────
  /// Returns an error string on failure, null on success.
  String? allocate({
    required String name,
    required int size,
    int startHint = 0,
  }) {
    if (name.trim().isEmpty) return 'Enter a file name';
    if (size < 1 || size > 30) return 'File size must be 1–30 blocks';
    if (files.values.any((f) => f.name == name)) {
      return 'A file named "$name" already exists';
    }

    final id = 'f${_fileCounter++}';
    final color = _kFileColors[_colorIdx % _kFileColors.length];
    _colorIdx++;

    List<int> allocated;
    int startBlock = -1;
    int indexBlock = -1;

    switch (currentMethod) {
      case AllocationMethod.contiguous:
        final start = ContiguousAllocator.findStart(disk, size, startHint);
        if (start == -1) return 'Not enough contiguous free space for $size blocks';
        startBlock = start;
        allocated = ContiguousAllocator.allocate(
          disk: disk, start: start, size: size,
          fileId: id, fileName: name,
        );

      case AllocationMethod.linked:
        final chosen = LinkedAllocator.findFreeBlocks(disk, size);
        if (chosen == null) return 'Not enough free blocks (need $size)';
        allocated = LinkedAllocator.allocate(
          disk: disk, chosen: chosen,
          fileId: id, fileName: name,
        );

      case AllocationMethod.indexed:
        final result = IndexedAllocator.findBlocks(disk, size);
        if (result == null) {
          return 'Not enough free blocks (need ${size + 1}: 1 index + $size data)';
        }
        indexBlock = result.indexBlock;
        allocated = IndexedAllocator.allocate(
          disk: disk, result: result,
          fileId: id, fileName: name,
        );
    }

    files[id] = FileRecord(
      id: id,
      name: name,
      size: size,
      method: currentMethod,
      color: color,
      startBlock: startBlock,
      indexBlock: indexBlock,
      blocks: allocated,
    );

    selectedFileId = id;
    _notify('✓ "$name" allocated via ${currentMethod.label}');
    return null; // success
  }

  // ── Deallocation ─────────────────────────────────────────────
  void deallocate(String fileId) {
    final f = files[fileId];
    if (f == null) return;
    for (final b in f.blocks) {
      disk[b].reset();
    }
    files.remove(fileId);
    if (selectedFileId == fileId) selectedFileId = null;
    _notify('✗ "${f.name}" deleted — ${f.blocks.length} blocks freed');
  }

  void deallocateSelected() {
    if (selectedFileId != null) deallocate(selectedFileId!);
  }

  // ── Selection ────────────────────────────────────────────────
  void selectFile(String? fileId) {
    selectedFileId = fileId;
    notifyListeners();
  }

  void setMethod(AllocationMethod m) {
    currentMethod = m;
    notifyListeners();
  }

  void _notify(String msg, {bool error = false}) {
    lastMessage = msg;
    lastWasError = error;
    notifyListeners();
  }
}
