// lib/widgets/info_panels.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/disk_provider.dart';
import '../models/file_record.dart';
import '../models/block.dart';
import '../theme/app_theme.dart';

// ════════════════════════════════════════════════════════════════
// FILE ALLOCATION TABLE
// ════════════════════════════════════════════════════════════════
class FatPanel extends StatelessWidget {
  const FatPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final dp = context.watch<DiskProvider>();

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          _panelHeader('FILE ALLOCATION TABLE', AppTheme.accent3),

          if (dp.files.isEmpty)
            const Padding(
              padding: EdgeInsets.all(24),
              child: _EmptyState(
                icon: '📂',
                text: 'Allocate a file to see its table entry',
              ),
            )
          else
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Table(
                  defaultColumnWidth: const IntrinsicColumnWidth(),
                  columnWidths: const {
                    0: FixedColumnWidth(120),
                    1: FixedColumnWidth(100),
                    2: FixedColumnWidth(60),
                    3: FixedColumnWidth(110),
                    4: IntrinsicColumnWidth(),
                  },
                  children: [
                    // Header row
                    TableRow(
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: AppTheme.border),
                        ),
                      ),
                      children: ['FILE', 'METHOD', 'SIZE', 'START/IDX', 'BLOCKS']
                          .map((h) => Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 6, horizontal: 8),
                                child: Text(h, style: AppTheme.labelStyle),
                              ))
                          .toList(),
                    ),
                    // Data rows
                    ...dp.files.values.map((f) => _buildRow(f, dp)),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  TableRow _buildRow(FileRecord f, DiskProvider dp) {
    final isSelected = f.id == dp.selectedFileId;
    final startInfo = f.method == AllocationMethod.contiguous
        ? '${f.startBlock}'
        : f.method == AllocationMethod.linked
            ? 'Head: ${f.blocks.first}'
            : 'Idx: ${f.indexBlock}';

    return TableRow(
      decoration: BoxDecoration(
        color: isSelected ? f.color.withAlpha(15) : Colors.transparent,
      ),
      children: [
        // File name
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 8),
          child: Text(
            f.name,
            style: GoogleFonts.jetBrainsMono(
              fontSize: 12, fontWeight: FontWeight.w700, color: f.color,
            ),
          ),
        ),
        // Method badge
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
          child: _MethodBadge(method: f.method),
        ),
        // Size
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 8),
          child: Text(
            '${f.size}',
            style: AppTheme.monoSmall,
          ),
        ),
        // Start/Index
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 8),
          child: Text(startInfo, style: AppTheme.monoSmall),
        ),
        // Blocks list
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 8),
          child: Text(
            '[${f.blocks.join(', ')}]',
            style: GoogleFonts.jetBrainsMono(
              fontSize: 10, color: AppTheme.textDim,
            ),
          ),
        ),
      ],
    );
  }
}

// ════════════════════════════════════════════════════════════════
// ALGORITHM DETAILS PANEL
// ════════════════════════════════════════════════════════════════
class AlgoDetailsPanel extends StatelessWidget {
  const AlgoDetailsPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final dp = context.watch<DiskProvider>();
    final f = dp.selectedFile;

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _panelHeader('ALGORITHM DETAILS', AppTheme.accent2),
          Padding(
            padding: const EdgeInsets.all(14),
            child: f == null
                ? const _EmptyState(
                    icon: '🔍',
                    text: 'Select a file to see allocation chain',
                  )
                : _AlgoContent(file: f, disk: dp.disk),
          ),
        ],
      ),
    );
  }
}

class _AlgoContent extends StatelessWidget {
  final FileRecord file;
  final List<dynamic> disk;
  const _AlgoContent({required this.file, required this.disk});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // File name + method
        Row(children: [
          Container(
            width: 10, height: 10,
            decoration: BoxDecoration(shape: BoxShape.circle, color: file.color),
          ),
          const SizedBox(width: 8),
          Text(
            file.name,
            style: GoogleFonts.syne(
              fontSize: 16, fontWeight: FontWeight.w800, color: file.color,
            ),
          ),
          const SizedBox(width: 10),
          _MethodBadge(method: file.method),
        ]),
        const SizedBox(height: 4),
        Text(file.accessInfo, style: AppTheme.monoSmall),
        const SizedBox(height: 14),

        // Allocation chain visualization
        _buildChain(),
        const SizedBox(height: 12),

        // Complexity info
        _ComplexityRow(method: file.method),
      ],
    );
  }

  Widget _buildChain() {
    switch (file.method) {
      case AllocationMethod.contiguous:
        return _ContiguousChain(file: file);
      case AllocationMethod.linked:
        return _LinkedChain(file: file);
      case AllocationMethod.indexed:
        return _IndexedChain(file: file);
    }
  }
}

class _ContiguousChain extends StatelessWidget {
  final FileRecord file;
  const _ContiguousChain({required this.file});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 4,
      runSpacing: 4,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        for (int i = 0; i < file.blocks.length; i++) ...[
          _BlockChip(
            label: 'BLK ${file.blocks[i]}',
            color: file.color,
            textColor: Colors.black,
          ),
          if (i < file.blocks.length - 1)
            Text('→', style: TextStyle(color: file.color)),
        ],
      ],
    );
  }
}

class _LinkedChain extends StatelessWidget {
  final FileRecord file;
  const _LinkedChain({required this.file});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 4,
      runSpacing: 4,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        for (int i = 0; i < file.blocks.length; i++) ...[
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _BlockChip(
                label: 'NODE ${file.blocks[i]}',
                color: file.color,
                textColor: Colors.black,
              ),
              Text(
                '→ ${i < file.blocks.length - 1 ? file.blocks[i + 1] : "EOF"}',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 9, color: AppTheme.textDim,
                ),
              ),
            ],
          ),
          if (i < file.blocks.length - 1)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text('→', style: TextStyle(color: file.color)),
            ),
        ],
      ],
    );
  }
}

class _IndexedChain extends StatelessWidget {
  final FileRecord file;
  const _IndexedChain({required this.file});

  @override
  Widget build(BuildContext context) {
    final dataBlocks = file.blocks.where((b) => b != file.indexBlock).toList();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Index block
        Column(
          children: [
            _BlockChip(
              label: 'IDX ${file.indexBlock}',
              color: AppTheme.blockIndex,
              textColor: Colors.white,
            ),
            const SizedBox(height: 4),
            Text(
              'index node',
              style: GoogleFonts.jetBrainsMono(
                fontSize: 9, color: AppTheme.textDim,
              ),
            ),
          ],
        ),
        const SizedBox(width: 8),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Text('→', style: const TextStyle(color: AppTheme.accent2, fontSize: 18)),
        ),
        const SizedBox(width: 8),
        // Data blocks
        Expanded(
          child: Wrap(
            spacing: 4,
            runSpacing: 4,
            children: dataBlocks
                .map((b) => _BlockChip(
                      label: 'BLK $b',
                      color: file.color,
                      textColor: Colors.black,
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }
}

class _ComplexityRow extends StatelessWidget {
  final AllocationMethod method;
  const _ComplexityRow({required this.method});

  String get _access {
    switch (method) {
      case AllocationMethod.contiguous: return 'O(1) direct access';
      case AllocationMethod.linked:     return 'O(n) sequential traversal';
      case AllocationMethod.indexed:    return 'O(1) via index lookup';
    }
  }

  String get _fragmentation {
    switch (method) {
      case AllocationMethod.contiguous: return 'External fragmentation';
      case AllocationMethod.linked:     return 'No external fragmentation';
      case AllocationMethod.indexed:    return 'Minimal fragmentation';
    }
  }

  IconData get _accessIcon {
    switch (method) {
      case AllocationMethod.contiguous: return Icons.flash_on_rounded;
      case AllocationMethod.linked:     return Icons.linear_scale_rounded;
      case AllocationMethod.indexed:    return Icons.account_tree_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppTheme.surface2,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.border),
      ),
      child: Row(children: [
        Icon(_accessIcon, size: 14, color: method.accentColor),
        const SizedBox(width: 8),
        Text(_access, style: AppTheme.monoSmall),
        const SizedBox(width: 16),
        Container(width: 1, height: 14, color: AppTheme.border),
        const SizedBox(width: 16),
        Text(_fragmentation, style: AppTheme.monoTiny),
      ]),
    );
  }
}

// ── Shared sub-widgets ───────────────────────────────────────────────────────

Widget _panelHeader(String title, Color dotColor) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    decoration: const BoxDecoration(
      color: AppTheme.surface2,
      borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      border: Border(bottom: BorderSide(color: AppTheme.border)),
    ),
    child: Row(children: [
      Container(
        width: 8, height: 8,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: dotColor,
          boxShadow: [BoxShadow(color: dotColor.withAlpha(150), blurRadius: 8)],
        ),
      ),
      const SizedBox(width: 10),
      Text(title, style: AppTheme.panelTitle),
    ]),
  );
}

class _BlockChip extends StatelessWidget {
  final String label;
  final Color color;
  final Color textColor;
  const _BlockChip({
    required this.label,
    required this.color,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        label,
        style: GoogleFonts.jetBrainsMono(
          fontSize: 10, fontWeight: FontWeight.w700, color: textColor,
        ),
      ),
    );
  }
}

class _MethodBadge extends StatelessWidget {
  final AllocationMethod method;
  const _MethodBadge({required this.method});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: method.accentColor.withAlpha(30),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: method.accentColor.withAlpha(100)),
      ),
      child: Text(
        method.label,
        style: GoogleFonts.syne(
          fontSize: 9,
          fontWeight: FontWeight.w700,
          color: method.accentColor,
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String icon;
  final String text;
  const _EmptyState({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(icon, style: const TextStyle(fontSize: 28)),
        const SizedBox(height: 8),
        Text(text, style: AppTheme.monoSmall, textAlign: TextAlign.center),
      ],
    );
  }
}
