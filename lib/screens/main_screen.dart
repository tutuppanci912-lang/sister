import 'package:flutter/material.dart';
import '../theme.dart';
import 'home_tab.dart';
import 'lms_tab.dart';
import 'cbt_tab.dart';
import 'akun_tab.dart';

/// Kerangka utama: 4 tab + tombol Presensi di tengah.
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _index = 0;

  static const _items = <_NavItem>[
    _NavItem('Home', Icons.home_outlined, Icons.home_rounded),
    _NavItem('LMS', Icons.school_outlined, Icons.school_rounded),
    _NavItem('CBT', Icons.assignment_outlined, Icons.assignment_rounded),
    _NavItem('Akun', Icons.person_outline_rounded, Icons.person_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeTab(onSelectTab: (i) => setState(() => _index = i)),
      const LmsTab(),
      const CbtTab(),
      const AkunTab(),
    ];
    return Scaffold(
      extendBody: false,
      body: IndexedStack(index: _index, children: pages),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        width: 72,
        height: 72,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: C.fabGradient,
          border: Border.all(color: Colors.white, width: 5),
          boxShadow: const [BoxShadow(color: Color(0x7308635F), blurRadius: 18, offset: Offset(0, 8))],
        ),
        child: Material(
          color: Colors.transparent,
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: () => Navigator.of(context).pushNamed('/face'),
            child: const Icon(Icons.center_focus_strong_outlined, color: Colors.white, size: 34),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 12,
        height: 74,
        padding: EdgeInsets.zero,
        shape: const CircularNotchedRectangle(),
        notchMargin: 6,
        child: Row(
          children: [
            _tab(0),
            _tab(1),
            const Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: 40),
                child: Center(
                  child: Text('Presensi',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: C.muted)),
                ),
              ),
            ),
            _tab(2),
            _tab(3),
          ],
        ),
      ),
    );
  }

  Widget _tab(int i) {
    final it = _items[i];
    final on = _index == i;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _index = i),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(on ? it.on : it.off, size: 27, color: on ? C.teal : C.muted),
            const SizedBox(height: 3),
            Text(it.label,
                style: TextStyle(
                    fontSize: 12, fontWeight: on ? FontWeight.w700 : FontWeight.w600, color: on ? C.teal : C.muted)),
          ],
        ),
      ),
    );
  }
}

class _NavItem {
  const _NavItem(this.label, this.off, this.on);
  final String label;
  final IconData off, on;
}