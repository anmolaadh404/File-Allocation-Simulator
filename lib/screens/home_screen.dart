// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/disk_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/control_panel.dart';
import '../widgets/disk_grid.dart';
import '../widgets/info_panels.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _prevMessage = '';

  @override
  Widget build(BuildContext context) {
    final dp = context.watch<DiskProvider>();

    // Show snackbar on new messages
    if (dp.lastMessage.isNotEmpty && dp.lastMessage != _prevMessage) {
      _prevMessage = dp.lastMessage;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context)
          ..clearSnackBars()
          ..showSnackBar(
            SnackBar(
              content: Text(
                dp.lastMessage,
                style: GoogleFonts.jetBrainsMono(fontSize: 12),
              ),
              backgroundColor: dp.lastWasError ? AppTheme.red : AppTheme.surface2,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(
                  color: dp.lastWasError ? AppTheme.red : AppTheme.accent,
                ),
              ),
              duration: const Duration(milliseconds: 2500),
            ),
          );
      });
    }

    return Scaffold(
      backgroundColor: AppTheme.bg,
      body: Column(
        children: [
          // ── Top App Bar ──────────────────────────────────────
          _AppBar(),

          // ── Main Body ────────────────────────────────────────
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left: control panel
                const ControlPanel(),

                // Divider
                Container(width: 1, color: AppTheme.border),

                // Right: visualizations
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: const [
                        DiskGrid(),
                        SizedBox(height: 14),
                        FatPanel(),
                        SizedBox(height: 14),
                        AlgoDetailsPanel(),
                        SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── App Bar ──────────────────────────────────────────────────────────────────
class _AppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: const BoxDecoration(
        color: AppTheme.surface,
        border: Border(bottom: BorderSide(color: AppTheme.border)),
      ),
      child: Row(
        children: [
          // Logo
          RichText(
            text: TextSpan(
              style: GoogleFonts.syne(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
              children: const [
                TextSpan(text: 'FILE', style: TextStyle(color: Colors.white)),
                TextSpan(
                  text: 'ALLOC',
                  style: TextStyle(color: AppTheme.accent),
                ),
                TextSpan(text: '.SIM', style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 1, height: 20, color: AppTheme.border,
          ),
          const SizedBox(width: 12),
          Text(
            'OS FILE ALLOCATION SIMULATOR',
            style: GoogleFonts.jetBrainsMono(
              fontSize: 10,
              color: AppTheme.textDim,
              letterSpacing: 2,
            ),
          ),

          const Spacer(),

          // Built with Dart badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppTheme.accent2, AppTheme.accent],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'BUILT WITH DART + FLUTTER',
              style: GoogleFonts.syne(
                fontSize: 9,
                fontWeight: FontWeight.w700,
                color: Colors.black,
                letterSpacing: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
