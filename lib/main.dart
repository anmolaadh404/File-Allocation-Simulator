// lib/main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/disk_provider.dart';
import 'screens/home_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const FileAllocSimApp());
}

class FileAllocSimApp extends StatelessWidget {
  const FileAllocSimApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DiskProvider(),
      child: MaterialApp(
        title: 'File Allocation Simulator',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark,
        home: const HomeScreen(),
      ),
    );
  }
}
