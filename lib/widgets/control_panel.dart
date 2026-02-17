// lib/widgets/control_panel.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/disk_provider.dart';
import '../models/file_record.dart';
import '../theme/app_theme.dart';

class ControlPanel extends StatefulWidget {
  const ControlPanel({super.key});

  @override
  State<ControlPanel> createState() => _ControlPanelState();
}

class _ControlPanelState extends State<ControlPanel> {
  final _nameCtrl  = TextEditingController(text: 'fileA');
  final _sizeCtrl  = TextEditingController(text: '3');
  final _startCtrl = TextEditingController(text: '0');
  final _diskCtrl  = TextEditingController(text: '32');

  String? _errorMsg;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _sizeCtrl.dispose();
    _startCtrl.dispose();
    _diskCtrl.dispose();
    super.dispose();
  }

  void _allocate(DiskProvider dp) {
    setState(() => _errorMsg = null);
    final err = dp.allocate(
      name: _nameCtrl.text.trim(),
      size: int.tryParse(_sizeCtrl.text) ?? 0,
      startHint: int.tryParse(_startCtrl.text) ?? 0,
    );
    if (err != null) {
      setState(() => _errorMsg = err);
    } else {
      _advanceName();
    }
  }

  void _advanceName() {
    final current = _nameCtrl.text;
    if (current.isEmpty) return;
    final last = current[current.length - 1];
    if (last.codeUnitAt(0) >= 'a'.codeUnitAt(0) &&
        last.codeUnitAt(0) < 'z'.codeUnitAt(0)) {
      _nameCtrl.text =
          current.substring(0, current.length - 1) +
          String.fromCharCode(last.codeUnitAt(0) + 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dp = context.watch<DiskProvider>();
    final isContiguous = dp.currentMethod == AllocationMethod.contiguous;

    return Container(
      width: 300,
      color: AppTheme.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Header ──────────────────────────────────────────
          _PanelHeader(
            label: 'CONTROL PANEL',
            dotColor: AppTheme.accent,
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [

                  // ── Method Selector ────────────────────────
                  Text('ALLOCATION METHOD', style: AppTheme.labelStyle),
                  const SizedBox(height: 8),
                  _MethodSelector(
                    current: dp.currentMethod,
                    onChanged: dp.setMethod,
                  ),
                  const SizedBox(height: 12),

                  // ── Method Description ─────────────────────
                  _DescCard(text: dp.currentMethod.description),
                  const SizedBox(height: 16),

                  // ── Disk Config ────────────────────────────
                  const _Divider(label: 'DISK CONFIG'),
                  const SizedBox(height: 10),
                  Text('TOTAL BLOCKS', style: AppTheme.labelStyle),
                  const SizedBox(height: 6),
                  Row(children: [
                    Expanded(
                      child: TextField(
                        controller: _diskCtrl,
                        keyboardType: TextInputType.number,
                        style: GoogleFonts.jetBrainsMono(fontSize: 13),
                        decoration: const InputDecoration(hintText: '8–64'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    _SmallBtn(
                      label: 'RESET',
                      color: AppTheme.red,
                      onTap: () => dp.resetDisk(
                        int.tryParse(_diskCtrl.text) ?? 32,
                      ),
                    ),
                  ]),
                  const SizedBox(height: 16),

                  // ── File Config ────────────────────────────
                  const _Divider(label: 'ADD FILE'),
                  const SizedBox(height: 10),
                  Text('FILE NAME', style: AppTheme.labelStyle),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _nameCtrl,
                    style: GoogleFonts.jetBrainsMono(fontSize: 13),
                    decoration: const InputDecoration(hintText: 'e.g. notes.txt'),
                  ),
                  const SizedBox(height: 10),
                  Text('SIZE (BLOCKS)', style: AppTheme.labelStyle),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _sizeCtrl,
                    keyboardType: TextInputType.number,
                    style: GoogleFonts.jetBrainsMono(fontSize: 13),
                    decoration: const InputDecoration(hintText: '1–30'),
                  ),

                  if (isContiguous) ...[
                    const SizedBox(height: 10),
                    Text('START BLOCK HINT', style: AppTheme.labelStyle),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _startCtrl,
                      keyboardType: TextInputType.number,
                      style: GoogleFonts.jetBrainsMono(fontSize: 13),
                      decoration: const InputDecoration(hintText: '0'),
                    ),
                  ],

                  if (_errorMsg != null) ...[
                    const SizedBox(height: 8),
                    _ErrorBanner(message: _errorMsg!),
                  ],

                  const SizedBox(height: 12),
                  _ActionBtn(
                    label: '⊕  ALLOCATE FILE',
                    color: AppTheme.accent,
                    onTap: () => _allocate(dp),
                  ),
                  const SizedBox(height: 6),
                  _ActionBtn(
                    label: '⊗  DELETE SELECTED',
                    color: AppTheme.red,
                    outlined: true,
                    onTap: dp.selectedFileId != null
                        ? dp.deallocateSelected
                        : null,
                  ),

                  // ── File List ──────────────────────────────
                  const SizedBox(height: 16),
                  const _Divider(label: 'ALLOCATED FILES'),
                  const SizedBox(height: 8),
                  if (dp.files.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Text(
                        'No files allocated yet',
                        style: AppTheme.monoSmall,
                        textAlign: TextAlign.center,
                      ),
                    )
                  else
                    ...dp.files.values.map(
                      (f) => _FileListItem(
                        file: f,
                        isSelected: f.id == dp.selectedFileId,
                        onTap: () => dp.selectFile(f.id),
                        onDelete: () => dp.deallocate(f.id),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Sub-widgets ─────────────────────────────────────────────────────────────

class _PanelHeader extends StatelessWidget {
  final String label;
  final Color dotColor;
  const _PanelHeader({required this.label, required this.dotColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: AppTheme.surface2,
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
        Text(label, style: AppTheme.panelTitle),
      ]),
    );
  }
}

class _MethodSelector extends StatelessWidget {
  final AllocationMethod current;
  final ValueChanged<AllocationMethod> onChanged;
  const _MethodSelector({required this.current, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface2,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.border),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: AllocationMethod.values.map((m) {
          final active = m == current;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(m),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: active ? m.accentColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  m.label.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.syne(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                    color: active ? Colors.black : AppTheme.textDim,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _DescCard extends StatelessWidget {
  final String text;
  const _DescCard({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.surface2,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.border),
      ),
      child: Text(
        text,
        style: GoogleFonts.jetBrainsMono(
          fontSize: 11, color: AppTheme.textDim, height: 1.5,
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  final String label;
  const _Divider({required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(child: Container(height: 1, color: AppTheme.border)),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Text(label, style: AppTheme.labelStyle),
      ),
      Expanded(child: Container(height: 1, color: AppTheme.border)),
    ]);
  }
}

class _SmallBtn extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _SmallBtn({required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(color: color),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: GoogleFonts.syne(
            fontSize: 10, fontWeight: FontWeight.w700, color: color,
          ),
        ),
      ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final String label;
  final Color color;
  final bool outlined;
  final VoidCallback? onTap;
  const _ActionBtn({
    required this.label,
    required this.color,
    this.outlined = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: outlined
              ? Colors.transparent
              : (enabled ? color : color.withAlpha(80)),
          border: outlined ? Border.all(color: enabled ? color : color.withAlpha(80)) : null,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: GoogleFonts.syne(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 1,
            color: outlined
                ? (enabled ? color : color.withAlpha(80))
                : (enabled ? Colors.black : Colors.black45),
          ),
        ),
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  final String message;
  const _ErrorBanner({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppTheme.red.withAlpha(20),
        border: Border.all(color: AppTheme.red.withAlpha(100)),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        message,
        style: GoogleFonts.jetBrainsMono(
          fontSize: 11, color: AppTheme.red,
        ),
      ),
    );
  }
}

class _FileListItem extends StatelessWidget {
  final FileRecord file;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  const _FileListItem({
    required this.file,
    required this.isSelected,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.only(bottom: 4),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? file.color.withAlpha(25)
              : AppTheme.surface2,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isSelected ? file.color : AppTheme.border,
          ),
        ),
        child: Row(children: [
          Container(
            width: 8, height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: file.color,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  file.name,
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: file.color,
                  ),
                ),
                Text(
                  '${file.size} blks · ${file.method.label}',
                  style: AppTheme.monoTiny,
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onDelete,
            child: Container(
              padding: const EdgeInsets.all(4),
              child: const Icon(
                Icons.close_rounded,
                size: 14,
                color: AppTheme.textDim,
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
