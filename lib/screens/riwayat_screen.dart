import 'package:flutter/material.dart';
import '../app_state.dart';
import '../theme.dart';
import '../widgets/common.dart';

class RiwayatScreen extends StatefulWidget {
  const RiwayatScreen({super.key});
  @override
  State<RiwayatScreen> createState() => _RiwayatScreenState();
}

class _RiwayatScreenState extends State<RiwayatScreen> {
  late final List<DateTime> _bulan; // 6 bulan terakhir
  late DateTime _pilih;

  @override
  void initState() {
    super.initState();
    final n = DateTime.now();
    _bulan = List.generate(6, (i) => DateTime(n.year, n.month - i, 1));
    _pilih = _bulan.first;
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final lastDay = (_pilih.year == now.year && _pilih.month == now.month)
        ? now.day
        : DateTime(_pilih.year, _pilih.month + 1, 0).day;
    return Scaffold(
      backgroundColor: const Color(0xFFF7FBFA),
      appBar: pageBar(context, 'Riwayat Presensi'),
      body: AnimatedBuilder(
        animation: AppState.i,
        builder: (context, _) => ListView(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 24),
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFCFE0DC)),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<DateTime>(
                  isExpanded: true,
                  value: _pilih,
                  icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF44605D)),
                  items: [
                    for (final b in _bulan)
                      DropdownMenuItem(value: b, child: Text('${bulan[b.month - 1]} ${b.year}')),
                  ],
                  onChanged: (v) => setState(() => _pilih = v ?? _pilih),
                ),
              ),
            ),
            const SizedBox(height: 12),
            for (var d = 1; d <= lastDay; d++) _hari(DateTime(_pilih.year, _pilih.month, d)),
          ],
        ),
      ),
    );
  }

  Widget _hari(DateTime tgl) {
    final rec = AppState.i.riwayat[dateKey(tgl)];
    final masuk = rec?.masuk;
    final pulang = rec?.pulang;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Color(0x1F0A504C), blurRadius: 14, offset: Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(tglPanjang(tgl), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800)),
          const SizedBox(height: 10),
          _baris('Presensi Masuk', masuk, tgl, masuk == null ? 'Belum Presensi' : (rec!.status ?? 'Tepat Waktu')),
          const SizedBox(height: 10),
          _baris('Presensi Pulang', pulang, tgl, pulang == null ? 'Belum Presensi' : 'Tepat Waktu'),
        ],
      ),
    );
  }

  Widget _baris(String label, String? jam, DateTime tgl, String status) => Row(
        children: [
          RoundAvatar(size: 40, light: jam == null),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                Text(jam == null ? '--:-- | --/--/----' : '$jam | ${tglPendek(tgl)}',
                    style: const TextStyle(fontSize: 12, color: C.muted)),
              ],
            ),
          ),
          StatusChip(status),
        ],
      );
}