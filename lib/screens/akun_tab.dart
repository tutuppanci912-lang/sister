import 'package:flutter/material.dart';
import '../app_state.dart';
import '../theme.dart';
import '../widgets/common.dart';

class AkunTab extends StatelessWidget {
  const AkunTab({super.key});

  @override
  Widget build(BuildContext context) {
    final s = AppState.i;
    return AnimatedBuilder(
      animation: s,
      builder: (context, _) {
        final hadir = s.riwayat.values.where((r) => r.masuk != null).length;
        final izin = s.izin.length;
        return Container(
          color: const Color(0xFFF7FBFA),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Container(
                decoration: const BoxDecoration(gradient: C.headerGradient),
                padding: EdgeInsets.fromLTRB(16, MediaQuery.of(context).padding.top + 24, 16, 20),
                child: Column(
                  children: [
                    ClipOval(child: Image.asset('assets/images/avatar.png', width: 84, height: 84, fit: BoxFit.cover)),
                    const SizedBox(height: 12),
                    Text(s.nama.toUpperCase(),
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: C.inkTeal)),
                    const SizedBox(height: 2),
                    Text('${s.kelas}  |  ${s.sekolah}', style: const TextStyle(fontSize: 13, color: Color(0xFF4B6663))),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 0, 14, 24),
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 12),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: _card(),
                      child: Row(
                        children: [
                          _stat('$hadir', 'Hadir'),
                          _stat('0', 'Sakit'),
                          _stat('$izin', 'Izin'),
                          _stat('0', 'Alpha'),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 12),
                      padding: const EdgeInsets.all(14),
                      decoration: _card(),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(color: const Color(0xFFFDE9E3), borderRadius: BorderRadius.circular(12)),
                            child: const Icon(Icons.shield_outlined, color: C.coral),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text('Poin Pelanggaran', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                                Text('Tahun ajaran 2026/2027', style: TextStyle(fontSize: 12, color: C.muted)),
                              ],
                            ),
                          ),
                          const Text('0', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800)),
                          const Text(' poin', style: TextStyle(fontSize: 12, color: C.muted)),
                          const Icon(Icons.chevron_right_rounded, color: Color(0xFFB5C2C0)),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 12),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: _card(),
                      child: Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Text('Profil', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
                          ),
                          _menu(Icons.person_outline_rounded, 'Data Diri',
                              () => Navigator.of(context).pushNamed('/datadiri')),
                          _menu(Icons.center_focus_weak_rounded, 'Registrasi Wajah',
                              () => toast(context, 'Registrasi wajah belum tersedia di prototipe')),
                          _menu(Icons.refresh_rounded, 'Reset Wajah',
                              () => toast(context, 'Reset wajah belum tersedia di prototipe')),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 12),
                      decoration: _card(),
                      child: ListTile(
                        leading: const Icon(Icons.logout_rounded, color: C.coral),
                        title: const Text('Logout',
                            style: TextStyle(color: C.coral, fontWeight: FontWeight.w700)),
                        onTap: () => _logout(context),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  BoxDecoration _card() => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [BoxShadow(color: Color(0x1A0A504C), blurRadius: 14, offset: Offset(0, 4))],
      );

  Widget _stat(String v, String l) => Expanded(
        child: Column(
          children: [
            Text(v, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
            Text(l, style: const TextStyle(fontSize: 12.5, color: C.muted)),
          ],
        ),
      );

  Widget _menu(IconData ic, String t, VoidCallback onTap) => ListTile(
        leading: Icon(ic, color: C.ink),
        title: Text(t, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        trailing: const Icon(Icons.chevron_right_rounded, color: Color(0xFFB5C2C0)),
        onTap: onTap,
      );

  Future<void> _logout(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Keluar dari akun?'),
        content: const Text('Anda perlu login kembali untuk memakai Hadirku.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Batal')),
          TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Logout', style: TextStyle(color: C.coral))),
        ],
      ),
    );
    if (ok == true && context.mounted) {
      AppState.i.setLogin(false);
      Navigator.of(context).pushNamedAndRemoveUntil('/login', (r) => false);
    }
  }
}