# 📁 File Allocation Simulator


A fully interactive File Allocation Simulator that implements all three classic
OS disk allocation strategies with a polished dark-mode GUI.

---

## 🗂 Project Structure

```
file_alloc_sim/
├── lib/
│   ├── main.dart                        ← Flutter entry point
│   ├── models/
│   │   ├── block.dart                   ← Block data class (BlockType enum)
│   │   ├── file_record.dart             ← FileRecord + AllocationMethod
│   │   └── disk_provider.dart           ← Main state (ChangeNotifier)
│   ├── allocators/
│   │   ├── contiguous_allocator.dart    ← First-fit contiguous logic
│   │   ├── linked_allocator.dart        ← FAT-style linked list logic
│   │   └── indexed_allocator.dart       ← Inode-style indexed logic
│   ├── screens/
│   │   └── home_screen.dart             ← Main screen layout
│   ├── widgets/
│   │   ├── control_panel.dart           ← Left sidebar controls
│   │   ├── disk_grid.dart               ← Visual disk block map
│   │   └── info_panels.dart             ← FAT table + algorithm details
│   └── theme/
│       └── app_theme.dart               ← Colors, fonts, theme
└── pubspec.yaml
```

---

## 🚀 Setup & Run

### Prerequisites
- Flutter SDK ≥ 3.0.0  →  https://flutter.dev/docs/get-started/install
- Dart SDK ≥ 3.0.0 (bundled with Flutter)

### Steps

```bash
# 1. Navigate to the project folder
cd file_alloc_sim

# 2. Install dependencies
flutter pub get

# 3. Run on desktop (recommended for the best experience)
flutter run -d windows     # Windows
flutter run -d macos       # macOS
flutter run -d linux       # Linux

# 4. Or run on Chrome
flutter run -d chrome
```

---

## 🧠 Allocation Algorithms Implemented

| Method       | Dart Class              | Strategy                          | Access   |
|--------------|-------------------------|-----------------------------------|----------|
| Contiguous   | `ContiguousAllocator`   | First-fit scan for adjacent blocks| O(1)     |
| Linked List  | `LinkedAllocator`       | FAT-style chained pointers        | O(n)     |
| Indexed      | `IndexedAllocator`      | inode-style index block           | O(1)     |

### Key Dart Classes
- **`Block`** — represents one disk sector (`isFree`, `blockType`, `nextBlock`)
- **`FileRecord`** — immutable record of a file's metadata and block list
- **`DiskProvider`** — `ChangeNotifier` that owns `List<Block>` and all files
- **`ContiguousAllocator.findStart()`** — first-fit scan returning start index
- **`LinkedAllocator.allocate()`** — picks free blocks and chains nextBlock pointers
- **`IndexedAllocator.allocate()`** — marks first free block as index, rest as data

---

## 🎮 How to Use

1. **Pick a method** — tap Contiguous / Linked List / Indexed in the top tab
2. **Set disk size** — change "Total Blocks" and hit RESET (8–64 blocks)
3. **Add a file** — enter a name, size, and (for contiguous) a start block hint
4. **Allocate** — hit ⊕ ALLOCATE FILE and watch the disk map light up
5. **Inspect** — click any colored block or file name to see its full chain
6. **Delete** — select a file and hit ⊗ DELETE SELECTED
7. **Experiment** — try fragmenting the disk then allocating a large contiguous file!

---

## 💡 OS Concepts Demonstrated

- **External Fragmentation** (Contiguous) — gaps between files prevent large allocations
- **Pointer overhead** (Linked) — each block stores a next-pointer
- **Index block overhead** (Indexed) — one extra block per file for the inode
- **First-fit allocation** — the contiguous allocator uses first-fit strategy
- **FAT (File Allocation Table)** — shown in the bottom panel for all files

---

*Built for OS course project — Dart logic + Flutter UI*
