// lib/widgets/disk_grid.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/disk_provider.dart';
import '../models/block.dart';
import '../theme/app_theme.dart';

class DiskGrid extends StatelessWidget {
  const DiskGrid({super.key});

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
          // ── Header ──────────────────────────────────────────
          _GridHeader(dp: dp),

          // ── Block Grid ──────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(14),
            child: Wrap(
              spacing: 5,
              runSpacing: 5,
              children: dp.disk.map((block) {
                final file =
                    block.fileId != null ? dp.files[block.fileId] : null;
                final isSelected = file != null && file.id == dp.selectedFileId;

                return _BlockTile(
                  block: block,
                  fileColor: file?.color,
                  isSelected: isSelected,
                  fileName: file?.name,
                  onTap: file != null ? () => dp.selectFile(file.id) : null,
                );
              }).toList(),
            ),
          ),

          // ── Utilization bar ─────────────────────────────────
          _UtilBar(utilization: dp.utilization),

          // ── Legend ──────────────────────────────────────────
          const _Legend(),
        ],
      ),
    );
  }
}

class _GridHeader extends StatelessWidget {
  final DiskProvider dp;
  const _GridHeader({required this.dp});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: AppTheme.surface2,
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
        border: Border(bottom: BorderSide(color: AppTheme.border)),
      ),
      child: Row(children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppTheme.accent,
            boxShadow: [
              BoxShadow(color: AppTheme.accent.withAlpha(150), blurRadius: 8),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Text('DISK BLOCK MAP', style: AppTheme.panelTitle),
        const Spacer(),
        _Stat(label: 'TOTAL', value: '${dp.totalBlocks}'),
        const SizedBox(width: 16),
        _Stat(
            label: 'USED',
            value: '${dp.usedBlocks}',
            valueColor: AppTheme.accent),
        const SizedBox(width: 16),
        _Stat(
            label: 'FREE',
            value: '${dp.freeBlocks}',
            valueColor: AppTheme.green),
        const SizedBox(width: 16),
        _Stat(
          label: 'UTIL',
          value: '${(dp.utilization * 100).round()}%',
          valueColor: AppTheme.accent3,
        ),
      ]),
    );
  }
}

class _Stat extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  const _Stat({required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(label, style: AppTheme.monoTiny),
        Text(
          value,
          style: GoogleFonts.jetBrainsMono(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: valueColor ?? Colors.white,
          ),
        ),
      ],
    );
  }
}

// ── Individual Block Tile ────────────────────────────────────────────────────
class _BlockTile extends StatefulWidget {
  final Block block;
  final Color? fileColor;
  final bool isSelected;
  final String? fileName;
  final VoidCallback? onTap;

  const _BlockTile({
    required this.block,
    this.fileColor,
    required this.isSelected,
    this.fileName,
    this.onTap,
  });

  @override
  State<_BlockTile> createState() => _BlockTileState();
}

class _BlockTileState extends State<_BlockTile>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseCtrl;
  late final Animation<double> _pulseAnim;
  bool _hovered = false;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final b = widget.block;
    final color = widget.fileColor;
    final selected = widget.isSelected;

    Color bgColor;
    Color borderColor;
    Color textColor;
    String label;

    if (b.isFree) {
      bgColor = AppTheme.blockFree;
      borderColor = AppTheme.border;
      textColor = AppTheme.textDim;
      label = '';
    } else {
      switch (b.blockType) {
        case BlockType.indexNode:
          bgColor = AppTheme.blockIndex.withAlpha(200);
          borderColor = color ?? AppTheme.blockIndex;
          textColor = Colors.white;
          label = 'IDX';
        case BlockType.data:
          bgColor = color ?? AppTheme.accent;
          borderColor = color ?? AppTheme.accent;
          textColor = Colors.black;
          label = (widget.fileName ?? '').length > 4
              ? (widget.fileName ?? '').substring(0, 4)
              : (widget.fileName ?? '');
        default:
          bgColor = color ?? AppTheme.accent;
          borderColor = color ?? AppTheme.accent;
          textColor = Colors.black;
          label = 'PTR';
      }
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Tooltip(
          message: b.isFree ? 'Block ${b.id} — FREE' : b.tooltip,
          textStyle:
              GoogleFonts.jetBrainsMono(fontSize: 11, color: Colors.white),
          decoration: BoxDecoration(
            color: AppTheme.surface2,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: AppTheme.border),
          ),
          waitDuration: const Duration(milliseconds: 300),
          child: AnimatedBuilder(
            animation: _pulseAnim,
            builder: (context, child) {
              final glowStrength =
                  selected ? _pulseAnim.value : (_hovered ? 0.5 : 0.0);
              return AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: selected
                        ? (color ?? AppTheme.accent)
                        : (_hovered && !b.isFree)
                            ? (color ?? AppTheme.accent)
                            : borderColor,
                    width: selected ? 2 : 1,
                  ),
                  boxShadow: !b.isFree && (selected || _hovered)
                      ? [
                          BoxShadow(
                            color: (color ?? AppTheme.accent)
                                .withAlpha((glowStrength * 150).round()),
                            blurRadius: 12,
                            spreadRadius: 1,
                          ),
                        ]
                      : null,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${b.id}',
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 9,
                        color: b.isFree
                            ? AppTheme.textDim
                            : textColor.withAlpha(160),
                      ),
                    ),
                    if (!b.isFree && label.isNotEmpty)
                      Text(
                        label,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: textColor,
                        ),
                      ),
                    if (!b.isFree && b.nextBlock != -1)
                      Text(
                        '→',
                        style: TextStyle(
                          fontSize: 8,
                          color: textColor.withAlpha(180),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

// ── Utilization Bar ──────────────────────────────────────────────────────────
class _UtilBar extends StatelessWidget {
  final double utilization;
  const _UtilBar({required this.utilization});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 0, 14, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: utilization,
              minHeight: 5,
              backgroundColor: AppTheme.surface2,
              valueColor: AlwaysStoppedAnimation<Color>(
                Color.lerp(AppTheme.green, AppTheme.red, utilization)!,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'DISK UTILIZATION  ${(utilization * 100).round()}%',
            style: AppTheme.monoTiny,
          ),
        ],
      ),
    );
  }
}

// ── Legend ───────────────────────────────────────────────────────────────────
class _Legend extends StatelessWidget {
  const _Legend();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppTheme.border)),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
      ),
      child: Wrap(
        spacing: 20,
        runSpacing: 6,
        children: const [
          _LegendItem(label: 'Free Block', color: AppTheme.blockFree),
          _LegendItem(label: 'Data Block', color: AppTheme.accent),
          _LegendItem(label: 'Index Block', color: AppTheme.blockIndex),
          _LegendItem(label: 'Linked Node (→ next)', color: AppTheme.accent3),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final String label;
  final Color color;
  const _LegendItem({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(3),
          border: Border.all(color: AppTheme.border),
        ),
      ),
      const SizedBox(width: 6),
      Text(label, style: AppTheme.monoTiny),
    ]);
  }
}
