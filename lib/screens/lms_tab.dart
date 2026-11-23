import 'package:flutter/material.dart';
import '../theme.dart';

class _Mapel {
  const _Mapel(this.kode, this.nama, this.guru, this.warna);
  final String kode, nama, guru;
  final Color warna;
}

const _semuaMapel = [
  _Mapel('BIND', 'BAHASA INDONESIA', 'NUR YULIANDRIANINGTYAS, S.Pd.', Color(0xFF2E8B57)),
  _Mapel('BING', 'BAHASA INGGRIS', 'YUNITA KUSUMA WARDHANI, S.Pd', Color(0xFF1F7ACB)),
  _Mapel('BJ', 'BAHASA JAWA', 'DYAN KARTIKAWATI, S.Pd', Color(0xFF4A55B8)),
  _Mapel('BK', 'BIMBINGAN KONSELING', 'ABDI SHOLIH PRATAMA, S.Pd', Color(0xFF1F7ACB)),
  _Mapel('B.\nJEPANG', 'B. JEPANG', 'IMAM MAULANA BURHANNUDIEN, S.Pd', Color(0xFF6B4A3F)),
  _Mapel('KIK', 'KREATIVITAS, INOVASI, DAN KEWIRAUSAHAAN', '', Color(0xFF2E8B57)),
];

class LmsTab extends StatefulWidget {
  const LmsTab({super.key});
  @override
  State<LmsTab> createState() => _LmsTabState();
}

class _LmsTabState extends State<LmsTab> {
  final _cari = TextEditingController();

  @override
  void dispose() {
    _cari.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final q = _cari.text.trim().toLowerCase();
    final list = _semuaMapel
        .where((m) => q.isEmpty || m.nama.toLowerCase().contains(q) || m.guru.toLowerCase().contains(q))
        .toList();
    return Container(
      color: const Color(0xFFF7FBFA),
      child: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(gradient: C.headerGradient),
            padding: EdgeInsets.fromLTRB(22, MediaQuery.of(context).padding.top + 14, 22, 16),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: Color(0x2E0B7F78), blurRadius: 12, offset: Offset(0, 4))],
                  ),
                  child: const Icon(Icons.school_rounded, color: C.teal, size: 28),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Pembelajaran', style: TextStyle(fontSize: 21, fontWeight: FontWeight.w800)),
                      Text('SMK N 1 Bukateja · XI RPL 1 · Gasal 2026/2027',
                          style: TextStyle(fontSize: 12.5, color: Color(0xFF4B6663))),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 24),
              children: [
                // Pencarian
                Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: const [BoxShadow(color: Color(0x1A0A504C), blurRadius: 14, offset: Offset(0, 4))],
                  ),
                  child: TextField(
                    controller: _cari,
                    onChanged: (_) => setState(() {}),
                    decoration: const InputDecoration(
                      hintText: 'Cari mata pelajaran...',
                      hintStyle: TextStyle(color: C.muted, fontSize: 15),
                      prefixIcon: Icon(Icons.search_rounded, color: Color(0xFF44605D)),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                // Statistik
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: const [BoxShadow(color: Color(0x1A0A504C), blurRadius: 14, offset: Offset(0, 4))],
                  ),
                  child: Row(
                    children: [
                      _stat('${_semuaMapel.length}', 'Mata Pelajaran', C.teal),
                      _divider(),
                      _stat('0', 'Materi', const Color(0xFF2F7DE1)),
                      _divider(),
                      _stat('0', 'Tugas Aktif', C.green),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                const Text('Mata Pelajaran', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700)),
                const SizedBox(height: 12),
                if (list.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(child: Text('Mata pelajaran tidak ditemukan.', style: TextStyle(color: C.muted))),
                  ),
                for (final m in list) _mapelCard(context, m),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _stat(String v, String l, Color c) => Expanded(
        child: Column(
          children: [
            Text(v, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: c)),
            Text(l, style: const TextStyle(fontSize: 12.5, color: C.muted)),
          ],
        ),
      );

  Widget _divider() => Container(width: 1, height: 48, color: C.line);

  Widget _mapelCard(BuildContext context, _Mapel m) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      height: 90,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [BoxShadow(color: Color(0x1F0A504C), blurRadius: 14, offset: Offset(0, 4))],
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(
              content: Text('Materi ${m.nama} belum tersedia'),
              behavior: SnackBarBehavior.floating,
              backgroundColor: C.ink)),
        child: Row(
          children: [
            Container(
              width: 98,
              color: m.warna,
              alignment: Alignment.center,
              child: Container(
                width: 56,
                height: 52,
                alignment: Alignment.center,
                decoration: BoxDecoration(color: const Color(0x47FFFFFF), borderRadius: BorderRadius.circular(14)),
                child: Text(m.kode,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w800, height: 1.2)),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(m.nama,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800)),
                    if (m.guru.isNotEmpty) ...[
                      const SizedBox(height: 3),
                      Text(m.guru,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 11.5, color: C.muted)),
                      const SizedBox(height: 6),
                      Row(children: [_pill('0 Materi'), const SizedBox(width: 8), _pill('0 Tugas')]),
                    ],
                  ],
                ),
              ),
            ),
            if (m.guru.isNotEmpty)
              const Padding(
                padding: EdgeInsets.only(right: 10),
                child: Icon(Icons.chevron_right_rounded, color: Color(0xFFB5C2C0)),
              ),
          ],
        ),
      ),
    );
  }

  Widget _pill(String t) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
        decoration: BoxDecoration(color: C.field, borderRadius: BorderRadius.circular(10)),
        child: Text(t, style: const TextStyle(fontSize: 11, color: C.muted)),
      );
}