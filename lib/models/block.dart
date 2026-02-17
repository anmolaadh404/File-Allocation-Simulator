// lib/models/block.dart

enum BlockType { free, data, indexNode, pointer }

class Block {
  final int id;
  bool isFree;
  String? fileId;
  BlockType blockType;
  int nextBlock; // for linked list (-1 = EOF)
  String tooltip;

  Block({
    required this.id,
    this.isFree = true,
    this.fileId,
    this.blockType = BlockType.free,
    this.nextBlock = -1,
    this.tooltip = '',
  });

  void reset() {
    isFree = true;
    fileId = null;
    blockType = BlockType.free;
    nextBlock = -1;
    tooltip = '';
  }

  Block copyWith({
    bool? isFree,
    String? fileId,
    BlockType? blockType,
    int? nextBlock,
    String? tooltip,
  }) {
    return Block(
      id: id,
      isFree: isFree ?? this.isFree,
      fileId: fileId ?? this.fileId,
      blockType: blockType ?? this.blockType,
      nextBlock: nextBlock ?? this.nextBlock,
      tooltip: tooltip ?? this.tooltip,
    );
  }
}
